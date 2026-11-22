# modal

居中弹出的内容容器，里面可以放表单。和 [popup](./popup.md) `position: "center"` 同类。用 `showIf` 控制。不占正文布局。

表单放 `body`。右下角按钮放 `footer`，固定在滚动区外面，不跟内容滚动。键盘把弹层顶高时按钮仍留在底部。只有确认/取消文案、不要表单时用 [dialog](./dialog.md)。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| showIf | String | 为真时显示 |
| title | String | 有则显示顶栏 |
| body / children | Array | 弹窗内容。不要把操作按钮放这里 |
| footer / actions / buttons | Array / Object | 右下角按钮。数组或单个对象。没写 `type` 的项当成按钮 |
| mask | Boolean | 默认 true |
| closeOnMask | Boolean | 点遮罩关闭，默认 true |
| width / height | Number / String | 默认宽约 80% |

```json
{
  "type": "modal",
  "showIf": "open",
  "title": "备注",
  "body": [
    { "type": "textarea", "name": "remark", "label": "备注" }
  ],
  "footer": [
    { "type": "button", "text": "取消", "variant": "outline", "size": "sm", "onTap": "onClose" },
    { "type": "button", "text": "保存", "size": "sm", "onTap": "onSave" }
  ]
}
```
