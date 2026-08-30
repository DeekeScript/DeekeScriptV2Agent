# cascader

从字段点开的多级选择。每一级一列同时显示，值为 `/` 拼接的路径（如 `"zj/hz"`）。交互与 [menu](./menu.md) 相同。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| label | String | 字段标题 |
| value | String | 默认路径，如 `"zj/hz"` |
| hint | String | 未选时的占位，默认 `请选择` |
| position | String | `bottom`（默认）/ `top` |
| options / items | Array | `{ label, value, children }`，可多层 |
| onChange | String | 确定后调用，`e.value` 为路径 |
| style.color | String | 确定按钮颜色。不写则跟 `window.theme.primary` |

```json
{
  "type": "cascader",
  "name": "address",
  "label": "地区",
  "options": [
    { "label": "浙江", "value": "zj", "children": [{ "label": "杭州", "value": "hz" }] }
  ]
}
```
