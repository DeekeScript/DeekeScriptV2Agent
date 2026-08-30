# navBar

页内导航栏，**不是**页面根上的 `title`。适合 `title.hidden: true` 时自己画返回和标题。页面 `style.padding` 写成 `0`，导航栏才会贴着内容区顶端。

返回图标默认 32dp，与系统顶栏 `pre_page` 一致。

通用字段见 [通用字段](./_common.md)。系统顶栏见 [页面 JSON](../page-json.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| title / text | String | 中间标题 |
| leftText / left | String | 左侧文案，默认 `返回` |
| leftColor / iconColor / style.color | String | 左侧返回图标和文案颜色，默认主题绿 `#006A65` |
| iconSize | Number | 返回图标边长 dp，默认 32。也可写在 `style.iconSize` |
| rightText / right | String | 右侧文案，不写则不显示 |
| onLeft | String | 左侧点击。不写则 `back()` |
| onRight | String | 右侧点击 |

```json
{ "type": "navBar", "title": "详情", "leftText": "返回", "rightText": "更多", "onRight": "onMore" }
```

```json
{ "type": "navBar", "title": "蓝色返回", "leftText": "返回", "style": { "color": "#1565C0" } }
```

## 注意

- 隐藏系统顶栏：页面 `"title": { "hidden": true }`，再用本组件。
- 不要和入口 `window.title` / 页面 `title` 重复画两套顶栏。
