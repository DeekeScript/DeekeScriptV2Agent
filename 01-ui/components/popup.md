# popup

盖在当前页上的弹层，不是新页面。写在页面根上的 `popups` 里，或 `body` 里用 `type: popup`（同样画到最上层，不占正文布局）。

显示隐藏写 `showIf`，用 `this.setData` 改那个字段，或 `this.showPopup('open')` / `this.hidePopup('open')`（也可写弹层 `id`）。遮罩跟弹层共用这个条件，点遮罩会把该字段写成 `false`。

通用字段见 [通用字段](./_common.md)。方法见 [页面 JS](../page-js.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| showIf | String | 为真时显示弹层和遮罩 |
| id | String | 可选标记 |
| position | String | `bottom`（默认）/ `top` / `left` / `right` / `center`。也可用 `上` `下` `左` `右` `中` |
| title | String | 有则显示顶栏（取消会把 `showIf` 写成 false） |
| mask | Boolean | 是否显示遮罩，默认 true |
| closeOnMask | Boolean | 点遮罩是否关闭，默认 true |
| width / height | Number / String | 数字 dp，或 `"80%"`。底部/顶部默认为满宽；侧边默认宽 80%；居中默认宽 80% |
| style.radius | Number | 圆角 dp，默认 12。底部圆上面两角，顶部只圆下面两角，侧边圆内侧，居中四角都圆 |
| style.radiusTopLeft / radiusTopRight / radiusBottomRight / radiusBottomLeft | Number | 单独指定某一角 |
| style.background | String | 背景色，默认 `#FFFFFF` |
| style.borderColor | String | 边框颜色；只写颜色时宽度默认 1 |
| style.borderWidth | Number | 边框宽度 dp |
| body / children | Array | 弹层里的节点，和页面 `body` 一样 |

```json
{
  "body": [
    { "type": "button", "text": "编辑", "onTap": "onOpenForm" }
  ],
  "popups": [
    {
      "title": "编辑备注",
      "position": "bottom",
      "showIf": "formOpen",
      "body": [
        { "type": "textarea", "name": "remark", "label": "备注" },
        { "type": "button", "text": "保存", "onTap": "onSaveForm" }
      ]
    }
  ]
}
```

```javascript
Page({
  data: {
    formOpen: false,
    remark: ''
  },
  onOpenForm() {
    this.showPopup('formOpen');
  },
  onSaveForm() {
    this.hidePopup('formOpen');
  }
});
```

## 注意

- `type: popup` 写在 `body` 里与根上 `popups` 效果相同，都盖在最上层。
- 打开关闭自带过渡：底部上滑、顶部下滑、侧边滑入、居中缩放淡入。
- `this.showPopup('formOpen')` 的参数是 `showIf` 字段名或弹层 `id`。
