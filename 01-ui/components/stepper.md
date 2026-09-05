# stepper

加减数字，中间数字可直接输入。`step` 可为小数。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| label | String | 字段标题 |
| value | Number | 当前值 |
| min | Number | 最小值，默认 0 |
| max | Number | 最大值，默认 99 |
| step | Number | 每次加减，默认 1 |
| onChange | String | 变化时调用，`e.value` 为数字。写在 list / grid 行内时还有 `e.item`、`e.index` |
| style.color | String | 加减按钮颜色。不写则跟 `window.theme.primary` |

```json
{ "type": "stepper", "name": "count", "label": "关注数量", "value": 3, "min": 1, "max": 20 }
```

```json
{ "type": "stepper", "name": "blue_count", "label": "蓝色加减", "value": 5, "style": { "color": "#1565C0" } }
```
