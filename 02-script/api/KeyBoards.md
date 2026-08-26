# KeyBoards

DeekeScript 输入法。比无障碍 `setText` 更接近真人输入，适合微信、抖音等会检测改文本的场景。可与 [`Hid.md`](./Hid.md) 点击滑动配合。

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
if (!KeyBoards.showInputMethodPicker()) {
  console.log('需要用户手动设置输入法为默认');
  System.sleep(2000);
}

if (KeyBoards.canInput()) {
  KeyBoards.input('文本框新增内容');
  KeyBoards.pressEnter();
}
```

## 注意

- 不可编辑或非标准节点仍用无障碍，不要硬用输入法。
- 系统级按键走 [`Gesture.md`](./Gesture.md) 或 [`Hid.md`](./Hid.md)，不要 `pressKey("HOME")`。
- 先点输入框拿焦点，再 `input`。
