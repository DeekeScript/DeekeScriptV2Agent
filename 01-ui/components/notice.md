# notice

灰色小字，用来写说明、注释或次要信息。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| text / title / label | String | 提示文案，支持 `{{path}}` |
| style.color | String | 文字颜色，默认灰色 |
| style.align | String | `left` / `center` / `right` |

```json
{
  "type": "notice",
  "text": "失败时请检查网络后再重试。",
  "style": { "color": "#B42318" }
}
```
