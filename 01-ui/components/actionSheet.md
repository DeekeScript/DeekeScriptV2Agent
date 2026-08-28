# actionSheet

从底部弹出一组操作。和 [popup](./popup.md) 一样用 `showIf` 控制，点选项后关闭并触发 `onChange`。点遮罩或取消关闭。不占正文布局。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| showIf | String | 为真时显示 |
| title | String | 顶部说明 |
| items / options | Array | `{ text, value }` 或字符串 |
| name | String | 选中后写入 `data` 的键 |
| cancelText / cancel | String | 取消按钮文案，默认 `取消` |
| onChange / onSelect | String | 点某一项时调用，`e.value` 为该项值 |

```json
{
  "type": "actionSheet",
  "showIf": "open",
  "title": "选择来源",
  "items": [
    { "text": "拍照", "value": "camera" },
    { "text": "从相册选择", "value": "album" }
  ]
}
```

```javascript
Page({
  data: { open: false },
  onOpen: function () {
    this.setData({ open: true });
  }
});
```
