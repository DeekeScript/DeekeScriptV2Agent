# datetime

先选年/月/日，再点下一步选时/分。值为 `yyyy-MM-dd HH:mm`。

通用字段见 [通用字段](./_common.md)。也可用 [picker](./picker.md) 的 `mode: "datetime"`。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| label | String | 字段标题 |
| value | String | 默认值，如 `"2026-08-24 09:30"` |
| hint | String | 未选时的占位 |
| position | String | `bottom`（默认）/ `top` |
| min / max | String | 可选，限制范围，格式与值一致 |
| style.color | String | 确定按钮颜色。不写则跟 `window.theme.primary` |

```json
{ "type": "datetime", "name": "when", "label": "开始", "value": "2026-08-24 09:30" }
```
