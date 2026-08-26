# picker

`type: picker` 用 `mode` 区分日期 / 时间 / 日期时间，效果分别等同于 [date](./date.md) / [time](./time.md) / [datetime](./datetime.md)。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| label | String | 字段标题 |
| value | String | 默认值，格式随 `mode` |
| hint | String | 未选时的占位 |
| position | String | `bottom`（默认）/ `top` |
| mode | String | `date`（默认）/ `time` / `datetime`。中文别名：`时间`、`日期时间` |
| min / max | String | 可选，限制范围，格式与当前 mode 一致 |

```json
{ "type": "picker", "name": "day2", "label": "日期", "mode": "date", "hint": "请选择日期" }
```

## 别名

`mode`：`date`（默认）、`time` / `时间`、`datetime` / `日期时间`。
