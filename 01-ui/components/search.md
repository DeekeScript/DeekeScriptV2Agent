# search

圆角搜索框，**默认左侧有放大镜**。高度默认 48dp，与中号输入框一致。`type` 写 `search` 或 `searchBar` 均可。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键，常用 `keyword` |
| hint / placeholder | String | 占位，默认 `搜索` |
| value | String | 默认值 |
| icon | String / Boolean | 左侧图标。不写则用内置放大镜；图片路径可替换；`false` / `none` 隐藏 |
| iconSize | Number | 图标边长 dp，默认 18 |
| shape | String | `round`（默认圆角）/ `square` 直角一些 |
| showCancel / cancel | Boolean / String | 右侧取消按钮。`true` 文案为 `取消`；字符串则作为按钮文案 |
| cancelText | String | 取消按钮文案 |
| disabled | Boolean | 不可输入 |
| onChange | String | 内容变化时调用，`e.value` 是关键字 |
| onSearch | String | 键盘搜索键，`e.value` 是关键字 |
| onCancel | String | 点取消时调用，并清空输入 |

```json
{ "type": "searchBar", "name": "keyword", "hint": "搜索任务" }
```

```json
{ "type": "searchBar", "name": "q", "hint": "搜索", "showCancel": true, "onSearch": "onQuery" }
```

键盘搜索键走 `onSearch`（没有则走 `onChange`）。
