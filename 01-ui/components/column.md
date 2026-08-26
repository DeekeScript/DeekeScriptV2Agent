# column

纵向排列子项。在一屏内居中时设 `height: "100%"`，再写 `align` / `valign`。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| children | Array | 子组件 |
| style.gap | Number | 子项间距 dp |
| style.align | String | 子项水平位置：`left` / `center` / `right` |
| style.valign | String | 子项垂直位置：`top` / `center` / `bottom` |
| style.height | Number / String | `"100%"` 占满可见区域，配合 valign 居中 |

```json
{
  "type": "column",
  "style": { "gap": 8, "height": "100%", "valign": "center", "align": "center" },
  "children": [
    { "type": "title", "text": "欢迎" },
    { "type": "button", "text": "开始" }
  ]
}
```
