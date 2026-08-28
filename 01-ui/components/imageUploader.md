# imageUploader

从相册选图，值为路径数组。点加号添加，点角上 × 删除。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键，值为字符串数组 |
| label | String | 字段标题 |
| value | Array | 已选图片路径 |
| max / maxCount | Number | 最多张数，默认 9 |
| columns | Number | 每行列数，默认 3 |
| addText | String | 加号格文案，默认 `+` |
| onChange | String | 增删后调用，`e.value` 为路径数组 |

```json
{ "type": "imageUploader", "name": "photos", "label": "凭证图", "max": 6 }
```
