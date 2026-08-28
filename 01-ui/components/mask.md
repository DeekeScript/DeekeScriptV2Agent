# mask

盖住整页的半透明层。和弹层自带的遮罩不同：Mask 是独立组件，用来压暗背景、阻止误点，也可以在上面叠加载、按钮。别名 `overlay`。

通用字段见 [通用字段](./_common.md)。整页加载圈优先 `this.showLoading`，见 [loading](./loading.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| showIf | String | 为真时显示 |
| opacity | Number | 透明度 0～1，默认 `0.4`。大于 1 时按百分数，如 `45` 即 45% |
| color | String | `black`（默认）/ `white`，或 `#RRGGBB` / `#AARRGGBB` |
| style.background | String | 直接指定蒙层色，优先于 `color` / `opacity` |
| closeOnTap / closeOnMask | Boolean | 点空白是否关闭，默认 true |
| onTap | String | 点空白时调用 |
| body / children | Array | 叠在蒙层上的内容，点内容不会关闭 |

```json
{ "type": "mask", "showIf": "open", "opacity": 0.45 }
```

```json
{
  "type": "mask",
  "showIf": "busy",
  "children": [{ "type": "loading", "text": "正在同步…" }]
}
```
