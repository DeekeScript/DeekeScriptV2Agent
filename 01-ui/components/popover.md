# popover

小气泡说明，贴在某个按钮或组件旁边，不是铺满屏幕底。四个角都是圆角，默认带指向触发组件的箭头。

`for` / `anchor` 写触发组件的 `id`；不写则贴在最后点的那个组件旁。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| showIf | String | 为真时显示 |
| for / anchor / target | String | 贴在哪个组件旁，对应那个组件的 `id` |
| text / title | String | 气泡文案 |
| position | String | 相对触发组件：`bottom`（默认）/ `top` / `left` / `right` / `center` |
| arrow | Boolean | 是否显示箭头，默认 true。`position: center` 时不显示 |
| mask | Boolean | 默认 true，点遮罩关闭 |
| style.background | String | 气泡底色，默认 `#191C1C` |
| style.color | String | 文案颜色，默认白色 |
| style.radius | Number | 圆角，默认 8，四个角相同 |
| body / children | Array | 可选，气泡里再放组件 |

```json
{ "type": "button", "id": "tip", "text": "显示说明", "onTap": "onOpen" }
```

```json
{ "type": "popover", "for": "tip", "showIf": "open", "text": "点这里可以筛选", "position": "bottom" }
```
