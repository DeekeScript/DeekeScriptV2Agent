# 页面 page.json

写或改某一页的结构时读这篇。每个页面一个目录：`page.json` 描述长什么样，同目录 `page.js` 用 `Page({})` 填数据。先搭 JSON，再写生命周期。本页字段会覆盖入口 `window` 的同名配置。组件清单不在这篇，只讲页面根字段和 `title`。

## 页面字段

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| id | String | 否 | 页面标记。跳转可写文件夹，或入口 `pages` 中的 id |
| title | String / Object | 否 | 导航栏。不写则不显示。字符串为标题；对象见下表 |
| style | Object | 否 | 内容区：`padding` / `margin` / `background`。未写 padding 时为 16（dp） |
| statusBar | String / Object | 否 | 顶部状态栏。字符串为背景色；对象为 `background` + `color`（`light` / `dark`） |
| js | String | 否 | 默认加载同目录 `page.js` |
| enablePullDownRefresh | Boolean | 否 | 打开整页下拉。见 [下拉刷新](./capabilities/refresh.md) |
| body | Array | 是 | 组件列表 |
| popups | Array | 否 | 弹层。显示隐藏用 `showIf`。嵌自定义组件在弹层 `body` 里写 `{ "type": "choose" }` |

## 覆盖 window 的规则

1. 先加载 `deekeScript-v2.json` 的 `window`。
2. 再加载当前目录 `page.json`。
3. 同名字段由页面覆盖（`style` / `title` / `statusBar` 等）。

入口 `window.title` 只是默认样式；**页面未写 `title` 时不显示导航栏**。

## title 对象

| 参数名 | 类型 | 说明 |
|--------|------|------|
| text | String | 标题文案 |
| hidden | Boolean | `true` 则隐藏导航栏 |
| fontSize | Number | 字号（sp） |
| color | String | 文字颜色 `#RRGGBB` |
| background | String | 导航栏背景色 |
| fontWeight | String | `bold` |
| align | String | `left` / `center` / `right` |
| style | Object | 也可把 fontSize / color 等写在 `style` 里 |

```json
{
  "title": {
    "text": "工作台",
    "fontSize": 18,
    "color": "#FFFFFF",
    "background": "#006A65"
  }
}
```

```json
{ "title": { "text": "关于", "hidden": true } }
```

## 内容区与状态栏

```json
{
  "title": {
    "text": "关于",
    "fontSize": 18,
    "color": "#FFFFFF",
    "background": "#006A65"
  },
  "style": {
    "padding": 16,
    "margin": 0,
    "background": "#F5F5F5"
  },
  "statusBar": {
    "background": "#006A65",
    "color": "light"
  },
  "body": [
    { "type": "title", "text": "DeekeScript" },
    { "type": "text", "text": "用 JSON 描述页面。" },
    {
      "type": "button",
      "text": "打开官网",
      "action": { "type": "openUrl", "url": "https://deeke.cn" }
    }
  ]
}
```

固定文案直接写在 JSON；会变的文案写成 `{{hello}}`，在 `page.js` 里 `setData`。表单用 `name` 对应 `data` 的键。见 [数据绑定](./data-binding.md)、[page.js](./page-js.md)。
