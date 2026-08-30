# indexBar

通讯录式列表。右侧字母轨悬浮在列表之上，列表铺满宽度。滚动发生在列表内部，不会带动整页。

扁平数组用 `indexKey`（默认 `letter`）分组；也可写成 `{ index, children }`。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| bind | String | 数据路径，对应 `data` 中的数组 |
| indexKey | String | 分组字段，默认 `letter` |
| item | Object | 每一项的组件模板 |
| items | Array | 未写 `bind` 时的静态数据 |
| railMargin | Number | 字母轨距右边缘的 dp，默认 `6`。也可写 `style.marginRight` / `style.right` |
| style.color | String | 当前字母高亮色。不写则跟 `window.theme.primary` |

```json
{
  "type": "indexBar",
  "bind": "contacts",
  "indexKey": "letter",
  "railMargin": 6,
  "item": { "type": "text", "text": "{{item.name}}" }
}
```

页面 `style.padding` 建议写成 `0`。同目录必须有 `page.js`（哪怕 `Page({})`）。
