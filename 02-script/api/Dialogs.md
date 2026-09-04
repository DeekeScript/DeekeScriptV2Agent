# Dialogs

APP **在前台**时的弹窗。已到后台时弹不出来，改用 [`FloatDialogs`](FloatDialogs.md)（需悬浮窗权限）。

## 可用上下文

- **page.js**：主场景（权限引导、确认）。
- **tasks.js**：仅当 App 仍在前台。任务里更稳妥用 FloatDialogs。

## 方法

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| show | `show(title: string, content: string)` | 标题、内容 | `void` | 弹出提示 |
| show | `show(title: string)` | 仅标题 | `void` | 内容可省略 |
| confirm | `confirm(title, content, callback)` | 标题、说明、回调 | `void` | 确定/取消后执行回调。`result === true` 为确定 |
| input | `input(title: string, value?)` | 标题、可选默认值 | `string` | 输入框；默认值可传字符串或数字 |

## 最小片段

```javascript
Dialogs.show('提示', '恭喜你，弹窗成功弹出');

Dialogs.confirm('提示', '确定执行吗？', function (result) {
  if (result) {
    console.log('确定');
  }
});
```

## 注意

- `confirm` 不阻塞：弹出后立刻往下执行。权限检查要在回调外把 `false` 返回给调用方，见 [`permission.md`](../permission.md)。
- 回调写成 `function (ok) { ... }`。
- 索引见 [`INDEX.md`](INDEX.md)。
