# 通用字段

所有内置组件都能写下面这些字段和 `style`。组件自己的字段见各篇。事件方法写在 [页面 JS](../page-js.md)。

## 字段

| 参数名 | 类型 | 说明 |
|--------|------|------|
| type | String | 组件类型 |
| id | String | 可选。列表用 `bind`，文案用 `{{字段}}` |
| hidden | Boolean | 隐藏 |
| showIf | String | 条件显示，值为作用域路径 |
| action | Object | 轻触后的动作。`type` 为 `navigate` / `redirect` / `switchTab` / `back` / `toast` / `save` / `openUrl` |
| onTap | String | 轻触一次时调用的方法名。`onClick` 视为同一事件 |
| onClick | String | `onTap` 的别名 |
| onDoubleTap | String | 连续轻触两次 |
| onLongPress | String | 按住不放 |
| onChange | String | 值变化时调用，`e.value` 是新值。用于 input / textarea / range / progress / switch / select / menu / picker / date / time / datetime / checkbox / radio / tabs / search |
| onFocus | String | 输入框获得焦点 |
| onBlur | String | 输入框失去焦点 |
| onScroll | String | list / grid：页面滚动且该组件在可见区域时调用 |
| onReachBottom | String | list / grid：该组件底部滚到可视区底部时调用。整页到底见 `Page.onReachBottom` |
| onReachTop | String | list / grid：该组件顶部滚到可视区顶部时调用 |
| style | Object | 样式 |

没有 `onTouchStart` / `onTouchMove` / `onTouchEnd`。底层触摸会和滚动打架，这套 JSON 界面不需要。

同时写 `onTap`（或 `onClick`）和 `action` 时：先调 JS，再执行 `action`。

## Style

颜色用 `#RRGGBB` 或 `#AARRGGBB`。宽高数字单位是 **dp**，字号是 **sp**。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| width | Number / String | 数字 dp，或 `match` / `wrap` / `"50%"` / `"100%"`。`100%` 与 `match` 一样，占满父级 |
| height | Number / String | 同上。`100%` / `match` 占满父级高度 |
| minWidth / minHeight | Number / String | 最小宽高 |
| padding | Number | 四边内边距 dp |
| paddingTop / paddingRight / paddingBottom / paddingLeft | Number | 单边内边距 |
| margin | Number | 四边外边距 dp |
| marginTop / marginRight / marginBottom / marginLeft | Number | 单边外边距 |
| background | String | 背景色 |
| radius | Number | 圆角 dp |
| fontSize | Number | 字号 sp |
| color | String | 文字颜色 |
| fontWeight | String | `bold` / 默认 |
| align | String | 水平：`left` / `center` / `right`。文字对齐，或 column 里子项水平位置 |
| valign | String | 垂直：`top` / `center` / `bottom`。row 默认垂直居中；column 设 `center` 且 `height: "100%"` 可把内容摆在屏幕中间 |
| sticky | String | `top` 吸顶，`bottom` 吸底。只对页面 `body` 第一层有效，滚动时固定 |
| opacity | Number | 0～1 |
| gap | Number | column / row / list / card 子项间距；grid 卡片默认 12 |
| weight | Number | 在 row / 撑满高度的 column 里的权重 |

## 注意

- `sticky` 只对 `body` 第一层有效，写在嵌套子节点上无效。
- 文案、路径类字段支持 `{{path}}`，对应 `Page.data`。
- 列表循环里用 `{{item}}`、`{{item.xxx}}`、`{{index}}`，见 [list](./list.md)。
