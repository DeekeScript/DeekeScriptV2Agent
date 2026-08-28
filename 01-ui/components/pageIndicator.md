# pageIndicator

一排或一列圆点 / 短条，表示当前页。可和 [swiper](./swiper.md) 分开用。点选会改 `value`（从 0 起）。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| count | Number | 点数 |
| value | Number | 当前下标，从 0 起 |
| variant | String | `dot`（默认）/ `line` 短条 |
| direction | String | `row`（默认）横排；`column` / `vertical` 竖排 |
| onChange | String | 点选后调用，`e.value` 为下标 |

```json
{ "type": "pageIndicator", "name": "page", "count": 5, "value": 1 }
```

```json
{ "type": "pageIndicator", "name": "page", "count": 5, "direction": "column" }
```
