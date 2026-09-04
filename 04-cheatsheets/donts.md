# 生成前自检（禁止项）

对照本表再输出代码。违反任一项都不要落盘。

| 禁止 | 正确做法 |
|------|----------|
| 在 JSON `action` 里执行脚本、编造 `executeScript` action | 按钮写 `onTap`，在 `page.js` 里 `Engines.executeScript('tasks/xxx.js')`。见 [`run-task-from-ui.md`](../03-recipes/run-task-from-ui.md) |
| 把找节点、循环任务写在 `page.js` | `page.js` 只做界面和启动；业务在 `tasks/*.js` |
| 生成 V1 `hooks`、`app_start`、`Engines.closeHook` 当初始化 | **Pro 没有 Hook**。逻辑放 `onLoad` / 任务脚本。见 [`no-hook.md`](../02-script/api/no-hook.md) |
| WebView 与 Page 互调、`javascript:` 桥、读本地文件 | WebView 不和 Page 通信。外链用 `openUrl`。见组件 `webview` |
| 箭头函数、`async` / `await`、`?.`、`??` | 只用 `function` / `var` / `let`。异步用回调或 `then` |
| 有 `page.json` 却不写同目录 `page.js` | 每个页面都要 `Page({})`，哪怕是空的 |
| 多页不注册、自定义组件不注册 | 入口 `pages` / `components`；`homePage` 目录本身不必再放入 `pages` |
| 底栏切页用 `navigate` | 用 `switchTab` 或 `bottomMenus` 的 `page` |
| 列表 `bind` 空数组指望自动 Empty | 自己放 `"type": "empty"` + `showIf`。list 空数组不渲染行，也不自动占位 |
| `webview` 不写 `style.height` | 必须写高度，否则默认 240dp，布局会乱 |
| 组件 JSON 漏 `"component": true` | 自定义组件根必须 `"component": true`，否则不能当组件加载 |
| 入口 JSON 漏 `icon`，或只写路径不生成图片文件 | 必须 `"icon": "img/xhs.svg"`，并把 svg/png 文件一并写入工程 |
| 写 `host` / `debug` / `apis`，或生成 `deekeScript-v2.json` | 入口只有 `deekeScript.json`，字段见 [`entry-json.md`](../01-ui/entry-json.md) |
| 在 `deekeScript.json` 写 V1 `groups` / `hooks` 当界面 | 界面是 `pages/*/page.json` |
| HID / 图色 / 媒体不申请权限 | 图色：`Access.isMediaProjectionEnable`；媒体：`hasMediaReadPermission`；HID：蓝牙权限。见对应 API 卡 |
| DeviceApp 等 DO API 不先查 `isDeviceOwner` | 先 [`do-mode.md`](../02-script/api/do-mode.md) |
| `executeScript` 写成相对当前文件的 `./tasks` | `Engines.executeScript` 路径相对**项目根**：`tasks/sample.js`（与 `require` 不同） |
| `require` 默认写项目根或磁盘绝对路径 | **优先相对路径**：`tasks` 用 `require('../common/x.js')`，`pages/home` 用 `require('../../common/x.js')`。见 [`require.md`](../02-script/require.md) |
| 底栏根页 `back` 指望退出 App | `back` 只关二级页 |
| 找节点写成全局 `text('发送')` / `id(...)` / `desc(...)` | 必须 `UiSelector().text('发送').findOne()`。没有全局 `text()` / `id()` |
| 裸 `findOne()` / `find()` 后直接点击 | **一般先 `filter` 屏内**（丢掉屏幕外 / 越界节点），再查找并点击。很少操作屏幕外内容。见 [`UiSelector.md`](../02-script/api/UiSelector.md) |
| 默认用 KeyBoards 输入、且不检查状态 | 优先 `setText` / 剪贴板；要用输入法时先 `KeyBoards.canInput()`，不行就提示用户 |
| 有 `FloatDialogs.show` 却不关弹窗就继续点节点 | 任务或调试开始前 `FloatDialogs.closeAll()` |
| 用户没提悬浮窗菜单却写了 `floatWindow.menus` / 空 menus | **默认不写**。系统已是连点两次停止（3 秒内），见 [`floatWindow.md`](../01-ui/capabilities/floatWindow.md#两种球不要混) |
| 悬浮窗菜单里用 `Engines.closeAll()` 停任务 | 菜单回调须用 `FloatWindow.stopTask()`；自动停才在 `tasks/*.js` 里 `Engines.closeAll()`。见 [`floatWindow.md`](../01-ui/capabilities/floatWindow.md#关闭任务底层逻辑必读) |
| 把可调节数值写成 `progress` / `progressBar`（运行速度、点赞概率） | 用 `"type": "slider"`。`progress` 只能展示、不能拖。见 [`slider.md`](../01-ui/components/slider.md) |
| 把 `slider` 和 `progress` 当成别名 | 两者字段相近但行为不同。只读进度才用 `progress` / `progressBar` |
| 用页面根 `title` 同时又放 `navBar` 画两套顶栏 | 自制顶栏时 `"title": { "hidden": true }`，再写 `type: navBar` |
| 把 `background` / `color` / `width` 写在组件根上 | 写进 `style`。见 [`_common.md`](../01-ui/components/_common.md) |
| 用户要蓝色，按钮仍是默认绿，或声称 button 没有 background | 入口写 `window.theme.primary`。`button` 建议写 `style.background`。导航栏、状态栏、底栏 `selectedColor` 也要一起改 |
| Switch 写 `style.background` 给整行刷底 | Switch / checkbox / radio 换色只写 `style.color`，不要写 `background` |
| 检测失败时 `continue` 但不递增计数、不设 retry 上限 | 加 `retryCount` 或 `processed++`，超过 N 次 `break`，避免无限 toast |

Rhino 其它限制见 [`00-core/constraints.md`](../00-core/constraints.md)。配方入口：[`scaffold.md`](../03-recipes/scaffold.md)。
