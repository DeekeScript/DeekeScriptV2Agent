# sideBar

左侧分类轨。和右侧内容用 [row](./row.md) 并排。页面 `padding` 写成 `0`，侧栏才会贴左（或贴右）。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| value | String | 当前选中项 |
| items / options | Array | `{ text, value }` 或字符串 |
| onChange | String | 切换时调用，`e.value` 为当前值 |
| style.width | Number | 轨宽 dp，默认 88 |
| style.color | String | 选中项颜色。不写则跟 `window.theme.primary` |

```json
{
  "type": "row",
  "children": [
    {
      "type": "sideBar",
      "name": "cat",
      "value": "follow",
      "style": { "color": "#1565C0" },
      "items": [
        { "text": "关注", "value": "follow" },
        { "text": "点赞", "value": "like" }
      ]
    },
    { "type": "column", "style": { "weight": 1 }, "children": [{ "type": "text", "text": "内容" }] }
  ]
}
```
