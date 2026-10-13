# title

页面内容区的大标题，比 `text` 更醒目。不是标题栏 TitleBar。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| text / title / label | String | 标题文案，支持 `{{path}}` |
| style.fontSize | Number | 字号 sp |
| style.color | String | 文字颜色 |
| style.align | String | `left` / `center` / `right` |

```json
{
  "type": "title",
  "text": "{{headline}}",
  "style": { "align": "center", "color": "#006A65" }
}
```

## 注意

标题栏写在页面根上的 `title`。右侧按钮用 `title.right`，见 [页面 JSON](../page-json.md)。示例 `pages/titleBar`。
