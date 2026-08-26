# action 类型对照

JSON `action` 与 `Page` 里同名方法是一套。字符串参数会当作 `page` / `text` / `url`。与 `onTap` 同时存在时，先调 JS 再执行 `action`。

跑自动化脚本不要用 `action`，用 `onTap` + `Engines.executeScript`。见 [`run-task-from-ui.md`](../03-recipes/run-task-from-ui.md)。

| type / 方法 | JSON | JS | 说明 |
|-------------|------|----|------|
| `navigate` | `{ "type": "navigate", "page": "detail", "params": { "id": "{{item.id}}" } }` | `this.navigate({ page: 'detail', params: { id: 1 } });` 或 `this.navigate('detail');` | 打开另一页。每次新页面 |
| `redirect` | `{ "type": "redirect", "page": "detail" }` | `this.redirect({ page: 'detail', params: { id: 2 } });` | 关掉当前二级页再打开。底栏根页上等同 navigate |
| `switchTab` | `{ "type": "switchTab", "page": "pages/home" }` | `this.switchTab('home');` 或 `this.switchTab({ page: 'pages/home' });` | 切 `bottomMenus`。保留数据和滚动，只再 `onShow` |
| `back` | `{ "type": "back" }` | `this.back();` | 关闭当前二级页。底栏根页不会退出 App |
| `toast` | `{ "type": "toast", "text": "已保存" }` | `this.toast('已保存');` 或 `this.toast({ text: '已保存', duration: 'long' });` | 短提示 |
| `save` | `{ "type": "save", "toast": "已保存" }` | 无同名方法 | **仅 JSON**。弹提示，默认文案「已保存」。真正写入在 `onTap` 里 `Storage.put` |
| `openUrl` | `{ "type": "openUrl", "url": "https://deeke.cn" }` | `this.openUrl('https://deeke.cn');` | 系统浏览器。不要用 WebView 当外链整页 |

```json
{ "type": "button", "text": "打开详情", "action": { "type": "navigate", "page": "detail", "params": { "id": "{{item.id}}" } } }
```

```javascript
this.navigate({ page: 'detail', params: { id: 1 } });
this.switchTab('home');
this.toast('已保存');
this.openUrl('https://deeke.cn');
this.back();
```

## 注意

- 底栏之间用 `switchTab`，不要 `navigate`。
- `page` 写文件夹（`pages/detail`）或入口 `pages` 里的 `id`。
- `params` 目标页模板用 `{{params.id}}`，`onLoad(params)` 也能读。
- 确认框用全局 `Dialogs`，不要编造 `showModal` action。
