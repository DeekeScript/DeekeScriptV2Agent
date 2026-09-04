# 页面 page.json

写或改某一页的结构时读这篇。每个页面一个目录：`page.json` 描述长什么样，同目录 `page.js` 用 `Page({})` 填数据。先搭 JSON，再写生命周期。本页字段会覆盖入口 `window` 的同名配置。组件清单不在这篇，只讲页面根字段、`title` 与组件 `action`。`onTap` 等见 [`events.md`](./events.md)。

## 页面字段

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| id | String | 否 | 页面标记。跳转可写文件夹，或入口 `pages` 中的 id |
| title | String / Object | 否 | 导航栏。不写则不显示。字符串为标题；对象见下表 |
| style | Object | 否 | 内容区：`padding` / `margin` / `background`。未写 padding 时为 16（dp） |
| statusBar | String / Object | 否 | 顶部状态栏。字符串为背景色；对象为 `background` + `color`（`light` / `dark`） |
| js | String | 否 | 默认加载同目录 `page.js` |
| enablePullDownRefresh | Boolean | 否 | 打开整页下拉。见 [下拉刷新](./capabilities/refresh.md) |
| body | Array | 是 | 组件列表。可写 `action` / `onTap`，见下方 [JSON action](#json-action)、[`events.md`](./events.md) |
| popups | Array | 否 | overlay 弹层。显示隐藏用 `showIf`。也可把 `popup` / `actionSheet` / `dialog` / `modal` 等写在 `body` 里，同样盖在最上层 |

## 覆盖 window 的规则

1. 先加载 `deekeScript.json` 的 `window`。
2. 再加载当前目录 `page.json`。
3. 同名字段由页面覆盖（`style` / `title` / `statusBar` 等）。

入口 `window.title` 只是默认样式；**页面未写 `title` 时不显示导航栏**。

## title 对象

| 参数名 | 类型 | 说明 |
|--------|------|------|
| text | String | 标题文案，支持 `{{path}}`（如 `{{pageTitle}}`，对应 `Page.data`） |
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
    "text": "{{pageTitle}}",
    "fontSize": 18,
    "color": "#FFFFFF",
    "background": "#006A65"
  }
}
```

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
      "style": { "background": "#006A65", "color": "#FFFFFF" },
      "action": { "type": "openUrl", "url": "https://deeke.cn" }
    }
  ]
}
```

固定文案直接写在 JSON；会变的文案写成 `{{hello}}`，在 `page.js` 里 `setData`。表单用 `name` 对应 `data` 的键。见 [数据绑定](./data-binding.md)、[page.js](./page-js.md)。

## JSON action {#json-action}

`body` 里组件上的 `action` 是结构字段。不要编造类型（没有 `executeScript` / `runScript` / `showModal`）。

与 `onTap`（或 `onClick`）同时存在时：**先**调用 Page 方法，**再**执行 `action`。事件回调见 [`events.md`](./events.md)。字符串字段会做 `{{path}}` 替换。页面栈细节见 [`navigate.md`](./navigate.md)。

| type | 说明 | 主要字段 | 对应 Page 方法 |
|------|------|----------|----------------|
| `navigate` | 打开另一页（每次新页面） | `page`、`params` | `this.navigate` |
| `redirect` | 关掉当前二级页再打开 | `page`、`params` | `this.redirect` |
| `switchTab` | 切到底栏某一项 | `page` 或 `index` | `this.switchTab` |
| `back` | 关闭当前二级页 | 无 | `this.back` |
| `toast` | 短提示 | `text`，可选 `duration` | `this.toast` |
| `save` | 弹「已保存」类提示（**仅 JSON**） | `toast`（可选，默认「已保存」） | 无同名方法；写入放在 `onTap` |
| `openUrl` | 系统浏览器打开外链 | `url` | `this.openUrl` |

```json
{
  "type": "button",
  "text": "打开详情",
  "action": {
    "type": "navigate",
    "page": "detail",
    "params": { "id": "{{item.id}}", "from": "stats" }
  }
}
```

```json
{ "type": "button", "text": "返回", "action": { "type": "back" } }
```

```json
{
  "type": "button",
  "text": "保存设置",
  "onTap": "onSave",
  "action": { "type": "save", "toast": "已保存" },
  "style": { "background": "#006A65", "color": "#FFFFFF" }
}
```

```json
{ "type": "button", "text": "官网", "action": { "type": "openUrl", "url": "https://deeke.cn" } }
```

- `page`：文件夹或入口 `pages` 的 `id`；底栏用 `switchTab`，不要 `navigate`
- `save` 只弹提示；`Storage.put` 写在 `onTap` 里
- 确认框用全局 `Dialogs`
- 从按钮跑任务：见 [`events.md`](./events.md)
