# rate

点星星打分。默认只能选整星。`allowHalf: true` 后可打半星（如 3.5）：点一颗星的左半为 `n - 0.5`，右半为整星 `n`。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| label | String | 字段标题 |
| value | Number | 当前星数，支持 `3.5` |
| count | Number | 星星个数，默认 5 |
| allowHalf | Boolean | 是否允许半星，默认 `false`。别名 `half`、`半星`。也可写 `step: 0.5` |
| size / iconSize | Number | 星星边长 dp，默认 32 |
| onChange | String | 变化时调用，`e.value` 为星数 |

```json
{ "type": "rate", "name": "score", "label": "任务完成度", "value": 4, "count": 5 }
```

```json
{ "type": "rate", "name": "half", "label": "允许半星", "value": 3.5, "allowHalf": true }
```
