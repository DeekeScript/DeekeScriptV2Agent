# Intent

用 URI 或 Intent 打开 Activity。日常跳转优先 `App.gotoIntent(uri)`。不要编造未在本卡列出的 Intent 字段。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 是 |
| `tasks/*.js` | 是 |

## 方法 / 用法

来自 `App`（见 [`App.md`](./App.md)）：

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `App.gotoIntent(uri)` | `uri {string}` | `void` | 按 URI 启动 Activity |
| `App.startActivity(intent)` | `intent {Intent}` | `void` | 按 Intent 启动；能力未就绪时不要依赖 |
| `App.openUrl(url, packageName)` | URL，包名可选 | `void` | 打开链接 |
| `App.launch(packageName)` | 包名 | `void` | 打开应用 |

`Intent` 对象：

| 成员 | 说明 |
|------|------|
| `new Intent(action, uri)` | 如 `new Intent(Intent.ACTION_VIEW, Uri.parse("myapp://second_activity"))` |
| `Intent.open()` | 无可靠参数说明，不要编造调用方式 |

界面里打开外链不要自己拼 Intent，用 JSON `action: { "type": "openUrl", "url": "..." }` 或 `this.openUrl(url)`，见 [`action-types.md`](../../04-cheatsheets/action-types.md)。
