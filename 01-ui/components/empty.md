# empty

空状态占位。图标在文字上方；文字、图标都可以不写。

列表为空时**不会自动**出现 Empty，需要自己写在列表旁，并用 `showIf` 控制。见 [list](./list.md)。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| icon / src / url | String | 图标路径，支持 `http(s)` 或项目内图片 |
| text / title / label | String | 提示文案，可省略。支持 `{{path}}` |
| iconSize | Number | 图标边长 dp，默认 48。也可写在 `style.iconSize` |
| style.color | String | 文案颜色。不写则为灰色 `#9AA8A6` |

```json
{
  "type": "empty",
  "icon": "img/empty.svg",
  "text": "暂无记录",
  "showIf": "empty"
}
```

```json
{ "type": "empty", "text": "蓝色空状态", "style": { "color": "#1565C0" } }
```
