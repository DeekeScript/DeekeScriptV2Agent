# ellipsis

超过指定行数显示省略号。`expand` 默认 true，可展开 / 收起。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| text / title / label | String | 文案，支持 `{{path}}` |
| rows / maxLines | Number | 折叠时最多几行，默认 2 |
| expand | Boolean | 是否显示「展开 / 收起」，默认 true |

```json
{ "type": "ellipsis", "rows": 2, "expand": true, "text": "比较长的说明……" }
```
