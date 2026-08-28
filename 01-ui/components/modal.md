# modal

居中弹出的内容容器，里面可以放表单、按钮。和 [popup](./popup.md) `position: "center"` 同类。用 `showIf` 控制。不占正文布局。

通用字段见 [通用字段](./_common.md)。只有确认/取消文案用 [dialog](./dialog.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| showIf | String | 为真时显示 |
| title | String | 有则显示顶栏 |
| body / children | Array | 弹窗内容 |
| mask | Boolean | 默认 true |
| closeOnMask | Boolean | 点遮罩关闭，默认 true |
| width / height | Number / String | 默认宽约 80% |

```json
{
  "type": "modal",
  "showIf": "open",
  "title": "备注",
  "body": [
    { "type": "textarea", "name": "remark", "label": "备注" },
    { "type": "button", "text": "确定", "onTap": "onOk" }
  ]
}
```
