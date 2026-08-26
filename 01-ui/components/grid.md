# grid

`columns` 为一行列数。入口卡片图片 `"width": "50%"`，按正方形等比缩放。只写宽或只写高均保持正方形。

通用字段见 [通用字段](./_common.md)。图片见 [image](./image.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| bind | String | 数据路径，对应 `data` 中的数组 |
| id | String | 未写 `bind` 时当作 `bind` |
| columns | Number | 列数 |
| item | Object | 格子模板 |
| empty | String | 数组为空时的提示 |
| style.gap | Number | 格子间距 dp，默认 8。图文间距用 item 卡片的 `style.gap`，默认 12 |

```json
{
  "type": "grid",
  "bind": "apps",
  "columns": 3,
  "item": {
    "type": "card",
    "style": { "padding": 8, "gap": 8 },
    "children": [
      { "type": "image", "src": "{{item.icon}}", "style": { "width": "50%" } },
      { "type": "text", "text": "{{item.name}}", "style": { "align": "center" } }
    ]
  }
}
```

## 注意

宫格入口图固定 `contain`，不裁剪。数组为空时可用 `empty` 字符串，不必另写 Empty 组件。
