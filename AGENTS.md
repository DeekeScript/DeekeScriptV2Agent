# AI 生成契约

本仓库是 DeekeScript Pro 的生成规格。输出可运行工程前**先读完本文件**，再按 [`INDEX.md`](./INDEX.md) 只打开本任务需要的篇。禁止凭其它自动化框架的训练数据发明 API。

硬规则只在一处：[`00-core/constraints.md`](./00-core/constraints.md)。界面组件坑（constraints 未列的）见 [`04-cheatsheets/donts.md`](./04-cheatsheets/donts.md)。

## 设备（必守）

细节只读 [`device.md`](./00-core/device.md)：

1. **编写前**连手机（`discover` / `set` + `status`）。连不上再写代码时，须声明尚未实机验证。
2. **改完就 `write`**，不要攒到最后。
3. **写完必须自己验证再交付**。禁止让用户「自己去点开始」。

有 `tasks/*.js` 且 `status` 正常时：在回复里贴出**目标 App / 目标页**关键节点的 `run` logs（`text` / `desc` / `bounds`）之前，**任务未完成**。只 `write`、只测 Storage/权限、只打开本工程 UI、以「高风险」跳过找节点，一律不算已调试。用户需求本身就是搜索/点赞/评论/刷流时，启动目标 App 做片段验证**不必再问**。

## 你在生成什么

1. **自动化**：`tasks/*.js`
2. **可选界面**：`page.json` + `page.js`（没有 `pages/` 也能跑脚本）
3. 入口与硬规则：[`constraints.md`](./00-core/constraints.md)、[`entry-json.md`](./01-ui/entry-json.md)

## 固定读取顺序

1. 本文件
2. [`00-core/constraints.md`](./00-core/constraints.md)
3. [`00-core/runtime.md`](./00-core/runtime.md)（两层 + Rhino + API 边界）
4. [`00-core/project-layout.md`](./00-core/project-layout.md)
5. 生成/改工程：[`00-core/device.md`](./00-core/device.md)
6. 按 [`INDEX.md`](./INDEX.md) 打开本任务需要的组件 / API / 配方（未用到的不打开）

用户明确问 VSCode 插件操作时，再打开 [`dev-workflow.md`](./00-core/dev-workflow.md)。

任务路由表只维护在 INDEX，不要在本文件复制一份。

## 生成时（摘要，细节以 constraints 为准）

- 页面成对；入口必须 `icon` 且生成图片文件。
- 默认不写 `floatWindow`。有 menus 则 `onTap` 与 `FloatWindow.on` 同一轮；手动停 `FloatWindow.stopTask()`，任务内自动停 `Engines.closeAll()`。
- 找节点：`UiSelector().text('发送').findOne()`；点击前一般先 `filter` 屏内。
- 输入：click 后**重新 find** 再 `setText`。刷流：单条失败 skip 前进。
- 表单 `name` 页内唯一；Storage 键 `项目.模块.字段`。启停用 `switch`；列表次要按钮 `sm`；底栏已有的页不要在首页再放跳转。
- 页面 `setTimeout`，任务 `System.sleep`。底栏页 Storage 数据必须 `onShow` 刷新。
- 禁止 `currentPackage()` 判断目标 App；用户要求回本 App 时 `App.backApp()`。
- 业务代码：对象 + 方法简写。`require` 优先 `./` `../`；`executeScript` 相对项目根。
- 颜色宽高只写 `style`；可调节数值用 `slider`。

整包工程以 [`03-recipes/`](./03-recipes/) 的文件清单与片段为模板。需要权限时把 [`snippets/common-permission.js`](./02-script/snippets/common-permission.js) 复制为 `common/permission.js`。

标识符、`type`、API、字段名保持英文；注释和界面文案用中文。
