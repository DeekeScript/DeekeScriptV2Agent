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
| putObj | `putObj(key: string, obj: object)` | 键、对象 | `boolean` | 仅标准 JSON 对象，不能含 function |
| putArray | `putArray(key: string, arr: Array)` | 键、数组 | `boolean` | 改 checkbox 等表单时，元素须都是字符串 |
| getArray | `getArray(key: string)` | 键 | `Array` | |
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
- 索引见 [`INDEX.md`](INDEX.md)。
