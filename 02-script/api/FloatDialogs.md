# FloatDialogs

基于悬浮窗的弹窗与 toast。APP 已在后台时用这一套，不要用 [`Dialogs`](Dialogs.md) / `System.toast`。需要悬浮窗权限。弹窗会保持屏幕常亮。

## 可用上下文

- **tasks.js**：主场景（后台提示、确认）。
- **page.js**：显示/隐藏项目悬浮球、临时禁止点球以免误点。

## 方法

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| show | `show(title: string, content: string)` | 标题、内容 | `void` | 后台弹窗 |
| show | `show(content: string)` | 仅内容 | `void` | 标题可省略 |
| toast | `toast(content: string)` | 文案 | `void` | 后台短 toast，效果同 `System.toast` |
| toastLong | `toastLong(content: string)` | 文案 | `void` | 较长 toast |
| setFloatWindowClickable | `setFloatWindowClickable(clickable: boolean)` | 右侧悬浮窗是否可点 | `void` | 避免手势点到悬浮窗。异步，设置后建议 `System.sleep(300)` |
| closeAll | `closeAll()` | 无 | `void` | 关闭所有此类弹窗 |
| setFloatWindowVisible | `setFloatWindowVisible(visible: boolean)` | 是否显示项目悬浮球 | `void` | 隐藏后不会靠这颗球保持常亮。无权限时不要调用 |
| confirm | `confirm(title, content, confirmText, cancelText, callback)` | 标题、内容、确定文案、取消文案、回调 | `boolean` | **阻塞**直到用户点按钮或回调返回 `true`。确定 true、取消 false。回调参数为 `FloatDialog`，可 `setContent`。返回 `true` 自动关；`false` 或不返回则继续等 |

`FloatDialog.setContent(content: string)`：动态改确认框内容。

官方：`confirm` 需要在初始化 FloatDialogs 时传入 scope 才能使用。

## 最小片段

```javascript
FloatDialogs.show('温馨提示', '任务已开始');
```

## 注意

- 点坐标前可先 `setFloatWindowClickable(false)`，点完再 `true`，见 [`Gesture`](Gesture.md)。
- `confirm` 会卡住当前线程，不要在页面 `onLoad` 里滥用。
- 任务或调试里如果用过 `show` / `confirm`：下次找节点、点击前先 `FloatDialogs.closeAll()`，避免弹窗挡操作。短提示优先 `toast`。
- 索引见 [`INDEX.md`](INDEX.md)。
