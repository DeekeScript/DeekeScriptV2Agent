# dialog

居中确认框，带标题、说明和取消 / 确定。用 `showIf` 控制显示。不占正文布局。

通用字段见 [通用字段](./_common.md)。自定义内容用 [modal](./modal.md) 或 [popup](./popup.md) `position: "center"`。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| showIf | String | 为真时显示 |
| title | String | 标题 |
| text / message | String | 说明 |
| cancelText / cancel | String | 取消文案，默认 `取消`。`hideCancel: true` 只留确定 |
| confirmText / okText | String | 确定文案，默认 `确定` |
| mask | Boolean | 遮罩，默认 true |
| closeOnMask | Boolean | 点遮罩关闭，默认 true |
| onConfirm | String | 点确定 |
| onCancel | String | 点取消或点遮罩 |

```json
{
  "type": "dialog",
  "showIf": "open",
  "title": "确认删除",
  "text": "删除后无法恢复",
  "onConfirm": "onOk"
}
```
