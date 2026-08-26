# 弹层 popup

给当前页加遮罩弹层、嵌自定义组件时读这篇。弹层盖在当前页上，不是新页面，不进返回栈。写在页面根上的 `popups`，或 `body` 里用 `type: popup`（同样画到最上层，不占正文布局）。显示隐藏用 `showIf`，或 `this.showPopup` / `this.hidePopup`。点遮罩会把对应字段写成 `false`。

## popups 字段

| 参数名 | 类型 | 说明 |
|--------|------|------|
| showIf | String | 为真时显示弹层和遮罩 |
| id | String | 可选标记，给 `showPopup(id)` 用 |
| position | String | `bottom`（默认）/ `top` / `left` / `right` / `center`。也可用 `上` `下` `左` `右` `中` |
| title | String | 有则显示顶栏（取消会把 `showIf` 写成 false） |
| mask | Boolean | 是否显示遮罩，默认 true |
| closeOnMask | Boolean | 点遮罩是否关闭，默认 true |
| width / height | Number / String | 数字 dp，或 `"80%"`。底部/顶部默认满宽；侧边默认宽 80%；居中默认宽 80% |
| style.radius | Number | 圆角 dp，默认 12。只圆内侧：底部圆上面两角，顶部只圆下面两角，侧边圆内侧，居中四角都圆 |
| style.radiusTopLeft 等 | Number | 单独指定某一角 |
| style.background | String | 背景色，默认 `#FFFFFF` |
| style.borderColor | String | 边框颜色；只写颜色时宽度默认 1 |
| style.borderWidth | Number | 边框宽度 dp |
| body / children | Array | 弹层里的节点，和页面 `body` 一样 |

打开关闭自带过渡：底部上滑、顶部下滑、侧边滑入、居中缩放淡入，遮罩同时淡入淡出。

## showIf 与 showPopup

`showPopup` 会去 `popups`（以及 body 里的 `type: popup`）里找 `id` 或 `showIf`，再把对应字段写成 `true`。找不到就把参数当成数据路径。也可以 `this.setData({ open: true })`。

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
  onOpenForm: function () {
    this.showPopup('formOpen');
  },
  onSaveForm: function () {
    this.hidePopup('formOpen');
  }
});
```

## 嵌自定义组件

外壳（遮罩、标题、取消）仍由 popup 负责。组件写在弹层 `body` 里。弹层显示时组件 `attached`，隐藏时 `detached`。组件规格见 [自定义组件](../component-custom.md)。

```json
{
  "popups": [
    {
      "title": "选关键词",
      "position": "bottom",
      "showIf": "open",
      "body": [
        { "type": "choose", "id": "picker", "onConfirm": "onPicked" }
      ]
    }
  ]
}
```

```javascript
Page({
  data: {
    open: false,
    picked: '未选'
  },
  onOpen: function () {
    this.showPopup('open');
  },
  onPicked: function (e) {
    var d = e && e.detail ? e.detail : {};
    this.setData({ open: false, picked: d.keyword || '未选' });
  }
});
```
