# toast

短文案提示，不打断操作。优先用页面方法或 `action`，不必在 JSON 里放节点。

1. **页面方法** `this.toast('保存成功')` 或 `action: { "type": "toast", "text": "..." }`，约 1.6 秒后消失
2. **组件** `type: "toast"` + `showIf`，自己控制显示隐藏

通用字段见 [通用字段](./_common.md)。方法见 [页面 JS](../page-js.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| showIf | String | 组件用法：为真时显示 |
| text / title | String | 提示文案 |
| position | String | `center`（默认）/ `top` / `bottom` |
| mask | Boolean | 默认 false |
| style.background | String | 气泡底色。不写则为深色半透明 |
| style.color | String | 文字颜色。不写则为白色 |

```json
{ "type": "button", "text": "保存", "action": { "type": "toast", "text": "已保存" } }
```

```json
{ "type": "toast", "showIf": "blue", "text": "style.background / color", "style": { "background": "#1565C0", "color": "#FFFFFF" } }
```

不要用 toast 组件做确认框，确认用 [dialog](./dialog.md)。
