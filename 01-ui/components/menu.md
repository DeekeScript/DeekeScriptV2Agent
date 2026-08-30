# menu

多级选择器。点字段后从底部或顶部弹出，**每一级一列同时显示**（省 / 市 / 区三列一起出来）。改第一列时，后面的列自动回到该级的第一项。点确定才写入。

值为用 `/` 拼起来的路径，例如 `"gd/sz/ns"`；界面显示 `"广东 / 深圳 / 南山"`。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| label | String | 字段标题 |
| value | String | 默认路径，如 `"gd/sz/ns"` |
| hint | String | 未选时的占位，默认 `请选择` |
| position | String | `bottom`（默认）从底部弹出；`top` 从顶部弹出。也可用 `上` |
| options / items | Array | `{ label, value, children }`。`children` 同结构，可多层 |
| style.color | String | 确定按钮颜色。不写则跟 `window.theme.primary` |

```json
{
  "type": "menu",
  "name": "address",
  "label": "收货地址",
  "position": "bottom",
  "options": [
    {
      "label": "广东",
      "value": "gd",
      "children": [
        { "label": "深圳市", "value": "sz", "children": [{ "label": "南山区", "value": "ns" }] }
      ]
    }
  ]
}
```

## 别名

`options` 与 `items` 等价。`position` 可用 `上` 表示顶部。
