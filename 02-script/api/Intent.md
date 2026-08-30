# Intent

用 URI 或 Intent 打开 Activity。日常跳转优先 `App.gotoIntent(uri)`。d.ts 另有 `Intent.open()` 与 `App.startActivity(intent)`；官方写 `startActivity` 为 2.0 即将上线，不要编造未文档化的 Intent 字段。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 是 |
| `tasks/*.js` | 是 |

## 方法 / 用法

来自 `App`（见 [`App.md`](./App.md) 与 d.ts）：

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `App.gotoIntent(uri)` | `uri {string}` | `void` | 按 URI 启动 Activity |
| `App.startActivity(intent)` | `intent {Intent}` | `void` | 按 Intent 启动。官方标注 2.0 即将上线 |
| `App.openUrl(url, packageName)` | URL，包名可选 | `void` | 打开链接 |
| `App.launch(packageName)` | 包名 | `void` | 打开应用 |

`Intent` 对象（d.ts 仅 `open()`；官方示例用构造函数）：

| 成员 | 说明 |
|------|------|
| `new Intent(action, uri)` | 官方示例：`new Intent(Intent.ACTION_VIEW, Uri.parse("myapp://second_activity"))` |
| `Intent.open()` | d.ts 有，官方 md 无说明，不要编造参数 |

界面里打开外链不要自己拼 Intent，用 JSON `action: { "type": "openUrl", "url": "..." }` 或 `this.openUrl(url)`，见 [`action-types.md`](../../04-cheatsheets/action-types.md)。

## 最小片段

```javascript
App.gotoIntent('snssdk1128://user/profile/' + user_id);
```

## 注意

- 生成代码优先 `App.gotoIntent`，URI 由目标 App 文档提供。
- 不要把 `startActivity` 当成稳定公开 API 去拼复杂 extras。
- 页面跳转用 `this.navigate` / `switchTab`，不要用 Intent 打开自己的页面。
- 相关：[`App.md`](./App.md)。
