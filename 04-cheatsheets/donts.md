# 生成前自检（禁止项）

对照本表再输出代码。违反任一项都不要落盘。

| 禁止 | 正确做法 |
|------|----------|
| 把找节点、循环任务写在 `page.js` | `page.js` 只做界面和启动；业务在 `tasks/*.js` |
| WebView 与 Page 互调、`javascript:` 桥、读本地文件 | WebView 不和 Page 通信。外链用 `openUrl`。见组件 `webview` |
| `async` / `await`、`?.`、`??` | 用回调或 `then`；空判断写 `e && e.detail`。箭头可用，见 [`rhino.md`](../00-core/rhino.md) |
| 有 `page.json` 却不写同目录 `page.js` | 每个页面都要 `Page({})`，哪怕是空的 |
| 多页不注册、自定义组件不注册 | 入口 `pages` / `components`；`homePage` 目录本身不必再放入 `pages` |
| 底栏切页用 `navigate` | 用 `switchTab` 或 `bottomMenus` 的 `page` |
| 列表 `bind` 空数组指望自动 Empty | 自己放 `"type": "empty"` + `showIf`。list 空数组不渲染行，也不自动占位 |
| `webview` 不写 `style.height` | 必须写高度，否则默认 240dp，布局会乱 |
| 组件 JSON 漏 `"component": true` | 自定义组件根必须 `"component": true`，否则不能当组件加载 |
| 入口 JSON 漏 `icon`，或只写路径不生成图片文件 | 必须 `"icon": "img/xhs.svg"`，并把 svg/png 文件一并写入工程 |
| HID / 图色 / 媒体不申请权限 | 图色：`Access.isMediaProjectionEnable`；媒体：`hasMediaReadPermission`；HID：蓝牙权限。见对应 API 卡 |
| DeviceApp 等 DO API 不先查 `isDeviceOwner` | 先 [`do-mode.md`](../02-script/api/do-mode.md) |
| `executeScript` 写成相对当前文件的 `./tasks` | `Engines.executeScript` 路径相对**项目根**：`tasks/sample.js`（与 `require` 不同） |
| `require` 默认写项目根或磁盘绝对路径 | **优先相对路径**：`tasks` 用 `require('../common/x.js')`，`pages/home` 用 `require('../../common/x.js')`。见 [`require.md`](../02-script/require.md) |
| 底栏根页 `back` 指望退出 App | `back` 只关二级页 |
| 找节点写成全局 `text('发送')` / `id(...)` / `desc(...)` | 必须 `UiSelector().text('发送').findOne()`。没有全局 `text()` / `id()` |
| 裸 `findOne()` / `find()` 后直接点击 | **一般先 `filter` 屏内**（丢掉屏幕外 / 越界节点），再查找并点击。很少操作屏幕外内容。见 [`UiSelector.md`](../02-script/api/UiSelector.md) |
| 默认用 KeyBoards 输入、且不检查状态 | 优先 `setText` / 剪贴板；要用输入法时先 `KeyBoards.canInput()`，不行就提示用户 |
| **点击输入框 / 半屏后再用点击前的节点 `setText`/`paste`** | 键盘弹起或面板展开后节点常重建。必须 **重新 find**（优先 `editable(true).focused(true)`），再写入并重读 `text` 校验。见 [`stale-node-after-click.md`](../02-script/pitfalls/stale-node-after-click.md)、配方 [`comment-input.md`](../03-recipes/comment-input.md) |
| 用评论列表也会出现的通用 id（如 `title`）判断「在推荐页」 | 用互斥特征（如右侧「未点赞/已点赞」）+ 区域 `filter`。见 [`page-state.md`](../02-script/pitfalls/page-state.md) |
| 找到「发送」但 `clickable=false` 就放弃 | 点 `parent()`，或 `Gesture.click` 节点中心；点坐标前可先 `FloatDialogs.setFloatWindowClickable(false)` |
| 有 `FloatDialogs.show` 却不关弹窗就继续点节点 | 任务或调试开始前 `FloatDialogs.closeAll()` |
| 用户没提悬浮窗菜单却写了 `floatWindow.menus` / 空 menus | **默认不写**。连点两次停止（3 秒内）。细节见 [`constraints.md`](../00-core/constraints.md) MUST 10 |
| 悬浮窗菜单 / 页面按钮用 `Engines.closeAll()` 停任务 | 菜单写 `onTap` + `FloatWindow.on` 里 `FloatWindow.stopTask()`；自动停才在 `tasks/*.js` 里 `Engines.closeAll()`。见 [`constraints.md`](../00-core/constraints.md) MUST 11 |
| 照抄展厅 Demo 的 `hint` / 默认 menus | 见 [`demo-gallery.md`](../00-core/demo-gallery.md) |
| 在 `page.js` 里用 `System.sleep` 等待 | 页面用 `setTimeout`；任务用 `System.sleep` |
| 把可调节数值写成 `progress` / `progressBar`（运行速度、点赞概率） | 用 `"type": "slider"`。`progress` 只能展示、不能拖。见 [`slider.md`](../01-ui/components/slider.md) |
| 把 `slider` 和 `progress` 当成别名 | 两者字段相近但行为不同。只读进度才用 `progress` / `progressBar` |
| 用页面根 `title` 同时又放 `navBar` 画两套顶栏 | 自制顶栏时 `"title": { "hidden": true }`，再写 `type: navBar` |
| 把 `background` / `color` / `width` 写在组件根上 | 写进 `style`。见 [`_common.md`](../01-ui/components/_common.md) |
| 用户要蓝色，按钮仍是默认绿，或声称 button 没有 background | 入口写 `window.theme.primary`。`button` 建议写 `style.background`。导航栏、状态栏、底栏 `selectedColor` 也要一起改 |
| 把搜索框点击变红当成组件自带红底 | 多为 `theme.primary` 继承到聚焦色。艳色品牌 primary 时给 search / input 单独写 `style.focusColor`（中性色）。见 [`search.md`](../01-ui/components/search.md)、[`_common.md`](../01-ui/components/_common.md) |
| Switch 写 `style.background` 给整行刷底 | Switch / checkbox / radio 换色只写 `style.color`，不要写 `background` |
| 检测失败时 `continue` 但不递增计数、不设 retry 上限 | 加 `retryCount` 或 `processed++`，超过 N 次 `break`，避免无限 toast |
| **同一条视频/帖子失败后不前进**（进主页弹窗、读不到抖音号又重进） | 以内容条为进度：失败也 `processed++` 并划走下一条；进主页单次尝试。见 [`skip-on-item-failure.md`](../02-script/pitfalls/skip-on-item-failure.md) |
| `!isFeed` 时 `continue` 且恢复成功就 `failRetry = 0`、不划走 | 会围着同一条死循环。恢复失败必须 skip 前进；见 [`skip-on-item-failure.md`](../02-script/pitfalls/skip-on-item-failure.md) |
| 未片段验证就 `run-file` 整段盲跑 | 先按 [`automation-loop.md`](../00-core/automation-loop.md) 验证找节点 / 点击，再整体跑 |
| 连不上设备却声称已实机验证 | 交付代码并列出用户须开的权限与地址；不得假装已跑通 |
| 同一失败修满 3 轮仍猜 | 按 automation-loop「请求用户协助」，停止空转 |

Rhino 其它限制见 [`00-core/constraints.md`](../00-core/constraints.md)。配方入口：[`scaffold.md`](../03-recipes/scaffold.md)。
