# progressCircle

圆环进度，只展示不拖动。浅色底环，深色是已完成占比。默认边长 88、环宽 10。

通用字段见 [通用字段](./_common.md)。直线进度见 [progress](./progress.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| label | String | 字段标题 |
| value | Number | 当前值 |
| min / max | Number | 默认 0 / 100 |
| unit | String | 中间文字后缀，如 `%` |
| size | Number | 边长 dp，默认 88 |
| strokeWidth | Number | 环宽 dp，默认 10 |
| showValue | Boolean | 是否显示中间数值，默认 true |
| style.color | String | 进度色，默认主题绿 |
| trackColor | String | 底环颜色，默认 `#DAE5E3` |

```json
{ "type": "progressCircle", "name": "done", "value": 70, "unit": "%", "size": 88 }
```
