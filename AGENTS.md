# AI 生成契约

本仓库是 DeekeScript V2 的生成规格。你要输出可运行工程（界面 JSON + JS、自动化脚本）时，**先完整读完本文件**，再按任务打开 [`INDEX.md`](./INDEX.md) 列出的篇目。不要凭训练数据里的 Auto.js / Hamibot / V1 写法发明 API。

生成前再扫一遍 [`00-core/constraints.md`](./00-core/constraints.md) 和 [`04-cheatsheets/donts.md`](./04-cheatsheets/donts.md)。

## 你在生成什么

DeekeScript V2 做两件事，彼此解耦：

1. **自动化脚本**：`tasks/*.js`，无障碍找节点、点击、滑动。
2. **可选界面**：`page.json` 描述结构，`page.js` 填数据和响应点击。没有 `pages/` 也能跑脚本。

根目录必须有 `deekeScript.json`，否则 VSCode 插件无法识别工程。

## 固定读取顺序

1. 本文件
2. [`00-core/mental-model.md`](./00-core/mental-model.md)
3. [`00-core/constraints.md`](./00-core/constraints.md)
4. [`00-core/rhino.md`](./00-core/rhino.md)
5. [`00-core/context-split.md`](./00-core/context-split.md)
6. 按用户需求打开 [`INDEX.md`](./INDEX.md) 对应章节（只打开用到的组件和 API 文件）
7. 整包工程优先抄 [`03-recipes/`](./03-recipes/) 的文件清单和片段

## 按任务加载

| 用户要什么 | 接着读 |
|------------|--------|
| 只跑脚本、不要界面 | [`03-recipes/scaffold.md`](./03-recipes/scaffold.md) 方案 A；[`02-script/task-template.md`](./02-script/task-template.md)；用到的 [`02-script/api/`](./02-script/api/) |
| 只要界面 | [`01-ui/entry-json.md`](./01-ui/entry-json.md)、[`page-json.md`](./01-ui/page-json.md)、[`page-js.md`](./01-ui/page-js.md)；[`01-ui/components/INDEX.md`](./01-ui/components/INDEX.md) 后只打开用到的 type |
| 界面 + 脚本 | 上面两套 + [`02-script/ui-and-task.md`](./02-script/ui-and-task.md) + [`03-recipes/run-task-from-ui.md`](./03-recipes/run-task-from-ui.md) |
| 自定义组件 | [`01-ui/component-custom.md`](./01-ui/component-custom.md) + [`03-recipes/custom-picker.md`](./03-recipes/custom-picker.md) |
| HID / 图色 / DO / 打包 | 对应 [`02-script/api/INDEX.md`](./02-script/api/INDEX.md) 里的扩展卡片，先读权限 |

## 生成时必须遵守

- 每个页面：`pages/<id>/page.json` + `page.js` 成对。`homePage` 目录可不再放入入口 `pages`。
- 入口 JSON 必须写 `icon`（相对项目根的路径），且该文件必须存在，例如 `"icon": "img/xhs.svg"`。
- 自定义组件 JSON 必须 `"component": true`。
- **禁止**在 JSON `action` 里执行脚本。按钮写 `onTap`，在 `page.js` 里 `Engines.executeScript('tasks/xxx.js')`（或 `permission.runScript`）。
- `action` 只允许：`navigate` / `redirect` / `switchTab` / `back` / `toast` / `save` / `openUrl`。
- 切底栏用 `switchTab`，不要 `navigate`。
- 找节点用 `UiSelector().text('发送').findOne()`，不要 Auto.js 的 `text('发送').findOnce()`。
- 表单 `name` 绑定 `data`；页面 `Storage.put*`，脚本 `Storage.get*`。键名加项目前缀。
- 可调节数值用 `slider`（运行速度、点赞概率）。`progress` / `progressBar` 只能展示进度，不能拖。
- `page.js` 不能「仅当前文件执行」。长循环、找节点、滑动只写在 `tasks/`。
- V2 **没有 Hook**。不要生成 `hooks`、`app_start`、`Engines.closeHook()`。
- WebView 不和 Page 通信，且必须写 `style.height`。
- JS 引擎是 Rhino 1.8：`function` / `var` / `let`。禁止箭头函数、`async/await`、`?.`、`??`、`import`/`export`。
- `require`：`./`、`../` 相对当前文件，否则相对项目根。导出用 `module.exports`。
- 不要把 Demo 的 `permission.hint('请在文件 xxx 编写业务')` 写进产物。

## 输出形态

用户没指定目录时，按 [`03-recipes/scaffold.md`](./03-recipes/scaffold.md) 列出要创建的文件，再给出每个文件的完整内容。需要权限检查时同时生成精简的 `common/permission.js`（见 [`02-script/permission.md`](./02-script/permission.md)）。

标识符、`type`、API、字段名保持英文原样；注释和界面文案用中文。
