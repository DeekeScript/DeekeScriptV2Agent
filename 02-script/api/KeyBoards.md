# KeyBoards

DeekeScript 输入法。这是**可选增强**，不是默认输入方案。可与 [`Hid.md`](./Hid.md) 点击滑动配合。

## 默认输入顺序（生成代码必遵）

1. 无障碍 [`UiObject.setText`](UiObject.md)
2. 不行再用剪贴板：`System.setClip` + [`paste`](UiObject.md)
3. **仅当业务明确需要输入法**时再用 `KeyBoards`，并且：
   - 先 `canInput()`（可先看 `isEnabled()`）
   - 状态不对 → `FloatDialogs.toast` / `show` 提示用户启用并设为默认，不要静默继续

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 引导用户去设置输入法可以 |
| `tasks/*.js` | 实际输入在任务里 |

## 前置

1. 系统设置里启用该输入法。
2. **必须设为默认输入法**。只启用未设默认时 `isEnabled()` 为 true，但 `canInput()` 为 false。
3. 打包后输入法名称变成「XXX输入法」，XXX 为 App `name`。
4. 输入前目标框必须先获得焦点，否则 `input` 仍可能返回 `true` 但没写进去。

开启路径：设置 → 搜索「输入法」→ 默认 → 选 DeekeScript（或打包后的「XXX输入法」）。

## 方法

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `isEnabled()` | 无 | `boolean` | 是否已启用（不等于可输入） |
| `canInput()` | 无 | `boolean` | 是否已是默认输入法，能输入 |
| `input(str)` | `string` | `boolean` | 往当前焦点框尾部插入文字 |
| `delete()` | 无 | `boolean` | 删一个字符。删完全部就按文本长度循环调用 |
| `hide()` | 无 | `boolean` | 隐藏键盘 |
| `pressKey(key)` | `string` 或数字（如 `KeyBoards.KEYCODE.ENTER`） | `boolean` | 文本相关按键。不能发 HOME / BACK / POWER |
| `pressEnter()` | 无 | `boolean` | 等同 `pressKey("ENTER")` |
| `pressTab()` | 无 | `boolean` | 等同 `pressKey("TAB")` |
| `pressSpace()` | 无 | `boolean` | 等同 `pressKey("SPACE")` |
| `showInputMethodPicker()` | 无 | `boolean` | 已是默认返回 true；未启用跳转启用页；已启用未默认弹出选择器 |

`pressKey` 字符串（不区分大小写）：`ENTER`、`DEL` / `DELETE`、`TAB`、`SPACE`、`UP`、`DOWN`、`LEFT`、`RIGHT`、`CENTER`、`ESCAPE` / `ESC`、`FORWARD_DEL`、`MOVE_HOME`、`MOVE_END`、`PAGE_UP`、`PAGE_DOWN`。

## 最小片段

```javascript
if (!KeyBoards.canInput()) {
  FloatDialogs.toast('请将 DeekeScript 输入法设为默认后再试');
  KeyBoards.showInputMethodPicker();
} else {
  KeyBoards.input('文本框新增内容');
  KeyBoards.pressEnter();
}
```

## 注意

- 不要默认生成 KeyBoards 流程；优先 `setText` / 剪贴板。
- 不可编辑或非标准节点仍用无障碍，不要硬用输入法。
- 系统级按键走 [`Gesture.md`](./Gesture.md) 或 [`Hid.md`](./Hid.md)，不要 `pressKey("HOME")`。
- 先点输入框拿焦点，再 `input`。
- **点完输入框后不要沿用旧节点**：占位框与聚焦后的真实框常不是同一个；即使改用 KeyBoards，也要先确认焦点在新框上。无障碍路径见 [`stale-node-after-click.md`](../pitfalls/stale-node-after-click.md)、配方 [`comment-input.md`](../../03-recipes/comment-input.md)。
