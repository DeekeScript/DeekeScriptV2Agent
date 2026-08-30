# avatar

圆形或方形头像。有 `src` 显示图片，没有则取 `text` 的首字。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| src / url | String | 图片路径，支持 `{{path}}` |
| text / title / label | String | 无图时显示的文字，只取首字 |
| size | Number | 边长 dp，默认 40。也可写在 `style.size` |
| shape | String | `circle`（默认）、`square`、`rounded` / `圆角` |
| style.borderWidth / borderColor | Number / String | 描边 |
| style.color | String | 文字头像的字色。不写则跟 `window.theme.primary` |

```json
{ "type": "avatar", "src": "img/avatar-1.svg", "size": 48 }
```

```json
{ "type": "avatar", "text": "运", "size": 40, "shape": "square" }
```

```json
{ "type": "avatar", "text": "蓝", "size": 40, "style": { "color": "#1565C0" } }
```
