# Sqlite

本地 SQLite 表存储。写入对象时**自动建表、自动补列**，不必手写 `CREATE TABLE`。适合多行记录与条件查询；简单键值仍用 [`Storage`](Storage.md)。

## 可用上下文

- **page.js** 与 **tasks.js** 都能用。

## 方法

不 `create` 时使用默认库 `deekeScript.db`。`create` 之后，下列方法走返回的实例。

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| create | `create(name: string)` | 库名（可无 `.db`） | `Sqlite` | 打开/创建库 |
| insert | `insert(table: string, data: object)` | 表名、行对象 | `number` | 插入；自动建表/补列；返回新 `id`，失败 `-1` |
| update | `update(table, data, where, options?)` | 表、字段、条件（可 `{}`）、可选 options | `number` | 无 where 时必须带 `limit` |
| delete | `delete(table: string, where: object, options?: object)` | 表、条件（可 `{}`）、可选 options | `number` | 无 where 时必须带 `limit`；options：`limit` / `offset` / `orderBy` |
| find | `find(table: string, where?: object, options?: object)` | 表、可选条件、可选 options | `Array` | where 可空；同上；第二参数也可只传 options |
| findOne | `findOne(table: string, where?: object, options?: object)` | 表、可选条件、可选 options | `object \| null` | where 可空；第二参数也可只传 options |
| count | `count(table: string, where?: object)` | 表、可选条件 | `number` | 行数 |
| sum | `sum(table: string, column: string, where?: object)` | 表、列、可选条件 | `number` | 求和；无数据为 0 |
| avg | `avg(table: string, column: string, where?: object)` | 表、列、可选条件 | `number` | 平均；无数据为 0 |
| max | `max(table: string, column: string, where?: object)` | 表、列、可选条件 | `number \| string \| null` | 最大 |
| min | `min(table: string, column: string, where?: object)` | 表、列、可选条件 | `number \| string \| null` | 最小 |
| group | `group(table: string, spec: object)` | 表、分组规格 | `Array` | `by` 必填；可选 count/sum/avg/max/min/where/orderBy/limit |
| clear | `clear(table: string)` | 表 | `boolean` | 清空行，保留表 |
| drop | `drop(table: string)` | 表 | `boolean` | 删表 |
| tables | `tables()` | 无 | `string[]` | 表名列表 |
| exists | `exists(table: string)` | 表 | `boolean` | 表是否存在 |
| query | `query(sql: string, args?: Array)` | SQL、可选绑定参数 | `Array` | 原始 SELECT |
| scalar | `scalar(sql: string, args?: Array)` | SQL、可选绑定参数 | `any` | 第一行第一列；适合 COUNT/SUM |
| exec | `exec(sql: string, args?: Array)` | SQL、可选绑定参数 | `boolean \| Array` | DDL/写操作为 boolean；SELECT 自动走 query 返回数组 |
| close | `close()` | 无 | `void` | 关闭连接（再写会重开） |
| getName | `getName()` | 无 | `string` | 库文件名 |

表默认带自增主键 `id`。`where` 多键为 AND。表名/列名仅允许 `[A-Za-z_][A-Za-z0-9_]*`。

## 最小片段

```javascript
let db = Sqlite.create('myApp');
db.insert('users', { name: 'tom', age: 18, active: true });
let user = db.findOne('users', { name: 'tom' });
console.log(user.id, user.age);
db.update('users', { age: 20 }, { id: user.id });
```

## 分页与排序

`options`：`{ limit?: number, offset?: number, orderBy?: string | string[] }`。  
`orderBy` 例：`'id ASC'`、`'id desc, age asc'`、`['id DESC', 'age ASC']`（大小写均可）。

```javascript
// 第 2 页，每页 10 条，按 id 倒序
let page = db.find('logs', { type: 'error' }, {
  limit: 10,
  offset: 10,
  orderBy: 'id DESC'
});

// 只要 limit（无 where 时第二参数可直接写 options）
let latest = db.find('logs', { limit: 5, orderBy: 'id DESC' });
```

## 删除条件下最前面的数据

“最前”由 `orderBy` 定义，再配合 `limit`：

```javascript
// 不限条件，删最新 1 条
db.delete('user', {}, { limit: 1, orderBy: 'id DESC' });

// 删除 type=error 中 id 最小的 1 条（最早插入）
db.delete('logs', { type: 'error' }, { limit: 1, orderBy: 'id ASC' });

// 删除最新的 3 条
db.delete('logs', { type: 'error' }, { limit: 3, orderBy: 'id DESC' });
```

等价查询再删：

```javascript
let row = db.findOne('logs', { type: 'error' }, { orderBy: 'id ASC' });
if (row) {
  db.delete('logs', { id: row.id });
}
```

## 聚合

```javascript
db.sum('orders', 'amount');
db.sum('orders', 'amount', { status: 'paid' });
db.avg('orders', 'amount', { status: 'paid' });
db.max('orders', 'amount');
db.min('orders', 'id', { type: 'a' });

// 按 status 分组：计数 + 金额合计
let rows = db.group('orders', {
  by: 'status',
  count: true,
  sum: 'amount',
  where: { year: 2024 },
  orderBy: 'sum DESC',
  limit: 20
});
// [{ status: 'paid', count: 5, sum: 1200 }, ...]

// 多列分组
db.group('orders', { by: ['city', 'status'], count: true, avg: 'amount' });
```

更复杂的 SQL（HAVING、多列同时 sum 等）用 `query`：

```javascript
db.query('SELECT status, SUM(amount) AS total FROM orders GROUP BY status HAVING total > ?', [100]);
```

## 注意

- 对象/数组字段存成 JSON 字符串，读回后需 `JSON.parse`。
- 布尔按 `0/1` 存储；条件里写 `true`/`false` 即可。
- 不要用 Sqlite 替代 Storage 存页面表单键值；索引见 [`INDEX.md`](INDEX.md)。
