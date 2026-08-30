# badge

红色角标，常和 [row](./row.md) 并排。tabs 选项和底部菜单也可写 `badge` 字段。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| text / title / label | String | 角标数字或文字；不写则显示红点 |
| style.background | String | 自定义底色 |

```json
{
  "type": "row",
  "style": { "gap": 6 },
  "children": [
    { "type": "text", "text": "未读消息", "style": { "weight": 1 } },
    { "type": "badge", "text": "12" }
  ]
}
```

## 注意

不写 `text` 时只显示红点：`{ "type": "badge" }`。

```json
{ "type": "badge", "text": "蓝", "style": { "background": "#1565C0" } }
```
