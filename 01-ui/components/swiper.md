# swiper

多个 banner 左右切换。页面 `padding` 写成 `0` 并放在 `body` 最前，即可贴顶贴边。`autoplay` 默认开启。

点当前屏走 `item` 上的 `onTap` / `action`（也认数据项上同名字段），`e.item`、`e.index` 可用。

通用字段见 [通用字段](./_common.md)。分页点见 [pageIndicator](./pageIndicator.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| bind | String | 数据路径，对应 `data` 中的数组 |
| items | Array | 未写 `bind` 时的静态项 |
| item | Object | 每一屏的组件模板 |
| height | Number | 高度 dp，默认 140 |
| autoplay | Boolean | 是否自动播放，默认 true |
| interval | Number | 自动播放间隔毫秒，默认约 3000 |
| onTap / onClick | String | 写在 `item`（或数据项）上 |
| action | Object | 写在 `item`（或数据项）上 |

```json
{
  "type": "swiper",
  "bind": "banners",
  "height": 140,
  "autoplay": true,
  "interval": 2800,
  "item": { "type": "image", "src": "{{item.src}}", "fit": "cover", "onTap": "onBanner" }
}
```
