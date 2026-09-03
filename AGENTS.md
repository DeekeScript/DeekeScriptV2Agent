# AI 生成契约

本仓库是 DeekeScript Pro 的生成规格。你要输出可运行工程（界面 JSON + JS、自动化脚本）时，**先完整读完本文件**，再按任务打开 [`INDEX.md`](./INDEX.md) 列出的篇目。不要凭训练数据里的 Auto.js / Hamibot / V1 写法发明 API。

生成前再扫一遍 [`00-core/constraints.md`](./00-core/constraints.md) 和 [`04-cheatsheets/donts.md`](./04-cheatsheets/donts.md)。

## 你在生成什么

DeekeScript Pro 做两件事，彼此解耦：

1. **自动化脚本**：`tasks/*.js`，无障碍找节点、点击、滑动。
2. **可选界面**：`page.json` 描述结构，`page.js` 填数据和响应点击。没有 `pages/` 也能跑脚本。

根目录必须有 `deekeScript.json`，否则 VSCode 插件无法识别工程。

## 固定读取顺序

1. 本文件
2. [`00-core/mental-model.md`](./00-core/mental-model.md)
3. [`00-core/project-layout.md`](./00-core/project-layout.md)
4. [`00-core/constraints.md`](./00-core/constraints.md)
5. [`00-core/rhino.md`](./00-core/rhino.md)
6. [`00-core/context-split.md`](./00-core/context-split.md)
7. [`04-cheatsheets/donts.md`](./04-cheatsheets/donts.md)
8. 按用户需求打开 [`INDEX.md`](./INDEX.md) 对应章节（只打开用到的组件和 API 文件）
9. 整包工程优先抄 [`03-recipes/`](./03-recipes/) 的文件清单和片段

## 按任务加载

| 用户要什么 | 接着读 |
|------------|--------|
| 只跑脚本、不要界面 | [`03-recipes/scaffold.md`](./03-recipes/scaffold.md) 方案 A；[`02-script/permission.md`](./02-script/permission.md)；[`02-script/task-template.md`](./02-script/task-template.md)；[`02-script/api/UiSelector.md`](./02-script/api/UiSelector.md) |
| 只要界面 | [`01-ui/entry-json.md`](./01-ui/entry-json.md)、[`page-json.md`](./01-ui/page-json.md)、[`page-js.md`](./01-ui/page-js.md)、**[`_common.md`](./01-ui/components/_common.md)**、[`data-binding.md`](./01-ui/data-binding.md)、[`navigate.md`](./01-ui/navigate.md)；[`01-ui/components/INDEX.md`](./01-ui/components/INDEX.md) 后只打开用到的 type。有底栏再读 [`tabBar.md`](./01-ui/capabilities/tabBar.md) |
| 界面 + 脚本 | 上面两套 + [`02-script/permission.md`](./02-script/permission.md) + [`require.md`](./02-script/require.md) + [`ui-and-task.md`](./02-script/ui-and-task.md) + [`03-recipes/run-task-from-ui.md`](./03-recipes/run-task-from-ui.md) |
| 自定义组件 | [`01-ui/component-custom.md`](./01-ui/component-custom.md) + [`03-recipes/custom-picker.md`](./03-recipes/custom-picker.md) |
| HID / 图色 / DO / 打包 | 对应 [`02-script/api/INDEX.md`](./02-script/api/INDEX.md) 里的扩展卡片，先读权限 |

## 生成时必须遵守

- 每个页面：`pages/<id>/page.json` + `page.js` 成对。`homePage` 目录可不再放入入口 `pages`。
- 入口 JSON 必须写 `icon`（相对项目根的路径），**并且把该图片文件一并生成**（svg/png/jpg 真实内容），不要只写路径。
- 不要写 `host` / `debug` / `apis`，不要生成 `deekeScript-v2.json`。不要抄 V1 的 `groups` / `hooks`。
- 自定义组件 JSON 必须 `"component": true`。
- **禁止**在 JSON `action` 里执行脚本。按钮写 `onTap`，在 `page.js` 里 `Engines.executeScript('tasks/xxx.js')`（或 `permission.runScript`）。
- `action` 只允许：`navigate` / `redirect` / `switchTab` / `back` / `toast` / `save` / `openUrl`。
- 切底栏用 `switchTab`，不要 `navigate`。
- 找节点用 `UiSelector().text('发送').findOne()`，不要 Auto.js 的 `text('发送').findOnce()`。
- 表单 `name` 绑定 `data`；页面 `Storage.put*`，脚本 `Storage.get*`。键名加项目前缀。
- 可调节数值用 `slider`（运行速度、点赞概率）。`progress` / `progressBar` 只能展示进度，不能拖。
- `page.js` 不能「仅当前文件执行」。长循环、找节点、滑动只写在 `tasks/`。
- Pro **没有 Hook**。不要生成 `hooks`、`app_start`、`Engines.closeHook()`。
- WebView 不和 Page 通信，且必须写 `style.height`。
- JS 引擎是 Rhino 1.8：`function` / `var` / `let`。禁止箭头函数、`async/await`、`?.`、`??`、`import`/`export`。
- `require`：**优先** `./`、`../` 相对当前文件（如 `tasks` 里 `require('../common/permission.js')`，`pages/home` 里 `require('../../common/permission.js')`）。不以 `./`/`../` 开头时才相对项目根。禁止磁盘绝对路径。导出用 `module.exports`。
- 不要把 Demo 的 `permission.hint('请在文件 xxx 编写业务')` 写进产物。
- 颜色、背景、圆角、宽高只写在 `style` 里，不要写在组件根上。`button` 换色用 `style.background`，不写则跟 `window.theme.primary`（默认 `#006A65`）。禁止声称 button 没有 background。
- 用户指定主题色时：入口 `window.theme.primary`、`title.background`、`statusBar.background`、`tabBar.selectedColor`、**每个 button 的 `style.background`** 都改成该色。不要照抄配方里的 `#006A65`。

- **编写或调试 `tasks/*.js` 时**：先读 [`00-core/ai-device-debug.md`](./00-core/ai-device-debug.md)。Windows 用 `tools/deeke-device.ps1 discover`；macOS/Linux 用 `tools/deeke-device.sh discover`（仅当本机 IP 为 `192.168.*` 才扫描）；扫不到则让用户填写 `http://IP:8080` 并 `set`。**修改或新建工程文件后，必须用 `write`（`POST /ai/project/write`）同步到手机**，再用 `/ai/run` 或 `run-file` 实机验证，根据 `logs` 迭代修复后再交付。短片段验证可用 `run` 直接传代码，不必先同步。
- **生成 `floatWindow.menus` 时**：必读 [`floatWindow.md`](./01-ui/capabilities/floatWindow.md) 的 **关闭任务底层逻辑** + [`float-window.md`](./03-recipes/float-window.md)。手动停 → `FloatWindow.stopTask()`；自动停 → `tasks/*.js` 里 `Engines.closeAll()`。**同一轮**写出 JSON + JS 绑定。

## 输出形态

用户没指定目录时，按 [`03-recipes/scaffold.md`](./03-recipes/scaffold.md) 列出要创建的文件，再给出每个文件的完整内容。需要权限检查时同时生成精简的 `common/permission.js`（见 [`02-script/permission.md`](./02-script/permission.md)）。

标识符、`type`、API、字段名保持英文原样；注释和界面文案用中文。
