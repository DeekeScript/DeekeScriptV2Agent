# text

普通正文，用来展示说明或内容，可改颜色、字号、加粗和对齐。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| text / title / label | String | 文案，支持 `{{path}}` |
| style.fontSize | Number | 字号 sp |
| style.color | String | 文字颜色 |
| style.fontWeight | String | `bold` / 默认 |
| style.align | String | `left` / `center` / `right` |

```json
{
  "type": "text",
  "text": "当前账号：{{account}}",
  "style": { "color": "#006A65", "fontWeight": "bold" }
}
```

## 别名

`text`、`title`、`label` 三个字段都可以当文案，会做 `{{path}}` 替换。
