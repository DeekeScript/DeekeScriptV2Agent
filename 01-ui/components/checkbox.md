# checkbox

不写 `options` 时是单个勾选，值为布尔；写了 `options` 时值为选中数组。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| label | String | 字段标题或单选项文案 |
| value | Boolean / Array | 单个为布尔；多选项为选中值数组 |
| options | Array | 多选项：字符串，或 `{ "label", "value" }` |
| onChange | String | 变化时调用 |

```json
{ "type": "checkbox", "name": "agree", "label": "已阅读并同意协议", "value": true }
```

```json
{
  "type": "checkbox",
  "name": "platforms",
  "label": "平台",
  "options": [
    { "label": "小红书", "value": "xhs" },
    { "label": "抖音", "value": "dy" }
  ],
  "value": ["xhs"]
}
```
