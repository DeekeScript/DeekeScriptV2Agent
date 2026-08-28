# imageViewer

全屏看图，盖在当前页上，不占正文布局。用 `showIf` 打开，点图片或遮罩关闭。点哪张缩略图，就把下标写进 `index`。

通用字段见 [通用字段](./_common.md)。同类 overlay 还有 [popup](./popup.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| showIf | String | 为真时显示 |
| urls / images | Array | 图片路径列表 |
| index | Number | 打开时显示第几张，从 0 开始。可写 `{{index}}` |
| bind | String | 也可用数组字段代替 `urls` |

```json
{ "type": "avatar", "src": "img/a.png", "onTap": "onOpen" }
```

```json
{ "type": "imageViewer", "showIf": "open", "index": "{{index}}", "urls": ["img/a.png", "img/b.png"] }
```

```javascript
Page({
  data: { open: false, index: 0 },
  onOpen: function () {
    this.setData({ open: true, index: 0 });
  }
});
```
