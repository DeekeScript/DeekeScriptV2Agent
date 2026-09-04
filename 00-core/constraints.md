# 硬约束

生成或修改任何文件前对照这篇。违反则无法同步、页面无法加载、或任务跑不起来。

细节：[心智模型](./mental-model.md)、[目录](./project-layout.md)、[Rhino](./rhino.md)、[上下文边界](./context-split.md)。连机、同步、验证守 [`automation-loop.md`](./automation-loop.md)。展厅 Demo 勿抄清单：[`demo-gallery.md`](./demo-gallery.md)。

## MUST

| # | 规则 |
|---|------|
| 1 | 项目根必须有 `deekeScript.json`（识别与同步依赖它；字段见 [`entry-json.md`](../01-ui/entry-json.md)）。 |
| 2 | 每个页面 `page.json` + `page.js` 成对，并在入口 `pages` 注册（`id` + `file`）。`homePage` 指向的目录可以不再放入 `pages`。 |
| 3 | 自定义组件 JSON 必须 `"component": true`，`component.json` + `component.js`，并在入口 `components` 注册（或不写数组、按 `components/<id>` 加载）。 |
| 4 | 无障碍长任务写在 `tasks/*.js`。从页面启动：`Engines.executeScript('tasks/xxx.js')`（可先 `permission.runScript`）。 |
| 5 | 表单用 `name` 绑定 `Page.data`；任务用 `Storage` 读已保存配置。 |
| 6 | 底栏 Tab 用 `switchTab`，不要用 `navigate`。 |
| 7 | Rhino 1.8：可用 `function` / 箭头 / `var` / `let`。颜色 `#RRGGBB`；尺寸 dp，字号 sp。 |
| 8 | `require` **优先** `./`、`../` 相对当前文件。不以 `./`/`../` 开头时相对项目根。禁止磁盘绝对路径。导出用 `module.exports`。 |
| 9 | **先连手机，再编写**。编写与修改过程中改完文件就 **主动 `write` 同步**到手机；写完后 **主动调试验证**再交付。命令见 [`ai-device-debug.md`](./ai-device-debug.md)，闭环见 [`automation-loop.md`](./automation-loop.md)。仅 `run` 传代码字符串做短验证时可跳过本次 `write`。 |
| 10 | **默认不写** `floatWindow` / `menus`。未配时连点两次停止（第一次变关闭图标，**3 秒内**再点）。用户要自定义菜单时：`menus` 最多 5 个；每项用 `onTap`，与 `FloatWindow.on` **同一轮**交付。停止回调写 `FloatWindow.stopTask()`。见 [`float-window.md`](../03-recipes/float-window.md)。 |
| 11 | 停任务：菜单手动 → `FloatWindow.stopTask()`；任务内自动 → `tasks/*.js` 里 `Engines.closeAll()`（须在任务脚本线程）。见 [`floatWindow.md`](../01-ui/capabilities/floatWindow.md#停任务权威)。 |
| 12 | 入口必须写 `icon`，且该路径的**文件必须生成**。 |
| 13 | 颜色、背景、圆角、宽高写在 `style`。`button` 换色用 `style.background`。见 [`_common.md`](../01-ui/components/_common.md)。 |
| 14 | 用户指定主题色时：入口 `window.theme.primary`、导航栏、状态栏、底栏 `selectedColor`、各 `button` 的 `style.background` 一并改。不要沿用默认 `#006A65`。 |
| 15 | 页面等待用 `setTimeout`；任务等待用 `System.sleep`。不要在 `page.js` 里用 `System.sleep` 阻塞 UI。 |

## MUST NOT

| # | 规则 |
|---|------|
| 1 | 页面 JSON `action` 的 `type` 仅限 [`page-json.md`](../01-ui/page-json.md#json-action) 所列。 |
| 2 | WebView 不和 `Page` 通信。整页开外链用 `openUrl`。 |
| 3 | 自定义组件禁止成环引用。 |
| 4 | 禁止 `async/await`、`?.`、`??`、`import` / `export`。箭头可用。对象方法用简写 `onLoad() {}`，不要 `onLoad: function () {}`，也不要 `onLoad: () => {}`（绑错 `this`）。 |
| 5 | 禁止把 Demo 的 `permission.hint('请在文件 xxx 编写业务')` 写进产物。 |
| 6 | 禁止用 `navigate` 切底栏；禁止指望底栏根页 `back` 退出应用。 |
| 7 | 禁止把 `UiSelector` 主流程写进 `page.js` 的 `onTap` 并长时间阻塞。 |
| 8 | 禁止全局 `text()` / `id()` / `desc()`。必须 `UiSelector().text('发送').findOne()`。点击前一般先 `filter` 屏内。 |
| 9 | 禁止把可调节数值写成 `progress` / `progressBar`。用 `slider`。 |
| 10 | 禁止把 `background` / `color` / `width` / `height` 写在组件根上。必须在 `style`。 |
| 11 | 禁止在悬浮窗菜单回调或页面按钮里用 `Engines.closeAll()` 停整项任务（无效）。手动停用 `FloatWindow.stopTask()`。 |
| 12 | 禁止点击输入框 / 半屏 / 弹键盘后，仍用**点击前**的节点做 `setText` / `paste`。必须重新 `find`（优先 `editable(true).focused(true)`）并校验 `text`。见 [`stale-node-after-click.md`](../02-script/pitfalls/stale-node-after-click.md)。 |
| 13 | 禁止刷流时对**同一条**内容失败后反复进主页 / 不划走。须以内容条为进度，失败 skip 前进。见 [`skip-on-item-failure.md`](../02-script/pitfalls/skip-on-item-failure.md)。 |

## 快速对照

| 场景 | 正确 | 错误 |
|------|------|------|
| 跑自动化 | `tasks/sample.js` + `Engines.executeScript` | 编造不在 [`page-json`](../01-ui/page-json.md#json-action) 表里的 `action` type |
| 入口图标 | `"icon": "img/xhs.svg"` 且文件存在 | 漏 `icon` 或只写路径 |
| 切底栏 | `switchTab` | `navigate` |
| 页面延时 | `setTimeout(function () { ... }, 2000)` | `page.js` 里 `System.sleep` |
| 任务延时 | `System.sleep(1000)` | 页面回调里堵 UI |
| 可调节数值 | `"type": "slider"` | `"type": "progress"` 当滑动条 |
| 按钮换色 | `"style": { "background": "#1565C0" }` | 根上写 `"background"` |
| 手动停（有 menus） | `FloatWindow.stopTask()`（`onTap` + `FloatWindow.on`） | 菜单/页面里 `Engines.closeAll()` |
| 评论 / 输入 | `click` → 重 find → `setText` → 校验 `text` | `var input=…; input.click(); input.setText(…)` |
| 刷流 / 进主页失败 | skip 本条并划走下一条 | 同一条反复进主页 / `continue` 不前进 |
| 手动停（无 menus） | 连点悬浮球两次 | 无故生成 stop 菜单 |
| 自动停 | `tasks/*.js` 里 `Engines.closeAll()` | 只在页面回调里 closeAll |
