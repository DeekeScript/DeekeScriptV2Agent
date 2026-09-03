# Storage

键值本地存储（底层 DataStore）。[`page.js` 写入、`tasks.js` 读取](../ui-and-task.md) 靠同一套键。

## 可用上下文

- **page.js** 与 **tasks.js** 都能用。约定：页面 `put*`，脚本 `get*`。

## 方法

不调用 `create` 时使用系统默认库。`create` 之后，下面的 `put`/`get` 走返回的那个实例。

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| create | `create(db: string)` | 库名 | `storage` | 换一套存储。不同模块可用不同 db |
| put | `put(key: string, value: string)` | 键、字符串 | `boolean` | 写字符串 |
| putInteger | `putInteger(key: string, value: number)` | 键、整数 | `boolean` | |
| putBoolean | `putBoolean(key: string, value: boolean)` | 键、布尔 | `boolean` | |
| putDouble | `putDouble(key: string, value: number)` | 键、浮点 | `boolean` | |
| putObj | `putObj(key: string, obj: object \| Array)` | 键、对象或数组 | `boolean` | JSON 值，支持嵌套；不能含 function |
| putArray | `putArray(key: string, arr: Array)` | 键、数组 | `boolean` | 与 `putObj` 写数组等价 |
| getArray | `getArray(key: string)` | 键 | `Array` | 与 `getObj` 读同一键；不存在时为 `[]` |
| get | `get(key: string)` | 键 | `string` | 官方：不存在时返回 null |
| getString | `getString(key: string)` | 键 | `string` | d.ts 有此方法；官方文档未单独说明 |
| getBoolean | `getBoolean(key: string)` | 键 | `boolean` | |
| getDouble | `getDouble(key: string)` | 键 | `number` | |
| getInteger | `getInteger(key: string)` | 键 | `number` | |
| getObj | `getObj(key: string)` | 键 | `object` | |
| remove | `remove(key: string)` | 键 | `any` | 删除该键 |
| clear | `clear()` | 无 | `any` | 清空当前库 |
| contains | `contains(key: string)` | 键 | `boolean` | 是否包含该键 |

默认库也可直接 `Storage.putInteger('zan_rate', 66)`，对应设置页表单的 `name`。

## 最小片段

```javascript
Storage.put('myapp.user', 'test');
let myUser = Storage.get('myapp.user');
console.log(myUser);
```

## 注意

- 读写类型必须成对，否则会读错。
- 键名加项目前缀，例如 `myapp.keyword`。
- 页面和脚本要么都不 `create`，要么 `create` 同一个 db。
- 对象数组 CRUD：读写后建议拷成纯 JS 对象再改再存（`putObj` / `getObj` 或 `putArray` / `getArray`），避免 Rhino 包装对象往返异常。
- 索引见 [`INDEX.md`](INDEX.md)。

## 对象数组

`putObj` 与 `putArray` 都可以写数组：

```javascript
var comments = [
  { id: 'c_1', content: '很棒', enabled: true },
  { id: 'c_2', content: '支持', enabled: true }
];
Storage.putObj('dylc.comments', comments);
var saved = Storage.getObj('dylc.comments');
console.log(saved[0].content);
```

## 嵌套对象

单个配置对象（含嵌套数组 / 对象）用 `putObj` / `getObj`：

```javascript
Storage.putObj('dylc.config', {
  autoStart: true,
  comments: comments
});
var cfg = Storage.getObj('dylc.config');
console.log(cfg.autoStart);
```

`Storage.put(key, value)` 在 value 为对象或数组时会自动走 `putObj` / `putArray`。
