# progress

只展示当前进度，**不能拖动**。用 `value` 或 `this.setData` 改数值。别名 `progressBar`。

用户要调节的数值（运行速度、点赞概率）必须用 [slider](./slider.md)。

通用字段见 [通用字段](./_common.md)。圆环见 [progressCircle](./progressCircle.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| label | String | 整行标题 |
| value | Number | 当前进度；不写则用 `min` |
| min | Number | 最小值，默认 `0` |
| max | Number | 最大值，默认 `100` |
| unit | String | 显示在当前值后面，如 `%` |
| showValue | Boolean | 是否显示当前值，默认 `true` |
| strokeWidth / style.height | Number | 条高度 dp，默认 6 |
| style.color | String | 进度色，默认主题绿 |
| trackColor | String | 底条颜色，默认 `#E3EBEA` |

```json
{ "type": "progressBar", "name": "upload", "label": "上传进度", "value": 70, "unit": "%" }
```

```json
{ "type": "progressBar", "name": "task", "label": "任务进度", "value": 50, "min": 0, "max": 100, "unit": "%" }
```

## 别名

`type` 可写 `progress` 或 `progressBar`，字段相同。
