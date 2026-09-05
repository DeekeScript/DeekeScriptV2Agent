# radio

一组选项里只能选一项，值为当前项。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| label | String | 字段标题 |
| value | String | 默认选中项 |
| options | Array | 选项：字符串，或 `{ "label", "value" }` |
| onChange | String | 切换时调用，`e.value` 为当前值。写在 list / grid 行内时还有 `e.item`、`e.index` |
| style.color | String | 选中按钮颜色。不写则跟 `window.theme.primary`。不要写 `style.background` |

```json
{
  "type": "radio",
  "name": "mode",
  "label": "运行模式",
  "options": [
    { "label": "稳妥", "value": "safe" },
    { "label": "均衡", "value": "normal" }
  ]
}
```

```json
{ "type": "text", "text": "当前：{{mode}}" }
```

```javascript
Page({
  data: {
    mode: 'safe'
  }
});
```

`name` 必须出现在 `Page.data` 里。当前项用 `{{mode}}` 展示。

```json
{ "type": "radio", "name": "tone", "label": "蓝色单选", "value": "blue", "style": { "color": "#1565C0" }, "options": [{ "label": "蓝", "value": "blue" }, { "label": "对照", "value": "other" }] }
```
