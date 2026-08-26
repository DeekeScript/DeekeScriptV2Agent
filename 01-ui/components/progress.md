# progress

可拖动进度条，别名 `slider`。`onChange` 的 `e.value` 为数字。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| label | String | 整行标题 |
| value | Number | 默认值；不写则用 `min` |
| min | Number | 最小值，默认 `0` |
| max | Number | 最大值，默认 `100` |
| step | Number | 步进，默认 `1` |
| unit | String | 显示在当前值后面，如 `%` |
| showValue | Boolean | 是否显示当前值，默认 `true` |
| disabled / readonly | Boolean | 不可拖动，只展示 |

```json
{
  "type": "progress",
  "name": "speed",
  "label": "运行速度",
  "value": 50,
  "min": 0,
  "max": 100,
  "unit": "%"
}
```

## 别名

`type` 可写 `slider`，字段相同。

```json
{ "type": "slider", "name": "delay", "label": "间隔", "value": 1500, "min": 500, "max": 3000, "step": 500, "unit": "ms" }
```
