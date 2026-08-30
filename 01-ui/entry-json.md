# 入口 deekeScript-v2.json

创建工程或改首页、底栏、全局窗口、页面/组件注册时读这篇。这个文件必须在项目根目录。只跑脚本时用它识别工程，不必打开 `homePage`。做界面时启动经过 Splash 后进入 `homePage`。字段一律按下表写，不要抄 V1 的 `groups` / `hooks`。

## 主体参数

| 参数名 | 类型 | 必填 | 示例 | 说明 |
|--------|------|------|------|------|
| name | String | 否（打包建议写） | Deeke | 安装后手机上的名称 |
| packageName | String | 否（打包建议写） | cn.deeke.demo | 包名，不要用默认包名 |
| versionCode | String | 否（打包建议写） | 100 | 版本号，升级凭证 |
| versionName | String | 否（打包建议写） | 1.0.0 | 版本名称 |
| icon | String | 是 | img/xhs.svg | 工程图标。路径相对项目根，文件必须存在（png / jpg / svg）。首页、悬浮球、打包都会用 |
| homePage | String | 做界面时是 | pages/home | 入口页面文件夹，加载该目录 `page.json` / `page.js`。无需再放入 `pages`。只跑脚本时可不写 |
| window | Object | 否 | 见下表 | 全局窗口。先应用，再由当前页面覆盖 |
| pages | Array | 否 | 见下表 | 页面别名。跳转也可直接写文件夹 |
| components | Array | 否 | 见下表 | 自定义组件别名。不写则按 `components/<id>` 加载 |
| bottomMenus | Array | 否 | 见下表 | 底部 Tab。不配或 `[]` 则隐藏底栏 |
| bottomMenusHidden | Boolean | 否 | true | 强制隐藏底栏 |
| tabBar | Object | 否 | 见 window.tabBar | 也可写在入口根上，与 `window.tabBar` 同类 |
| floatWindow | Object | 否 | 见下表 | 项目悬浮窗展开菜单。开发器那颗球不读这份配置 |

兼容：`homePage` 写成页面 id（如 `"home"`）会先在 `pages` 中查找，未找到则按 `pages/home` 加载。

## window

先读入口 `window`，再读当前页 `page.json`，同名字段由页面覆盖。

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| style | Object | 否 | 内容区：`padding` / `margin` / `background`。未写 padding 时为 16（dp） |
| title | String / Object | 否 | 导航栏默认样式。页面未写 `title` 时不显示导航栏 |
| statusBar | String / Object | 否 | 顶部状态栏。字符串为背景色 |
| tabBar | Object | 否 | 底部 Tab 颜色 |

`statusBar` 为对象时：

| 参数名 | 类型 | 说明 |
|--------|------|------|
| background | String | 状态栏背景。未写时跟随导航栏 `title.background` |
| color | String | 图标颜色：`light` 或 `dark`。未写时按背景明暗推断 |

## pages[]

| 参数名 | 类型 | 必填 | 示例 | 说明 |
|--------|------|------|------|------|
| id | String | 是 | stats | 别名，用于跳转和底栏 |
| file | String | 是 | pages/stats | 页面目录，也可写成 `pages/stats/page.json` |
| title | String | 否 | 数据统计 | 备用标题；`page.json` 的 title 优先 |

## components[]

| 参数名 | 类型 | 必填 | 示例 | 说明 |
|--------|------|------|------|------|
| id | String | 是 | choose | 页面里 `"type": "choose"` |
| file | String | 是 | components/choose | 组件目录，也可写成 `components/choose/component.json` |

组件 JSON 必须 `"component": true`。见 [自定义组件](./component-custom.md)。

## bottomMenus[]

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| title | String | 是 | 菜单文字，也可用 `{NAME}` |
| icon | String | 否 | 图标路径，如 `img/home.svg` |
| page | String | 是 | 入口文件夹或 `pages` 中的 id。未写则回落到 `homePage` |
| selectedIcon | String | 否 | 选中态图标。未写则沿用 `icon` 并按选中色着色 |
| badge | String / Number | 否 | 初始角标。运行时用 `this.setTabBarItem` 改 |

## window.tabBar

不写则默认绿/灰。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| color | String | 未选中文字色，默认 `#6F7978`。入口未写 `iconColor` 时，初始图标也用这个 |
| selectedColor | String | 选中文字色，默认 `#006A65`。也可用 `activeColor` |
| iconColor | String | 未选中图标色。不写则初始跟 `color`。运行时只改 `color` 不会改图标 |
| selectedIconColor | String | 选中图标色。不写则初始跟 `selectedColor` |
| background | String | 底栏背景，默认 `#FFFFFF`。也可用 `backgroundColor` |
| borderColor | String | 顶部分割线，默认 `#EEEEEE` |
| fontSize | Number | 文字大小（sp） |

运行时改底栏见 [底部菜单](./capabilities/tabBar.md)。

## floatWindow

只作用于**项目悬浮窗**（点「运行」进入项目后，或打包 App）。`menus` 默认约 3 个，最多 5 个，超过只展示前 5 个。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| menus | Array | 展开图标 |

`menus[]`：

| 参数名 | 类型 | 说明 |
|--------|------|------|
| id | String | 给 `FloatWindow.on` / `update` 用 |
| icon | String | 内置名 `close` / `play` / `hide`，或工程内图片 |
| label | String | 图标下方短文案 |
| action | String | 内置：`stop` / `hide` / `start` / `executeScript` |
| file | String | `action` 为 `executeScript` 时的脚本路径 |
| onTap | String | 点击时调用的 JS 函数名 |
| show | String | `always`（默认）、`running`、`idle` |
| background | String | 圆形底色，如 `#FFFFFF` |

完整方法见 [悬浮球](./capabilities/floatWindow.md)。

## 最小配置

```json
{
  "name": "Deeke",
  "packageName": "cn.deeke.demo",
  "icon": "img/xhs.svg",
  "homePage": "pages/home"
}
```

入口必须含 `icon`，且工程内该文件存在。做界面时有这一份就能进首页。只跑脚本时，这个文件用来识别工程。

## 完整示例

```json
{
  "name": "Deeke",
  "packageName": "cn.deeke.demo",
  "versionCode": "100",
  "versionName": "1.0.0",
  "icon": "img/xhs.svg",
  "homePage": "pages/home",
  "window": {
    "style": {
      "background": "#F5F5F5",
      "padding": 16
    },
    "title": {
      "fontSize": 18,
      "color": "#FFFFFF",
      "background": "#006A65"
    },
    "statusBar": {
      "background": "#006A65",
      "color": "light"
    },
    "tabBar": {
      "color": "#6F7978",
      "selectedColor": "#006A65",
      "background": "#FFFFFF",
      "borderColor": "#EEEEEE"
    }
  },
  "pages": [
    { "id": "stats", "file": "pages/stats", "title": "统计" },
    { "id": "settings", "file": "pages/settings", "title": "设置" },
    { "id": "detail", "file": "pages/detail", "title": "详情" }
  ],
  "components": [
    { "id": "choose", "file": "components/choose" }
  ],
  "bottomMenus": [
    { "title": "{NAME}", "icon": "img/home.png", "page": "pages/home" },
    { "title": "统计", "icon": "img/statistics.png", "page": "pages/stats", "badge": 3 },
    { "title": "设置", "icon": "img/setting.png", "page": "pages/settings" }
  ],
  "floatWindow": {
    "menus": [
      { "id": "stop", "icon": "close", "label": "停止", "action": "stop", "show": "running" }
    ]
  }
}
```

写好入口后给 `homePage` 目录写 [页面 JSON](./page-json.md)。
