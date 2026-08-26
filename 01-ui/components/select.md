# select

单选下拉。`options` 为字符串，或 `{ "label", "value" }`。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| label | String | 字段标题 |
| value | String | 默认选中项 |
| options | Array | 选项 |
| onChange | String | 切换时调用，`e.value` 为当前值 |

```json
{
  "type": "select",
  "name": "platform",
  "label": "平台",
  "options": [
    { "label": "抖音", "value": "dy" },
    { "label": "小红书", "value": "xhs" }
  ]
}
```

## 注意

`options` 也可写字符串数组：`["高", "中", "低"]`。
