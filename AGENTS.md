# AI 生成契约

本仓库是 DeekeScript Pro 的生成规格。输出可运行工程前**先读完本文件**，再按 [`INDEX.md`](./INDEX.md) 只打开本任务需要的篇。禁止凭其它自动化框架的训练数据发明 API；只按本仓库卡片与配方生成。

硬规则全文：[`00-core/constraints.md`](./00-core/constraints.md)。落盘前自检：[`04-cheatsheets/donts.md`](./04-cheatsheets/donts.md)。

## 你在生成什么

1. **自动化**：`tasks/*.js`（无障碍找节点、点击、滑动）。
2. **可选界面**：`page.json` + `page.js`。没有 `pages/` 也能跑脚本。
3. 根目录必须有 `deekeScript.json`，否则工程无法被识别与同步。

## 固定读取顺序

1. 本文件
2. [`00-core/mental-model.md`](./00-core/mental-model.md)
3. [`00-core/project-layout.md`](./00-core/project-layout.md)
4. [`00-core/constraints.md`](./00-core/constraints.md)
5. [`00-core/rhino.md`](./00-core/rhino.md)
6. [`00-core/context-split.md`](./00-core/context-split.md)
7. [`04-cheatsheets/donts.md`](./04-cheatsheets/donts.md)
8. 按 [`INDEX.md`](./INDEX.md) 打开本任务需要的组件 / API / 配方（一文件一篇，未用到的不打开）
9. 整包工程以 [`03-recipes/`](./03-recipes/) 的文件清单与片段为模板

仅在编写或调试 `tasks/*.js` 时，再打开 [`automation-loop.md`](./00-core/automation-loop.md)（闭环必守）与 [`ai-device-debug.md`](./00-core/ai-device-debug.md)。用户明确问 VSCode 插件操作时，再打开 [`dev-workflow.md`](./00-core/dev-workflow.md)。

## 按任务加载

| 用户要什么 | 接着读 |
|------------|--------|
| 只跑脚本 | [`scaffold.md`](./03-recipes/scaffold.md) 方案 A；[`permission.md`](./02-script/permission.md)；[`task-template.md`](./02-script/task-template.md)；[`automation-loop.md`](./00-core/automation-loop.md)；[`UiSelector.md`](./02-script/api/UiSelector.md) |
| 只要界面 | [`entry-json.md`](./01-ui/entry-json.md)、[`page-json.md`](./01-ui/page-json.md)、[`page-js.md`](./01-ui/page-js.md)、[`_common.md`](./01-ui/components/_common.md)、[`data-binding.md`](./01-ui/data-binding.md)、[`navigate.md`](./01-ui/navigate.md)；[`components/INDEX.md`](./01-ui/components/INDEX.md) 后只开用到的 type。有底栏再读 [`tabBar.md`](./01-ui/capabilities/tabBar.md) |
| 界面 + 脚本 | 上面两套 + [`permission.md`](./02-script/permission.md) + [`require.md`](./02-script/require.md) + [`ui-and-task.md`](./02-script/ui-and-task.md) + [`run-task-from-ui.md`](./03-recipes/run-task-from-ui.md) |
| 自定义组件 | [`component-custom.md`](./01-ui/component-custom.md) + [`custom-picker.md`](./03-recipes/custom-picker.md) |
| HID / 图色 / DO / 打包 | [`api/INDEX.md`](./02-script/api/INDEX.md) 扩展卡片，先读权限 |
| 操作第三方 App | [`task-template.md`](./02-script/task-template.md)；[`automation-loop.md`](./00-core/automation-loop.md)；[`App.md`](./02-script/api/App.md)、[`UiSelector.md`](./02-script/api/UiSelector.md)、[`Gesture.md`](./02-script/api/Gesture.md)、[`System.md`](./02-script/api/System.md) |
| 自定义悬浮窗菜单 | [`floatWindow.md`](./01-ui/capabilities/floatWindow.md) + [`float-window.md`](./03-recipes/float-window.md)（用户没提则**不要**生成） |
| 调试 tasks | [`automation-loop.md`](./00-core/automation-loop.md) + [`ai-device-debug.md`](./00-core/ai-device-debug.md) + [`ai-http-api.md`](./02-script/ai-http-api.md) |

## 生成时必须遵守（细节见 constraints / donts）

- 页面成对：`pages/<id>/page.json` + `page.js`。`homePage` 目录可不再放入入口 `pages`。
- 入口必须写 `icon`，并**生成**该图片文件。入口文件名只能是 `deekeScript.json`。不要写 `hooks` / `groups`。
- **页面** JSON `action` 只允许：`navigate` / `redirect` / `switchTab` / `back` / `toast` / `save` / `openUrl`。禁止在页面 action 里跑脚本。按钮用 `onTap` → `page.js` 里 `Engines.executeScript('tasks/xxx.js')`（或 `permission.runScript`）。
- **悬浮窗** `menus[].action` 是另一套（`stop` / `hide` / `start` / `executeScript` 由框架处理）；自定义 `onTap` 项须与 `FloatWindow.on` **同一轮**生成。默认不写 `floatWindow`。
- 停任务：菜单手动 → `FloatWindow.stopTask()` 或内置 `action:stop`；任务内自动 → `tasks/*.js` 里 `Engines.closeAll()`。未配 menus 时连点两次即可。
- 找节点：`UiSelector().text('发送').findOne()`；点击前一般先 `filter` 屏内。
- 页面等待用 `setTimeout`；任务等待用 `System.sleep`。不要在 `page.js` 里 `System.sleep` 堵 UI。
- 切 App 后台后的提示用 `FloatDialogs`；页面短提示用 `this.toast`；任务前台短提示可用 `System.toast`。
- Rhino 1.8：`function` / `var` / `let`。禁止箭头、`async/await`、`?.`、`??`、`import`/`export`。
- `require` 优先 `./`、`../`；`Engines.executeScript` 路径相对**项目根**。
- 颜色宽高等只写在 `style`；可调节数值用 `slider`，不用 `progress`。
- 写或改 `tasks/*.js` / 工程文件后：按 [`automation-loop.md`](./00-core/automation-loop.md) 片段验证再整体跑；`write` 同步后再 `run` / `run-file`；执行前若用过悬浮弹窗先 `FloatDialogs.closeAll()`。

## 输出形态

用户没指定目录时，按 [`scaffold.md`](./03-recipes/scaffold.md) 列文件再给出每个文件的完整内容。需要权限时把 [`snippets/common-permission.js`](./02-script/snippets/common-permission.js) 复制为 `common/permission.js`。

标识符、`type`、API、字段名保持英文；注释和界面文案用中文。
