# switch

布尔开关：左侧文案，右侧滑动开关，不是勾选框。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| label | String | 开关说明 |
| value | Boolean | 默认值 |
| onChange | String | 切换时调用，`e.value` 为布尔 |

```json
{
  "type": "switch",
  "name": "auto_start",
  "label": "自动开始",
  "value": false
}
```
