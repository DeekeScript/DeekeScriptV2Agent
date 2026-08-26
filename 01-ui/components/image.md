# image

展示图片。`src` 为 `http(s)` 地址，或项目内 PNG / JPG / SVG（如 `img/xhs.svg`）。

宫格入口图见 [grid](./grid.md)，需写出 `"width": "50%"`。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| src / url | String | 图片路径，支持 `{{item.icon}}` |
| fit | String | `contain`（默认，完整显示）或 `cover`（裁切铺满）。宫格入口图固定 contain |
| style.width / height | Number / String | 宽高。数字是 dp，宽度也可写 `"50%"`。页面头图只写 height 会拉满宽度 |
| style.radius | Number | 圆角 |

```json
{
  "type": "image",
  "src": "img/banner.svg",
  "fit": "cover",
  "style": { "height": 100, "width": "match", "radius": 8 }
}
```

## 别名

`src` 与 `url` 等价。
