# console

调试输出，以及日志悬浮窗的显示与样式。DeekeScript 里**唯一首字母小写**的全局对象。写文件请用 [`Log`](Log.md)。

## 可用上下文

- **page.js** 与 **tasks.js** 都能用。

## 方法

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| log | `log(...message: any[])` | 任意参数 | `void` | 打印并换行 |
| warn | `warn(...message: any[])` | 任意参数 | `void` | 警告 |
| error | `error(...message: any[])` | 任意参数 | `void` | 错误 |
| info | `info(...message: any[])` | 任意参数 | `void` | 重要信息，优先级高于 log |
| debug | `debug(...message: any[])` | 任意参数 | `void` | 调试输出 |
| trace | `trace(...message: any[])` | 任意参数 | `void` | 可用 |
| show | `show()` | 无 | `void` | 显示日志窗口 |
| hide | `hide()` | 无 | `void` | 隐藏日志窗口 |
| setWindowSize | `setWindowSize(width, height)` | 宽高 px | `void` | |
| setWindowPosition | `setWindowPosition(x, y)` | 左上角坐标 px | `void` | |
| setBackgroundColor | `setBackgroundColor(color: number)` | ARGB，如 `0xFF000000` | `void` | 背景色 |
| setTextColor | `setTextColor(color: number)` | ARGB | `void` | 文本色 |
| setTextSize | `setTextSize(size: number)` | 像素 | `void` | |
| setLineHeight | `setLineHeight(lineHeight: number)` | 像素 | `void` | |
| setButtonColors | `setButtonColors(closeColor, resizeColor)` | 关闭钮、缩放钮 ARGB | `void` | |
| setTitleTextColor | `setTitleTextColor(color: number)` | ARGB | `void` | |
| setTitleTextSize | `setTitleTextSize(size: number)` | sp | `void` | |
| setTitleText | `setTitleText(text: string \| null)` | 标题；`null` 或空串则用应用名 | `void` | |
| setTitleBarColor | `setTitleBarColor(color: number)` | ARGB；`-1` 表示比背景深 20% 自动算 | `void` | |
| setAllowMoveToTop | `setAllowMoveToTop(allow: boolean)` | 是否允许移到顶部 | `void` | |
| setAllowMoveToBottom | `setAllowMoveToBottom(allow: boolean)` | 是否允许移到底部 | `void` | |
| setClickable | `setClickable(clickable: boolean)` | 窗口是否可点 | `void` | `false` 可穿透 |
| isClickable | `isClickable()` | 无 | `boolean` | |
| clearLogs | `clearLogs()` | 无 | `void` | 清空窗口内日志 |
| setMaxLogLines | `setMaxLogLines(maxLines: number)` | 最大行数 | `void` | 超出删旧日志 |
| getMaxLogLines | `getMaxLogLines()` | 无 | `number` | |
| setAutoScroll | `setAutoScroll(autoScroll: boolean)` | 新日志是否滚到底 | `void` | |
| setWindowStyle | `setWindowStyle(config)` | 见下 | `void` | 一次设置多项 |
| getWindowStyle | `getWindowStyle()` | 无 | 样式对象 | 当前窗口样式 |

`setWindowStyle` / `getWindowStyle` 字段（d.ts）：`width`、`height`、`x`、`y`、`backgroundColor`、`textColor`、`textSize`、`lineHeight`、`closeButtonColor`、`resizeButtonColor`、`titleTextColor`、`titleTextSize`、`titleText`、`titleBarColor`、`allowMoveToTop`、`allowMoveToBottom`、`clickable`。

d.ts 同时把上述字段列为 `console` 上的属性，可直接读写。

## 最小片段

```javascript
console.log('输出的内容', 324, { name: '张三' });
```

## 注意

- 任务排障可 `console.show()`，不要替代 [`Log.setFile`](Log.md) 的持久记录。
- 索引见 [`INDEX.md`](INDEX.md)。
