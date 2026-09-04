# action 类型速查

权威说明：[`01-ui/page-json.md`](../01-ui/page-json.md#json-action)。组件事件：[`01-ui/events.md`](../01-ui/events.md)。

| type | JSON 要点 | JS |
|------|-----------|-----|
| `navigate` | `page`、`params` | `this.navigate(...)` |
| `redirect` | `page`、`params` | `this.redirect(...)` |
| `switchTab` | `page` 或 `index` | `this.switchTab(...)` |
| `back` | 无 | `this.back()` |
| `toast` | `text`，可选 `duration` | `this.toast(...)` |
| `save` | 仅 JSON；`toast` 可选 | 无同名方法；写入在 `onTap` |
| `openUrl` | `url` | `this.openUrl(...)` |

与 `onTap` 同时存在时先 JS 再 `action`。
