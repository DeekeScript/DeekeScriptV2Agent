# search

圆角搜索框，**默认左侧有放大镜**。高度默认 48dp，与中号输入框一致。`type` 写 `search` 或 `searchBar` 均可。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键，常用 `keyword` |
| hint / placeholder | String | 占位，默认 `搜索` |
| value | String | 默认值 |
| icon | String / Boolean | 左侧图标。不写则用内置放大镜；图片路径可替换；`false` / `none` 隐藏 |
| iconSize | Number | 图标边长 dp，默认 18 |
| shape | String | `round`（默认圆角）/ `square` 直角一些 |
| showCancel / cancel | Boolean / String | 右侧取消按钮。`true` 文案为 `取消`；字符串则作为按钮文案 |
| cancelText | String | 取消按钮文案 |
| disabled | Boolean | 不可输入 |
| onChange | String | 内容变化时调用，`e.value` 是关键字 |
| onSearch | String | 键盘搜索键，`e.value` 是关键字 |
| onCancel | String | 点取消时调用，并清空输入 |
| style.color | String | 取消按钮文字颜色。不写则跟 `window.theme.primary` |
| style.focusColor | String | 聚焦时描边 / 光标等强调色。不写则跟 `window.theme.primary`（与 [`input`](./input.md) 相同） |
| style.background | String | 输入区背景，默认浅底；**不要**把艳色品牌色当成搜索框默认底 |

```json
{ "type": "searchBar", "name": "keyword", "hint": "搜索任务" }
```

```json
{ "type": "searchBar", "name": "q", "hint": "搜索", "showCancel": true, "onSearch": "onQuery" }
```

```json
{ "type": "searchBar", "name": "blueQ", "hint": "蓝色取消", "showCancel": true, "style": { "color": "#1565C0" } }
```

主色很艳（如抖音红 `#FE2C55`）时，聚焦会跟着变艳，看起来像「点搜索框整块变红」。这不是搜索框自带红底特性，而是 **`theme.primary` 继承**。按钮 / 底栏仍可用艳色 primary；搜索框单独压成中性聚焦：

```json
{
  "type": "searchBar",
  "name": "keyword",
  "hint": "搜索",
  "showCancel": true,
  "style": { "focusColor": "#161823", "color": "#161823" }
}
```

键盘搜索键走 `onSearch`（没有则走 `onChange`）。主题色分工见 [`_common.md`](./_common.md#主题色)。
