# 生成前自检（禁止项）

对照本表再输出代码。违反任一项都不要落盘。

| 禁止 | 正确做法 |
|------|----------|
| 在 JSON `action` 里执行脚本、编造 `executeScript` action | 按钮写 `onTap`，在 `page.js` 里 `Engines.executeScript('tasks/xxx.js')`。见 [`run-task-from-ui.md`](../03-recipes/run-task-from-ui.md) |
| 把找节点、循环任务写在 `page.js` | `page.js` 只做界面和启动；业务在 `tasks/*.js` |
| 生成 V1 `hooks`、`app_start`、`Engines.closeHook` 当初始化 | **V2 没有 Hook**。逻辑放 `onLoad` / 任务脚本。见 [`no-hook.md`](../02-script/api/no-hook.md) |
| WebView 与 Page 互调、`javascript:` 桥、读本地文件 | WebView 不和 Page 通信。外链用 `openUrl`。见组件 `webview` |
| 箭头函数、`async` / `await`、`?.`、`??` | 只用 `function` / `var` / `let`。异步用回调或 `then` |
| 有 `page.json` 却不写同目录 `page.js` | 每个页面都要 `Page({})`，哪怕是空的 |
| 多页不注册、自定义组件不注册 | 入口 `pages` / `components`；`homePage` 目录本身不必再放入 `pages` |
| 底栏切页用 `navigate` | 用 `switchTab` 或 `bottomMenus` 的 `page` |
| 列表 `bind` 空数组指望自动 Empty | 自己放 `"type": "empty"` + `showIf`。list 空数组不渲染行，也不自动占位 |
| `webview` 不写 `style.height` | 必须写高度，否则默认 240dp，布局会乱 |
| 组件 JSON 漏 `"component": true` | 自定义组件根必须 `"component": true`，否则不能当组件加载 |
| 入口 JSON 漏 `icon`，或路径文件不存在 | 必须 `"icon": "img/xhs.svg"` 这类相对项目根的路径，且把文件放进工程。首页、悬浮球、打包都依赖它 |
| 在 `deekeScript.json` 写 V1 `groups` / `hooks` 当界面 | V2 界面是 `pages/*/page.json` |
| HID / 图色 / 媒体不申请权限 | 图色：`Access.isMediaProjectionEnable`；媒体：`hasMediaReadPermission`；HID：蓝牙权限。见对应 API 卡 |
| DeviceApp 等 DO API 不先查 `isDeviceOwner` | 先 [`do-mode.md`](../02-script/api/do-mode.md) |
| `executeScript` 写成相对当前文件的 `./tasks` | 路径相对**项目根**：`tasks/sample.js` |
| 底栏根页 `back` 指望退出 App | `back` 只关二级页 |
| 找节点写成 Auto.js 的 `text('发送').findOnce()` | 必须 `UiSelector().text('发送').findOne()`。没有全局 `text()` / `id()` |
| 把可调节数值写成 `progress` / `progressBar`（运行速度、点赞概率） | 用 `"type": "slider"`。`progress` 只能展示、不能拖。见 [`slider.md`](../01-ui/components/slider.md) |
| 把 `slider` 和 `progress` 当成别名 | 两者字段相近但行为不同。只读进度才用 `progress` / `progressBar` |
| 用页面根 `title` 同时又放 `navBar` 画两套顶栏 | 自制顶栏时 `"title": { "hidden": true }`，再写 `type: navBar` |

Rhino 其它限制见 [`00-core/constraints.md`](../00-core/constraints.md)。配方入口：[`scaffold.md`](../03-recipes/scaffold.md)。
