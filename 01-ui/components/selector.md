# selector

一排可点的选项胶囊，像筛选标签。默认单选；`multiple: true` 为多选，值为数组。

通用字段见 [通用字段](./_common.md)。更紧凑的互斥切换见 [segmented](./segmented.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| label | String | 字段标题 |
| multiple / multi | Boolean | 是否多选，默认 false |
| options / items | Array | `{ label, value }` 或字符串 |
| value | String / Array | 默认选中 |
| onChange | String | 变化时调用，`e.value` 为当前值 |
| style.color | String | 选中胶囊颜色。不写则跟 `window.theme.primary` |

```json
{ "type": "selector", "name": "tags", "multiple": true, "options": ["获客", "养号", "评论"] }
```

```json
{ "type": "selector", "name": "tone", "label": "蓝色胶囊", "style": { "color": "#1565C0" }, "options": ["抖音", "小红书"] }
```
