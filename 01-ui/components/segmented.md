# segmented

同一行里切换几个互斥选项，比 [tabs](./tabs.md) 更紧凑，不带面板内容。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| value | String | 当前选中项 |
| options / items | Array | 字符串，或 `{ label, value }`。`text` 也可用 |
| onChange | String | 切换时调用，`e.value` 为当前值 |

```json
{
  "type": "segmented",
  "name": "range",
  "value": "day",
  "options": [
    { "label": "日", "value": "day" },
    { "label": "周", "value": "week" },
    { "label": "月", "value": "month" }
  ]
}
```
