# tag

短标签。默认浅绿底、深绿字。多个标签用 [row](./row.md)，或横向 [list](./list.md) 绑定数组。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| text / title / label | String | 标签文案，支持 `{{path}}` |
| style.background | String | 背景色，默认 `#EEF2F1` |
| style.color | String | 文字颜色，默认 `#006A65` |
| style.radius | Number | 圆角，默认 4 |
| style.padding | Number | 内边距；不写时为左右 8、上下 3 |
| style.fontSize | Number | 字号，默认 11 |

```json
{
  "type": "row",
  "style": { "gap": 6 },
  "children": [
    { "type": "tag", "text": "养号" },
    { "type": "tag", "text": "完成", "style": { "background": "#E6F4F1", "color": "#006A65" } }
  ]
}
```
