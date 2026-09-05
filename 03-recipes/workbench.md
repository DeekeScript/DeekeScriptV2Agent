# 工作台首页

首页结构：导航标题 + **指标摘要** +（可选）**仅不在底栏的功能宫格** + 最近记录 / 主操作。底栏用入口 `bottomMenus`，切 Tab 用 `switchTab`，不要 `navigate`。

相关：[`ui.md`](../04-cheatsheets/ui.md)、[`tabBar.md`](../01-ui/capabilities/tabBar.md)、[`form-name.md`](../01-ui/pitfalls/form-name.md)、[`code-org.md`](../02-script/code-org.md)。

## 反冗余（必遵）

1. **`bottomMenus` 已有的页面，首页不要再放「去某某」按钮或宫格入口。** 例如底栏已有「配置」「评论」，首页只保留指标 +「开始任务」，不要再放「去配置」「管理评论」。
2. 首页宫格 **只留给不在底栏里的二级功能**（如养号、私信工具）；这些页用 `navigate`，不要塞进底栏又在首页重复。
3. 若四个主模块都在底栏（首页 / 配置 / 评论 / 记录）：首页 = 摘要 + **一个**主 CTA，不要复制底栏导航。

生成后自检：把 `bottomMenus[].page` 列出来，删掉首页里指向相同 page 的 button / grid / navigate。

## 文件

- `deekeScript.json`（含 `icon`、`homePage`、`bottomMenus`，以及 `icon` / 底栏用到的图片文件）
- `pages/home/page.json` + `page.js`
- 底栏目标：与产品一致，例如 `pages/stats`、`pages/settings`（可先空页 `Page({})`）
- 宫格（可选）：仅 `bottomMenus` **未收录** 的页，如 `pages/yanghao`、`pages/dm`
- 底栏图标与宫格图标文件必须真实生成

## 入口 `bottomMenus`（示例：底栏三 Tab，宫格才放其它功能）

```json
{
  "name": "Demo",
  "packageName": "cn.deeke.demo",
  "icon": "img/xhs.svg",
  "homePage": "pages/home",
  "pages": [
    { "id": "stats", "file": "pages/stats", "title": "统计" },
    { "id": "settings", "file": "pages/settings", "title": "设置" },
    { "id": "yanghao", "file": "pages/yanghao", "title": "养号" },
    { "id": "dm", "file": "pages/dm", "title": "私信" }
  ],
  "bottomMenus": [
    { "title": "{NAME}", "icon": "img/home.png", "page": "pages/home" },
    { "title": "统计", "icon": "img/statistics.png", "page": "pages/stats" },
    { "title": "设置", "icon": "img/setting.png", "page": "pages/settings" }
  ]
}
```

上面底栏没有「养号 / 私信」，所以首页宫格可以链到它们。若把「评论」也放进 `bottomMenus`，就**不要**再在首页宫格或按钮里放「评论」。

## 方案 A：底栏已覆盖主模块（推荐多数工具 App）

首页只要：指标 + 配置摘要（只读 notice）+ **一个**「开始」按钮。不要「去配置 / 去评论」行。

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
    {
      "type": "card",
      "style": { "padding": 12, "gap": 6 },
      "children": [
        { "type": "text", "text": "当前配置", "style": { "fontWeight": "bold" } },
        { "type": "notice", "text": "{{configText}}" }
      ]
    },
    {
      "type": "button",
      "text": "开始任务",
      "onTap": "onRun",
      "style": { "background": "#006A65", "color": "#FFFFFF" }
    },
    { "type": "notice", "text": "配置与评论请用底部 Tab 切换。" }
  ]
}
```

## 方案 B：底栏只有首页 / 统计 / 设置，其它功能用宫格

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
        "action": { "type": "navigate", "page": "{{item.page}}" },
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

宫格入口图必须写 `"width": "50%"`。`apps` 里的 `page` **不得**与 `bottomMenus` 重复。

## `pages/home/page.js`（方案 B 数据示例）

```javascript
Page({
  data: {
    metrics: [
      { label: '今日关注', value: '12' },
      { label: '今日点赞', value: '36' }
    ],
    apps: [
      { name: '养号', icon: 'img/dy.png', page: 'pages/yanghao' },
      { name: '私信', icon: 'img/xhs.png', page: 'pages/dm' }
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
- 底栏根页之间用 `switchTab`；宫格进**非底栏**功能页用 `navigate`（`{{item.page}}`），不要一律 `switchTab` 到设置。
- 主 CTA 用一个大按钮即可；次要操作用 `sm`，见 [`button.md`](../01-ui/components/button.md)。
- 底栏根页展示 Storage 派生数据必须在 **`onShow` 再读**再 `setData`（切 Tab 不走 `onLoad`）。见 [`page-js.md`](../01-ui/page-js.md)。

## 同时有无障碍任务

常见形态：首页摘要 + 开始；设置表单；可启用列表；操作记录。任务 `launch` 目标 App，用户要求做完回本 App 时 `App.backApp()` 再 `Engines.closeAll()`。

```
pages/home      摘要 + 唯一「开始」
pages/settings  关键词、数量、概率、休眠 → Storage
pages/comments  话术列表 + switch 启停
pages/logs      只展示记录
common/store.js 所有 Storage 键（项目+模块前缀）
common/<app>/   页面态、对象操作
tasks/*.js      权限 → 读配置 → 有界循环 → backApp
```

| 界面 | 任务 |
|------|------|
| `page.js` 只存配置、刷新、`permission.runScript` | 包名常量；先 `App.isAppInstalled` 再 `launch` |
| 开始前校验必填，用 `this.toast` | **不要** `currentPackage()` 判断是否在目标 App，用互斥节点。见 [`page-state.md`](../02-script/pitfalls/page-state.md) |
| 列表项稳定 `id`；行内 `onTap` / `onChange` 用 `e.item` / `e.index` / `e.value` | `waitFindOne()` 禁止用于循环；用 `findOne` / `findOneBy(timeout)` |
| `getObj` 数组先拷成纯对象再改再 `putObj` | 写选择器前 snapshot；点击前 `filter` 屏内 |
| `putInteger`/`getInteger` 成对；整数先 `contains` | 刷流失败 skip。见 [`skip-on-item-failure.md`](../02-script/pitfalls/skip-on-item-failure.md) |
| | 输入：click → 重 find → `setText` → 校验。屏宽高用 `Device.*` |
| | 已切目标 App：`FloatDialogs`；坐标点击前 `setFloatWindowClickable(false)` |
| | 业务用对象方法，禁止顶层 `function`。见 [`code-org.md`](../02-script/code-org.md) |
