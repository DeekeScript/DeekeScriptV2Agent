# search

圆角搜索框。键盘搜索键会触发 `onChange`。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键，常用 `keyword` |
| hint | String | 占位 |
| value | String | 默认值 |
| onChange | String | 搜索或内容变化时调用，`e.value` 是关键字 |

```json
{
  "type": "search",
  "name": "keyword",
  "hint": "搜索任务",
  "onChange": "onSearch"
}
```
