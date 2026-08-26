# radio

一组选项里只能选一项，值为当前项。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| label | String | 字段标题 |
| value | String | 默认选中项 |
| options | Array | 选项：字符串，或 `{ "label", "value" }` |
| onChange | String | 切换时调用，`e.value` 为当前值 |

```json
{
  "type": "radio",
  "name": "mode",
  "label": "运行模式",
  "value": "safe",
  "options": [
    { "label": "稳妥", "value": "safe" },
    { "label": "均衡", "value": "normal" }
  ]
}
```
