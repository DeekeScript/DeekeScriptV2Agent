# 硬约束

生成或修改任何文件前对照这篇。违反则无法同步、页面无法加载、或任务跑不起来。

细节：[运行时](./runtime.md)、[目录](./project-layout.md)。连机、同步、验证守 [`device.md`](./device.md)。展厅 Demo 勿抄清单：[`demo-gallery.md`](./demo-gallery.md)。

## MUST

| # | 规则 |
|---|------|
| 1 | 项目根必须有 `deekeScript.json`（识别与同步依赖它；字段见 [`entry-json.md`](../01-ui/entry-json.md)）。 |
| 2 | 每个页面 `page.json` + `page.js` 成对，并在入口 `pages` 注册（`id` + `file`）。`homePage` 指向的目录可以不再放入 `pages`。 |
| 3 | 自定义组件 JSON 必须 `"component": true`，`component.json` + `component.js`，并在入口 `components` 注册（或不写数组、按 `components/<id>` 加载）。 |
| 4 | 无障碍长任务写在 `tasks/*.js`。从页面启动：`Engines.executeScript('tasks/xxx.js')`（可先 `permission.runScript`）。 |
| 5 | 表单用 `name` 绑定 `Page.data`；**同一页面内所有 `name` 必须唯一**（含 list 行、range 两端）。任务用 `Storage` 读配置；Storage 键加项目前缀，禁止用裸 `name`，多页同名字段再加页面/模块名。见 [`form-name.md`](../01-ui/pitfalls/form-name.md)。 |
| 6 | 底栏 Tab 用 `switchTab`，不要用 `navigate`。 |
| 7 | Rhino 1.8：可用 `function` / 箭头 / `var` / `let`。颜色 `#RRGGBB`；尺寸 dp，字号 sp。 |
| 8 | `require` **优先** `./`、`../` 相对当前文件。不以 `./`/`../` 开头时相对项目根。禁止磁盘绝对路径。导出用 `module.exports`。 |
| 9 | **先连手机，再编写**。改完文件就 **`write` 同步**到手机；写完后必须按 [`device.md`](./device.md) 调试验证再交付。仅 `run` 传代码字符串做短验证时可跳过本次 `write`。 |
| 10 | **默认不写** `floatWindow` / `menus`。未配时连点两次停止（第一次变关闭图标，**3 秒内**再点）。用户要自定义菜单时：`menus` 最多 5 个；每项用 `onTap`，与 `FloatWindow.on` **同一轮**交付。停止回调写 `FloatWindow.stopTask()`。见 [`floatWindow.md`](../01-ui/capabilities/floatWindow.md)。 |
| 10b | **默认不写** `FloatPage` / `floats/`。仅用户要悬浮窗（系统层 JSON 界面）时生成；与悬浮球 menus 分离。见 [`floatPage.md`](../01-ui/capabilities/floatPage.md)。 |
| 11 | 停任务：菜单手动 → `FloatWindow.stopTask()`；任务内自动 → `tasks/*.js` 里 `Engines.closeAll()`（须在任务脚本线程）。见 [`floatWindow.md`](../01-ui/capabilities/floatWindow.md#停任务权威)。 |
| 12 | 入口必须写 `icon`，且该路径的**文件必须生成**。 |
| 13 | 颜色、背景、圆角、宽高写在 `style`。`button` 换色用 `style.background`。见 [`_common.md`](../01-ui/components/_common.md)。 |
| 14 | 用户指定主题色时：入口 `window.theme.primary`、导航栏、状态栏、底栏 `selectedColor`、各 `button` 的 `style.background` 一并改。不要沿用默认 `#006A65`。 |
| 15 | 页面等待用 `setTimeout`；任务等待用 `System.sleep`。不要在 `page.js` 里用 `System.sleep` 阻塞 UI。 |
| 16 | **任务验证完成条件**（设备 `status` 正常）：`tasks/*.js` 必须在目标 App / 目标页跑过片段 `run`，回复中须有关键节点 `text`/`desc`/`bounds` 的 logs。**「片段」= 单个动作**，不是整段任务少跑几条。各分段通过后才 `run-file` 做验收（可用数量=1）。操作第三方 App：写选择器前必须按 [`app-survey.md`](../02-script/pitfalls/app-survey.md) 调研，再用 `/ai/nodes` 或**无图** `snapshot`；分段测见 [`segment-test.md`](../02-script/pitfalls/segment-test.md)。**能不截图就不截图**：优先 `run` logs；图色用 `Images.*` 打结果日志；禁止用整屏识图代替节点 logs。仅 `write`、仅权限、仅 `Storage` **不算**已调试。用户任务本身要操作第三方 App 时，启动目标 App 做调研和分段验证**不必再问**。细节见 [`device.md`](./device.md)。 |
| 17 | **底栏根页**展示 Storage 派生数据（摘要、列表、记录）时，必须在 `onShow` 里重新读取再 `setData`。切 Tab 不走 `onLoad`。见 [`page-js.md`](../01-ui/page-js.md)、[`workbench.md`](../03-recipes/workbench.md)。 |
| 18 | 操作第三方 App：用目标页互斥节点判断是否在目标界面。用户要求做完回到本 App 时，任务结束调用 `App.backApp()` 再 `Engines.closeAll()`。见 [`workbench.md`](../03-recipes/workbench.md)、[`page-state.md`](../02-script/pitfalls/page-state.md)。 |
| 19 | **业务代码用对象 + 方法简写**（`common/*.js`、`tasks/*.js`）：`module.exports = { like() {} }` 或 `let task = { run() {} }; task.run()`。禁止文件顶层堆 `function like() {}`。API 回调与 `.filter` 仍可用 `function`。仅 `common/permission.js` 按 snippet 整份复制除外。见 [`code-org.md`](../02-script/code-org.md)。 |
| 20 | **调试时保持 DeekeScript 进程存活**（`/ai` 跑在它里面）。`Gesture.back()` 只用于**仍在目标 App 窗口内**的 overlay，每次最多 1 次再重新看节点。误入系统设置用节点 `packageName` / `getPackageName()` 识别，然后 `App.launch(目标包名)`，不要连按返回。权限弹窗只点「关闭 / 取消 / 暂不」，不要点会跳设置的「确认 / 去开启」。宿主挂了（`floatService` false、`run` 409）必须停下来让用户重开 DeekeScript。见 [`keep-host-alive.md`](../02-script/pitfalls/keep-host-alive.md)。 |
| 21 | **写业务选择器前必须调研目标 App。** 用户原话里的每种对象形态、每一层列表都要实际打开、拉节点、记下互斥特征。没摸到的形态禁止当已支持。写循环前必须书面回答进度模型（一屏几条、何时滚动）。见 [`app-survey.md`](../02-script/pitfalls/app-survey.md)、[`progress-model.md`](../02-script/pitfalls/progress-model.md)。 |

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
| 13 | 禁止刷流时对**同一条**内容失败后反复进主页 / 不前进。须以内容条为进度，失败 skip 到**下一条未处理目标**。当前屏还有未处理目标时禁止滚动把它们划走。见 [`skip-on-item-failure.md`](../02-script/pitfalls/skip-on-item-failure.md)、[`progress-model.md`](../02-script/pitfalls/progress-model.md)。 |
| 14 | 禁止在设备已连接时，用「怕误操作 / 高风险 / 未整段盲跑 / 请用户自己运行」跳过 `launch` 目标 App、节点获取、找节点片段。 |
| 15 | 禁止把 `status`、`Storage` 读写、`require` 能加载、本工程 UI 预览、**仅拉截图识图**当作 `tasks/*.js` 已验证。无障碍能定位时禁止默认 `snapshot -Image` / `/ai/capture` 做视觉验证。 |
| 16 | 禁止同一页面内重复的表单 `name`。禁止用裸 `name` 当 Storage 键：默认 Storage 跨页共享，会互相覆盖。见 [`form-name.md`](../01-ui/pitfalls/form-name.md)。 |
| 17 | 禁止用 `System.currentPackage()` 判断是否在目标 App（它常仍是本工程包名）。用互斥节点。禁止任务循环里 `waitFindOne()` 无超时。 |
| 18 | 禁止在 `common/*.js`、`tasks/*.js` 顶层堆业务 `function foo() {}`（`permission.js` snippet 除外）。必须对象 + 方法简写。见 [`code-org.md`](../02-script/code-org.md)。 |
| 19 | 禁止给组件事件发明文档未写的字段。list / grid 行内 `onTap` / `onChange` 用 `e.item`、`e.index`、`e.value`。见 [`switch.md`](../01-ui/components/switch.md)、[`events.md`](../01-ui/events.md)。 |
| 20 | 禁止 `while` 里连续 `Gesture.back()` / `Gesture.home()` 来「退回目标 App」。禁止点目标 App 权限弹窗里会跳系统设置的「确认 / 允许 / 去开启 / 去设置」。误入 `com.android.settings` 时禁止再用返回键清栈。见 [`keep-host-alive.md`](../02-script/pitfalls/keep-host-alive.md)。 |
| 21 | 禁止需求里的并列形态只覆盖了一种。禁止把列表子项当父项而不先用节点区分。见 [`app-survey.md`](../02-script/pitfalls/app-survey.md)。 |
| 22 | 禁止用整段 `run-file`（哪怕数量=1）作为某个动作的**第一次**测试。开发中停在目标页做分段 `run`；整段任务只做验收。见 [`segment-test.md`](../02-script/pitfalls/segment-test.md)。 |
| 23 | 禁止当前屏仍有未处理目标时滚动去「下一条」。滚动只加载看不见的条目。禁止把「一屏一条」的滑动套到一屏多条的列表。见 [`progress-model.md`](../02-script/pitfalls/progress-model.md)。 |

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
| 刷流 / 进主页失败 | skip 本条并前进到下一条未处理（同屏优先） | 同一条反复进主页；或同屏还有条目却 swipe |
| 列表循环 | 先数当前屏目标；耗尽再滚动 | 处理第一条就滑；套用一屏一条的滑动 |
| 手动停（无 menus） | 连点悬浮球两次 | 无故生成 stop 菜单 |
| 自动停 | `tasks/*.js` 里 `Engines.closeAll()` | 只在页面回调里 closeAll |
| 任务已验证 | 先调研各形态；分段 `run` 打出节点 logs；再 `run-file` 验收 | 只测 Storage / 权限 / write，或只拉截图识图就交活 |
| 操作第三方 App | 并列形态都摸到；父子层分开；单步分段测；验收才整段 | 只做一种形态；子项当父项；一上来 `run-file`；或以「会真实发出」为由不启动目标 App |
| 写选择器前 | 每种形态、每层列表都打开 + 拉节点 | 凭记忆猜 desc；只 snapshot 当前碰巧打开的那一页 |
| 开发中怎么测 | 停在目标页，`run` 只跑该动作 | 用整段 `tasks/*.js`（数量=1）当第一个测试 |
| 表单 `name` | 同一页唯一；Storage 用 `项目.模块.字段` | 页内重名联动；两页都 `put('keyword')` 互相覆盖 |
| 业务组织 | `let video = { like() {} }` | 文件里一堆 `function like() {}` |
| 列表表单 | `e.value` + `e.item` / `e.index` 写回该行 | 每行编假 `name`，或只认 `e.value` |
| 底栏页数据 | `onShow` 从 Storage 再读 | 只 `onLoad`，切 Tab 摘要不更新 |
| 是否在目标 App | 互斥节点（如右侧未点赞） | `currentPackage() !== 目标包名` |
| 做完回本 App | `App.backApp()` 再 `closeAll` | 停在抖音页 |
| 前台是哪个窗口 | snapshot / `node.getPackageName()` | `System.currentPackage()`（常仍是 DeekeScript） |
| 误入系统设置 | `App.launch(目标包名)`；宿主挂了问用户 | `while` 连按 `Gesture.back()` |
| 目标 App 权限弹窗 | 「关闭 / 取消 / 暂不 / 以后再说」 | 点「确认」进设置再连按返回 |
