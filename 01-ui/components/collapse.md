# collapse

可展开 / 收起的一组条目。`accordion: true` 时同时只开一项。展开内容可以是纯文字，也可以是 `children` 组件。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键。手风琴为字符串，否则为打开项的数组 |
| accordion | Boolean | 手风琴，默认 false |
| items / options | Array | `{ title, name, text, children, disabled }` |
| value | String / Array | 默认打开的项 |
| onChange | String | 展开变化时调用 |
| style.color | String | 折叠箭头颜色。不写则跟 `window.theme.primary` |

```json
{
  "type": "collapse",
  "name": "open",
  "accordion": true,
  "items": [
    { "name": "a", "title": "什么是动态页面？", "text": "用 JSON 描述界面。" }
  ]
}
```

```json
{ "type": "collapse", "name": "tone", "accordion": true, "style": { "color": "#1565C0" }, "items": [{ "name": "a", "title": "蓝色箭头", "text": "折叠箭头颜色写 style.color。" }] }
```
