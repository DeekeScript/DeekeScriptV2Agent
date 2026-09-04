# UiSelector

筛选当前屏幕上的无障碍节点。链式附加条件后调用 `find` / `findOne` 等得到 [`UiObject`](UiObject.md)。

## 可用上下文

- **tasks.js**：主场景。找按钮、输入框、列表项。
- **page.js**：能调用，但页面逻辑不要靠找节点。

构造：`UiSelector(simpleMode)`。不传或 `true` 为简单模式；`false` 为复杂模式（能看到更多节点，含状态栏等系统节点）。`UiSelector(true)` 与 `UiSelector()` 相同。

## 方法

筛选条件均返回选择器自身，便于链式调用。

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| UiSelector | `UiSelector(simpleMode?: boolean)` | `simpleMode` 可选，默认简单模式 | `UiSelector` | 创建选择器 |
| setLevel | `setLevel(level: number)` | `level` 层级 | `UiSelector` | 限制查找层级 |
| getLevel | `getLevel()` | 无 | `number` | 当前层级限制 |
| id | `id(id: string)` | 资源 id | `UiSelector` | 节点 id 等于该字符串（viewIdResourceName） |
| className | `className(className: string)` | 类名，如 `TextView` | `UiSelector` | className 等于该字符串 |
| classNameMatches | `classNameMatches(className: string)` | 正则或字符串 | `UiSelector` | className 正则匹配 |
| bounds | `bounds(left, top, right, bottom)` | 四边相对屏幕的距离 | `UiSelector` | 按 bounds 范围筛选 |
| text | `text(text: string)` | 完整文本 | `UiSelector` | text 等于该字符串 |
| textContains | `textContains(text: string)` | 子串 | `UiSelector` | text 包含该字符串；可链式多次 |
| textMatches | `textMatches(text: string)` | 正则或字符串 | `UiSelector` | text 正则匹配；普通字符串效果接近包含 |
| textStartsWith | `textStartsWith(text: string)` | 前缀 | `UiSelector` | text 以前缀开头 |
| textEndsWith | `textEndsWith(text: string)` | 后缀 | `UiSelector` | text 以后缀结尾 |
| desc | `desc(desc: string)` | 完整描述 | `UiSelector` | contentDescription 等于该字符串 |
| descContains | `descContains(desc: string)` | 子串 | `UiSelector` | 描述包含该字符串 |
| descMatches | `descMatches(desc: string)` | 正则或字符串 | `UiSelector` | 描述正则匹配 |
| descStartsWith | `descStartsWith(desc: string)` | 前缀 | `UiSelector` | 描述以前缀开头 |
| descEndsWith | `descEndsWith(desc: string)` | 后缀 | `UiSelector` | 描述以后缀结尾 |
| clickable | `clickable(bool: boolean)` | 是否可点击 | `UiSelector` | |
| selected | `selected(bool: boolean)` | 是否已选择 | `UiSelector` | |
| checked | `checked(bool: boolean)` | 是否被选中 | `UiSelector` | |
| enabled | `enabled(bool: boolean)` | 是否可交互；`false` 表示禁用 | `UiSelector` | |
| scrollable | `scrollable(bool: boolean)` | 是否可滚动 | `UiSelector` | |
| checkable | `checkable(bool: boolean)` | 是否可选中 | `UiSelector` | 是否 checkable |
| focusable | `focusable(bool: boolean)` | 是否可获焦点 | `UiSelector` | |
| focused | `focused(bool: boolean)` | 是否已获焦点 | `UiSelector` | |
| editable | `editable(bool: boolean)` | 是否可编辑 | `UiSelector` | |
| isVisibleToUser | `isVisibleToUser(bool: boolean)` | 是否对用户可见 | `UiSelector` | |
| filter | `filter(filter: (v: UiObject) => boolean)` | 回调；返回 false 则丢掉该节点 | `UiSelector` | 对已匹配节点再过滤；可链式再接 `findOne` / `find` |
| exists | `exists()` | 无 | `boolean` | 当前条件能否匹配到节点 |
| waitFindOne | `waitFindOne()` | 无 | `UiObject` | 一直阻塞，直到节点出现 |
| find | `find()` | 无 | `UiObject[]` | 所有匹配节点 |
| findBy | `findBy(obj: UiSelector)` | 另一个选择器 | `UiObject[]` | 在当前结果及其子孙中再查 |
| findBy | `findBy(timeout: number)` | 最长等待毫秒 | `UiObject[]` | 节点未出现则最多等 timeout |
| findOne | `findOne()` | 无 | `UiObject` | 第一个匹配节点 |
| findOnce | `findOnce()` | 无 | `UiObject` | 第一个匹配节点 |
| findOneBy | `findOneBy(obj: UiSelector)` | 另一个选择器 | `UiObject` | 类似 findBy，找到一个立刻返回 |
| findOneBy | `findOneBy(timeout: number)` | 最长等待毫秒 | `UiObject` | 类似 findBy(timeout)，找到一个立刻返回 |

## 最小片段

```javascript
let sendButton = UiSelector().text('发送').findOne();
if (sendButton) {
  sendButton.click();
}
```

## 用 filter 过滤屏幕外节点（默认要做）

生成点击代码时，**一般先 `filter` 再 `findOne` / `find`**：只保留屏幕内、尺寸有效的节点。很少需要操作屏幕外内容；预加载 / 列表复用等场景里，同 id 常有多份节点，裸 `findOne()` 容易先拿到屏幕外的（`bounds.top < 0`），一点击就偏。`isVisibleToUser(true)` **不能代替**几何校验。

```javascript
let likeBtn = UiSelector()
  .id('com.ss.android.ugc.aweme:id/gpf')
  .filter(function (node) {
    if (!node) {
      return false;
    }
    let b = node.bounds();
    if (!b || b.width() <= 0 || b.height() <= 0) {
      return false;
    }
    if (b.left < 0 || b.top < 0) {
      return false;
    }
    if (b.right > Device.width() || b.bottom > Device.height()) {
      return false;
    }
    return true;
  })
  .findOne();
if (likeBtn) {
  likeBtn.click();
}
```

只要右侧操作栏时，可在 `filter` 里再加 `b.left > Device.width() * 0.7`。回调可用 `function` 或箭头。

## 注意

- 生成代码优先 `findOne()`（`findOnce()` 与之等价，不必再写）。
- **点击前一般先 `filter` 屏内**（见上），不要裸 `findOne()` 就点。
- 禁止全局 `text('发送')`，必须 `UiSelector().text('发送')`。
- `waitFindOne()` 会一直阻塞，任务里慎用；需要超时用 `findOneBy(timeout)` / `findBy(timeout)`。
- 需要系统节点时：`UiSelector(false)`。
- 节点操作见 [`UiObject.md`](UiObject.md)。索引见 [`INDEX.md`](INDEX.md)。
