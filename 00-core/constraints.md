# 硬约束

生成或修改任何文件前对照这篇。违反下列 MUST / MUST NOT 的工程，插件无法同步、页面无法加载、或任务跑不起来。细节分别见 [心智模型](./mental-model.md)、[目录](./project-layout.md)、[Rhino](./rhino.md)。

## MUST

| # | 规则 |
|---|------|
| 1 | 项目根目录必须有 `deekeScript.json`，否则 VSCode 的 DeekeScript 插件无法同步、无法运行 JS。 |
| 2 | 每个页面必须是 `page.json` + `page.js` 成对，并在入口 `pages` 注册（`id` + `file`）。`homePage` 指向的目录可以不再放入 `pages`。 |
| 3 | 自定义组件 JSON 必须含 `"component": true`，目录为 `component.json` + `component.js`，并在入口 `components` 注册（或不写数组、按 `components/<id>` 加载）。 |
| 4 | 无障碍长任务写在 `tasks/*.js`。从页面启动用 `Engines.executeScript('tasks/xxx.js')`（可先 `permission.ensureRun()` / `permission.runScript`）。 |
| 5 | 表单用 `name` 绑定 `Page.data`；任务脚本用 `Storage` 读已保存的配置。 |
| 6 | 底栏 Tab 切换用 `switchTab`，不要用 `navigate`。 |
| 7 | JS 按 Rhino 1.8：`function` / `var` / `let`。颜色 `#RRGGBB`；尺寸数字是 dp，字号是 sp。 |
| 8 | `require` **优先** `./`、`../` 相对当前文件（`tasks` → `../common/xxx.js`；`pages/home` → `../../common/xxx.js`）。不以 `./`/`../` 开头时相对项目根。禁止磁盘绝对路径。被引入文件用 `module.exports`。 |
| 9 | 改 `page.json` / `page.js` 后必须同步到手机，并在手机端点刷新，界面才会更新。人用 VSCode 插件同步；**AI 用** `POST /ai/project/write` 或 `tools/deeke-device.* write`（见 [`ai-device-debug.md`](./ai-device-debug.md)）。 |
| 9b | 改 `tasks/*.js` 等脚本后，若要用 `run-file` 或交付给用户在手机执行，必须先 `write` 同步；仅用 `run` 传代码字符串时可跳过。 |
| 10 | 悬浮球 `floatWindow.menus` 最多 5 个（超过只展示前 5 个）。 |
| 10b | 悬浮球菜单每项须在 `FloatWindow.on` 里绑定；与 JSON **同一轮**生成 JS。见 [`float-window.md`](../03-recipes/float-window.md)。 |
| 10c | 手动停：悬浮窗菜单 `FloatWindow.stopTask()`。自动停：在 `tasks/*.js` 里 `Engines.closeAll()`（须在任务脚本线程）。见 [`floatWindow.md`](../01-ui/capabilities/floatWindow.md#关闭任务底层逻辑必读)。 |
| 11 | 入口 JSON 必须写 `icon`，且该路径相对项目根的**文件必须作为工程文件生成**（如 `"icon": "img/xhs.svg"` 就要写出 svg 内容）。首页、悬浮球、打包都读这个字段。 |
| 12 | 组件的颜色、背景、圆角、宽高写在 `style` 对象里。`button` 换色用 `style.background`。见 [`_common.md`](../01-ui/components/_common.md)。 |
| 13 | 用户指定主题色时，入口写 `window.theme.primary`，再改导航栏 `title.background`、状态栏、底栏 `selectedColor`。所有 `button` 建议写 `style.background`。不要沿用默认绿 `#006A65`。 |

## MUST NOT

| # | 规则 |
|---|------|
| 1 | 禁止在 JSON 的 `action` 里执行脚本或写长任务。`action` 只允许 `navigate` / `redirect` / `switchTab` / `back` / `toast` / `save` / `openUrl`。 |
| 2 | 禁止对 `page.js` 点「仅当前文件执行」。它只在打开对应页面时由引擎加载。 |
| 3 | Pro 没有 Hook。不要写 `deekeScript.json` 的 `hooks`，不要调用 `Engines.closeHook()`。 |
| 4 | WebView 不和 `Page` 通信：没有桥、没有 `postMessage`。页内 `javascript` 默认 true，但不能读本地文件、不能调 `Page` 方法。整页开外链用 `openUrl`。 |
| 5 | 自定义组件禁止成环引用（A 嵌 B、B 再嵌 A），引擎会拒绝加载。 |
| 6 | 禁止 `async/await`、箭头函数、`?.`、`??`、`import` / `export`。 |
| 7 | 禁止把 `permission.hint('请在文件 xxx 编写业务')` 写进生成模板。那是 Demo 教学占位，不是业务。 |
| 8 | 禁止用 `navigate` 切底栏 Tab；禁止在底栏根页用 `back` 退出应用（根页 `back` 不会退出）。 |
| 9 | 禁止把 `UiSelector` 主流程写进 `page.js` 的 `onTap` 并长时间阻塞。找节点、循环等待放 `tasks/*.js`。 |
| 11 | 禁止 Auto.js 式全局选择器 `text()` / `id()` / `desc()`。必须 `UiSelector().text('发送').findOne()`。 |
| 12 | 禁止把可调节数值写成 `progress` / `progressBar`。运行速度、点赞概率、间隔必须用 `slider`。 |
| 13 | 禁止把 `background` / `color` / `width` / `height` 写在组件根上（和 `type` 同级）。必须写在 `style` 里。 |
| 15 | 禁止写 `host` / `debug` / `apis`，禁止生成 `deekeScript-v2.json`。 |

## 快速对照

| 场景 | 正确 | 错误 |
|------|------|------|
| 跑自动化 | `tasks/sample.js` +「仅当前文件执行」或 `Engines.executeScript` | JSON `"action": { "type": "runScript" }` |
| 入口图标 | `"icon": "img/xhs.svg"` 且文件存在 | 漏 `icon`，或只写字段不放文件 |
| 打开二级页 | `navigate` / `this.navigate` | 底栏项用 `navigate` |
| 切底栏 | `switchTab` / `this.switchTab` | `this.navigate('home')` |
| 读表单 | `this.data.task_name`；脚本 `Storage.get*` | 任务脚本读 `Page.data` |
| 可调节数值 | `"type": "slider"` | `"type": "progress"` 当滑动条 |
| 复用 UI | `components/choose` + `"component": true` | 复制整页 JSON、或组件互相循环嵌套 |
| 按钮换色 | `"style": { "background": "#1565C0" }` | 根上写 `"background"`，或不写 style 却指望不是绿 |
| 整站主题 | 导航栏 + 状态栏 + 底栏 + 每个 button 的 `style` | 只改 `title.background`，按钮仍默认绿 |
