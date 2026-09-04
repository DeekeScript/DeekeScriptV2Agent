# UiObject

无障碍节点。由 [`UiSelector`](UiSelector.md) 查出后，可点击、输入、滚动、读属性。

## 可用上下文

- **tasks.js**：主场景。
- **page.js**：能调用，页面逻辑不要靠操作节点。

## 方法

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| click | `click()` | 无 | `boolean` | 点击。`true` 只表示无障碍已把点击发给节点，不保证界面已响应；`false` 一定没点上 |
| longClick | `longClick()` | 无 | `boolean` | 长按 |
| scrollForward | `scrollForward()` | 无 | `boolean` | 向前滑：下方内容上移或右方内容左移。`false` 可判断到底 |
| scrollBackward | `scrollBackward()` | 无 | `boolean` | 向后滑。`false` 可判断到顶 |
| setSelection | `setSelection(start: number, end: number)` | 起止下标 | `boolean` | 选中输入框文本 |
| copy | `copy()` | 无 | `boolean` | 复制已选中文本 |
| cut | `cut()` | 无 | `boolean` | 剪切已选中文本；仅输入框且已有选区 |
| paste | `paste()` | 无 | `boolean` | 粘贴到文本框。可先 `System.setClip` |
| focus | `focus()` | 无 | `boolean` | 获取焦点 |
| setText | `setText(text: string)` | 要写入的文本 | `boolean` | 设置输入框内容 |
| find | `find(obj: UiSelector)` | 子选择器 | `UiObject[]` | 当前节点子孙中所有符合条件的节点 |
| findOne | `findOne(obj: UiSelector)` | 子选择器 | `UiObject` | 子孙中第一个符合条件的节点 |
| bounds | `bounds()` | 无 | `Rect` | 屏幕上的边界。`Rect` 含 `left`/`top`/`right`/`bottom`，以及 `width()`/`height()`/`centerX()`/`centerY()` |
| text | `text()` | 无 | `string` | 文本 |
| desc | `desc()` | 无 | `string` | 描述（contentDescription） |
| id | `id()` | 无 | `string` | 资源 id |
| children | `children()` | 无 | `this` | 子节点集合，可继续 `find` / `getChildren` |
| length | `length()` | 无 | `number` | 可用 |
| getChildCount | `getChildCount()` | 无 | `number` | 子节点数量 |
| getChildren | `getChildren(index: any)` | 子节点下标 | `UiObject` | 第 index 个子节点 |
| parent | `parent()` | 无 | `UiObject` | 父节点 |
| getDrawingOrder | `getDrawingOrder()` | 无 | `number` | 绘制顺序 |
| isSelected | `isSelected()` | 无 | `boolean` | 是否已选中 |
| isClickable | `isClickable()` | 无 | `boolean` | 是否可点击 |
| isLongClickable | `isLongClickable()` | 无 | `boolean` | 是否可长按 |
| isCheckable | `isCheckable()` | 无 | `boolean` | 是否可选中 |
| isChecked | `isChecked()` | 无 | `boolean` | 是否已勾选 |
| isEnabled | `isEnabled()` | 无 | `boolean` | 是否已启用 |
| isFocusable | `isFocusable()` | 无 | `boolean` | 是否可获焦点 |
| isFocused | `isFocused()` | 无 | `boolean` | 是否已获焦点 |
| isScrollable | `isScrollable()` | 无 | `boolean` | 是否可滚动 |
| isVisibleToUser | `isVisibleToUser()` | 无 | `boolean` | 是否对用户可见 |
| isEditable | `isEditable()` | 无 | `boolean` | 是否可编辑 |
| isPassword | `isPassword()` | 无 | `boolean` | 是否密码框 |
| className | `className()` | 无 | `string` | 类名 |
| getPackageName | `getPackageName()` | 无 | `string` | 所属包名 |
| getHintText | `getHintText()` | 无 | `string` | 提示文本 |

## 最小片段

```javascript
let sendButton = UiSelector().text('发送').findOne();
if (sendButton) {
  sendButton.click();
}
```

## 注意

- `click()` 返回 `true` 不代表业务已完成，只代表无障碍已发送点击。
- `setText` / `paste` / `cut` / `copy` / `setSelection` 针对可编辑节点。
- 坐标点击用 [`Gesture`](Gesture.md)，不要用节点 API 去点像素。
- 索引见 [`INDEX.md`](INDEX.md)。
