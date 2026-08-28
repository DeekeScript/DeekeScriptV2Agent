# skeleton

数据还没到时的占位，骨架条会呼吸闪动。配合 `showIf` 与真实内容互斥。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| rows | Number | 灰色条数量，默认 3 |
| avatar | Boolean | 是否显示圆形头像占位 |
| showIf | String | 为真时显示骨架 |

```json
{ "type": "skeleton", "avatar": true, "rows": 3, "showIf": "loading" }
```
