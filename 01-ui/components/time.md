# time

24 小时时 / 分滚轮。值为 `HH:mm`。

通用字段见 [通用字段](./_common.md)。也可用 [picker](./picker.md) 的 `mode: "time"`。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| label | String | 字段标题 |
| value | String | 默认值，如 `"09:30"` |
| hint | String | 未选时的占位 |
| position | String | `bottom`（默认）/ `top` |
| min / max | String | 可选，限制范围，格式 `HH:mm` |
| style.color | String | 确定按钮颜色。不写则跟 `window.theme.primary` |

```json
{ "type": "time", "name": "clock", "label": "时间", "value": "09:30" }
```
