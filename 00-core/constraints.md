# 硬约束

生成或修改任何文件前对照这篇。违反则无法同步、页面无法加载、或任务跑不起来。

细节：[心智模型](./mental-model.md)、[目录](./project-layout.md)、[Rhino](./rhino.md)、[上下文边界](./context-split.md)。编写 `tasks/*.js` 时另守 [`automation-loop.md`](./automation-loop.md)。展厅 Demo 勿抄清单：[`demo-gallery.md`](./demo-gallery.md)。

## MUST

| # | 规则 |
|---|------|
| 1 | 项目根必须有 `deekeScript.json`。 |
| 2 | 每个页面 `page.json` + `page.js` 成对，并在入口 `pages` 注册（`id` + `file`）。`homePage` 指向的目录可以不再放入 `pages`。 |
| 3 | 自定义组件 JSON 必须 `"component": true`，`component.json` + `component.js`，并在入口 `components` 注册（或不写数组、按 `components/<id>` 加载）。 |
| 4 | 无障碍长任务写在 `tasks/*.js`。从页面启动：`Engines.executeScript('tasks/xxx.js')`（可先 `permission.runScript`）。 |
| 5 | 表单用 `name` 绑定 `Page.data`；任务用 `Storage` 读已保存配置。 |
| 6 | 底栏 Tab 用 `switchTab`，不要用 `navigate`。 |
| 7 | Rhino 1.8：`function` / `var` / `let`。颜色 `#RRGGBB`；尺寸 dp，字号 sp。 |
| 8 | `require` **优先** `./`、`../` 相对当前文件。不以 `./`/`../` 开头时相对项目根。禁止磁盘绝对路径。导出用 `module.exports`。 |
| 9 | 改工程文件后须同步到手机再验证。同步用 `POST /ai/project/write` 或 `tools/deeke-device.* write`（见 [`ai-device-debug.md`](./ai-device-debug.md)）。改 `tasks/*.js` 后若要用 `run-file` 或交付执行，须先 `write`；仅 `run` 传代码字符串可跳过。 |
| 10 | **默认不写** `floatWindow` / `menus`。未配时连点两次停止（第一次变关闭图标，**3 秒内**再点）。用户要自定义菜单时：`menus` 最多 5 个；与 JSON **同一轮**交付。内置 `"action": "stop"|"hide"|"start"|"executeScript"` 由框架处理，不必再 `FloatWindow.on`；带 `onTap` / 自定义逻辑的项必须 `FloatWindow.on` 绑定。见 [`float-window.md`](../03-recipes/float-window.md)。 |
| 11 | 停任务：菜单手动 → `FloatWindow.stopTask()`；任务内自动 → `tasks/*.js` 里 `Engines.closeAll()`（须在任务脚本线程）。见 [`floatWindow.md`](../01-ui/capabilities/floatWindow.md#停任务权威)。 |
| 12 | 入口必须写 `icon`，且该路径的**文件必须生成**。 |
| 13 | 颜色、背景、圆角、宽高写在 `style`。`button` 换色用 `style.background`。见 [`_common.md`](../01-ui/components/_common.md)。 |
| 14 | 用户指定主题色时：入口 `window.theme.primary`、导航栏、状态栏、底栏 `selectedColor`、各 `button` 的 `style.background` 一并改。不要沿用默认 `#006A65`。 |
| 15 | 页面等待用 `setTimeout`；任务等待用 `System.sleep`。不要在 `page.js` 里用 `System.sleep` 阻塞 UI。 |

## MUST NOT

| # | 规则 |
|---|------|
| 1 | 禁止在**页面** JSON `action` 里执行脚本或写长任务。页面 `action` 只允许：`navigate` / `redirect` / `switchTab` / `back` / `toast` / `save` / `openUrl`。（悬浮窗 `menus[].action` 是另一套，见 entry-json。） |
| 2 | 禁止对 `page.js` 点「仅当前文件执行」。 |
| 3 | 不要写 `hooks` / `groups`，不要调用 `Engines.closeHook()`。初始化见 [`no-hook.md`](../02-script/api/no-hook.md)。 |
| 4 | WebView 不和 `Page` 通信。整页开外链用 `openUrl`。 |
| 5 | 自定义组件禁止成环引用。 |
| 6 | 禁止 `async/await`、箭头函数、`?.`、`??`、`import` / `export`。 |
| 7 | 禁止把 Demo 的 `permission.hint('请在文件 xxx 编写业务')` 写进产物。 |
| 8 | 禁止用 `navigate` 切底栏；禁止指望底栏根页 `back` 退出应用。 |
| 9 | 禁止把 `UiSelector` 主流程写进 `page.js` 的 `onTap` 并长时间阻塞。 |
| 10 | 禁止全局 `text()` / `id()` / `desc()`。必须 `UiSelector().text('发送').findOne()`。点击前一般先 `filter` 屏内。 |
| 11 | 禁止把可调节数值写成 `progress` / `progressBar`。用 `slider`。 |
| 12 | 禁止把 `background` / `color` / `width` / `height` 写在组件根上。必须在 `style`。 |
| 13 | 禁止写 `host` / `debug` / `apis`。入口文件名只能是 `deekeScript.json`。 |
| 14 | 禁止在悬浮窗菜单回调或页面按钮里用 `Engines.closeAll()` 停整项任务（无效）。手动停用 `FloatWindow.stopTask()`，或菜单内置 `"action":"stop"`。 |

## 快速对照

| 场景 | 正确 | 错误 |
|------|------|------|
| 跑自动化 | `tasks/sample.js` + `Engines.executeScript` | 页面 JSON `"action": { "type": "runScript" }` |
| 入口图标 | `"icon": "img/xhs.svg"` 且文件存在 | 漏 `icon` 或只写路径 |
| 切底栏 | `switchTab` | `navigate` |
| 页面延时 | `setTimeout(function () { ... }, 2000)` | `page.js` 里 `System.sleep` |
| 任务延时 | `System.sleep(1000)` | 页面回调里堵 UI |
| 可调节数值 | `"type": "slider"` | `"type": "progress"` 当滑动条 |
| 按钮换色 | `"style": { "background": "#1565C0" }` | 根上写 `"background"` |
| 手动停（有 menus） | `FloatWindow.stopTask()` 或 `"action":"stop"` | 菜单/页面里 `Engines.closeAll()` |
| 手动停（无 menus） | 连点悬浮球两次 | 无故生成 stop 菜单 |
| 自动停 | `tasks/*.js` 里 `Engines.closeAll()` | 只在页面回调里 closeAll |
