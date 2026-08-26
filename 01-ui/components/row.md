# row

横向排列子项。`weight` 撑开子项。`valign`：`top` / `center` / `bottom`，默认垂直居中。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| children | Array | 子组件 |
| style.gap | Number | 子项间距 dp |
| style.valign | String | `top` / `center` / `bottom` |
| style.weight | Number | 子项在 row 里的权重，写在**子项** style 上 |

```json
{
  "type": "row",
  "style": { "gap": 8, "valign": "center" },
  "children": [
    { "type": "text", "text": "账号", "style": { "weight": 1 } },
    { "type": "button", "text": "切换", "size": "sm" }
  ]
}
```

## 注意

页面第一层可写 `style.sticky` 吸顶 / 吸底，只对 `body` 第一层有效，见 [通用字段](./_common.md)。
