# date

弹出方式和 [menu](./menu.md) 一样：底部（或顶部）多列滚轮，点确定写入。值为 `yyyy-MM-dd`。

通用字段见 [通用字段](./_common.md)。也可用 [picker](./picker.md) 的 `mode: "date"`。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| label | String | 字段标题 |
| value | String | 默认值，如 `"2026-08-24"` |
| hint | String | 未选时的占位 |
| position | String | 同 Menu：`bottom`（默认）/ `top` |
| min / max | String | 可选，限制范围，格式 `yyyy-MM-dd` |

```json
{ "type": "date", "name": "day", "label": "日期", "value": "2026-08-24" }
```
