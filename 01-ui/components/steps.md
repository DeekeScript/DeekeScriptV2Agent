# steps

展示当前走到第几步。`value` 为下标，从 0 开始。一般用按钮 `setData` 改步数。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| value | Number | 当前步骤下标，从 0 开始 |
| items / options | Array | 步骤文案，字符串或 `{ text }` |
| direction | String | `row`（默认）横排；`column` / `vertical` 竖排 |
| onChange | String | 值变化时调用 |
| style.color | String | 已完成步骤颜色。不写则跟 `window.theme.primary` |

```json
{
  "type": "steps",
  "name": "step",
  "value": 1,
  "items": [{ "text": "提交" }, { "text": "审核" }, { "text": "完成" }]
}
```

```json
{ "type": "steps", "name": "tone", "value": 1, "style": { "color": "#1565C0" }, "items": [{ "text": "提交" }, { "text": "审核" }, { "text": "完成" }] }
```
