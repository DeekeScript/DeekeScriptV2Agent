# 工作台首页

首页结构：导航标题 + card 指标 + grid 入口 + list 最近记录。底栏用入口 `bottomMenus`，切 Tab 用 `switchTab`，不要 `navigate`。

相关：[`component-types.md`](../04-cheatsheets/component-types.md)、[`action-types.md`](../04-cheatsheets/action-types.md)。

## 文件

- `deekeScript-v2.json`（含 `homePage` 与 `bottomMenus`）
- `pages/home/page.json`
- `pages/home/page.js`
- 另配 `pages/stats`、`pages/settings` 作底栏目标（可先放空页 `Page({})`）

## 入口 `bottomMenus`

```json
{
  "name": "Demo",
  "packageName": "cn.deeke.demo",
  "icon": "img/xhs.svg",
  "homePage": "pages/home",
  "pages": [
    { "id": "stats", "file": "pages/stats", "title": "统计" },
    { "id": "settings", "file": "pages/settings", "title": "设置" }
  ],
  "bottomMenus": [
    { "title": "{NAME}", "icon": "img/home.png", "page": "pages/home" },
    { "title": "统计", "icon": "img/statistics.png", "page": "pages/stats" },
    { "title": "设置", "icon": "img/setting.png", "page": "pages/settings" }
  ]
}
```

## `pages/home/page.json`

```json
{
  "title": {
    "text": "工作台",
    "fontSize": 18,
    "color": "#FFFFFF",
    "background": "#006A65"
  },
  "style": {
    "padding": 10,
    "background": "#F5F5F5"
  },
  "body": [
    {
      "type": "grid",
      "bind": "metrics",
      "columns": 2,
      "item": {
        "type": "card",
        "style": { "padding": 12, "gap": 4 },
        "children": [
          { "type": "notice", "text": "{{item.label}}" },
          { "type": "title", "text": "{{item.value}}", "style": { "color": "#006A65" } }
        ]
      }
    },
    { "type": "text", "text": "常用功能", "style": { "fontWeight": "bold" } },
    {
      "type": "grid",
      "bind": "apps",
      "columns": 3,
      "item": {
        "type": "card",
        "action": { "type": "navigate", "page": "pages/settings" },
        "style": { "padding": 8, "gap": 8 },
        "children": [
          { "type": "image", "src": "{{item.icon}}", "style": { "width": "50%" } },
          { "type": "text", "text": "{{item.name}}", "style": { "fontSize": 11, "align": "center" } }
        ]
      }
    },
    { "type": "text", "text": "最近记录", "style": { "fontWeight": "bold" } },
    {
      "type": "list",
      "bind": "logs",
      "item": {
        "type": "card",
        "children": [
          {
            "type": "row",
            "style": { "gap": 10 },
            "children": [
              {
                "type": "column",
                "style": { "weight": 1, "gap": 4 },
                "children": [
                  { "type": "text", "text": "{{item.title}}", "style": { "fontWeight": "bold" } },
                  { "type": "notice", "text": "{{item.time}}" }
                ]
              },
              {
                "type": "tag",
                "text": "{{item.status}}",
                "style": { "background": "#E6F4F1", "color": "#006A65" }
              }
            ]
          }
        ]
      }
    }
  ]
}
```

宫格入口图必须写 `"width": "50%"`。

## `pages/home/page.js`

```javascript
Page({
  data: {
    metrics: [
      { label: '今日关注', value: '12' },
      { label: '今日点赞', value: '36' }
    ],
    apps: [
      { name: '养号', icon: 'img/dy.png' },
      { name: '私信', icon: 'img/xhs.png' },
      { name: '评论', icon: 'img/ks.png' }
    ],
    logs: [
      { title: '今日关注 12 人', time: '10:21', status: '完成' },
      { title: '今日点赞 36 次', time: '11:08', status: '进行中' }
    ]
  }
});
```

## 注意

- 指标用 `card` 放在 `grid` 里，不要用 HTML。
- 列表为空不会自动 Empty，需要空态时另写 `"type": "empty"` + `showIf`。
- 底栏根页之间用 `this.switchTab('stats')`，不要 `navigate`。
