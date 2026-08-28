# noticeBar

顶部通告条。默认单行滚动；`scroll: false` 时不滚动。

通用字段见 [通用字段](./_common.md)。灰色小字说明用 [notice](./notice.md)，不要混用。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| text / title / label | String | 通告文案，支持 `{{path}}` |
| scroll | Boolean | 是否滚动，默认 true |
| style.background | String | 背景色，默认 `#FFF7E8` |

```json
{ "type": "noticeBar", "text": "系统将于今晚维护，期间任务会暂停。" }
```
