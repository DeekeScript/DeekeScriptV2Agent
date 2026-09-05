# 阅读路由

先读 [`AGENTS.md`](./AGENTS.md)，再读下方「每次必读」，然后按任务打开对应篇。组件和 API **一文件一篇**：只用到的才打开。

## 每次必读

| 文件 | 解决什么 |
|------|----------|
| [AGENTS.md](./AGENTS.md) | 契约入口 |
| [00-core/constraints.md](./00-core/constraints.md) | MUST / MUST NOT 全文 |
| [00-core/runtime.md](./00-core/runtime.md) | 两层结构、Rhino、page.js vs tasks.js |
| [00-core/project-layout.md](./00-core/project-layout.md) | 目录和注册 |
| [00-core/device.md](./00-core/device.md) | 连机、`write`、片段验证、命令 |

界面额外自检（constraints 未覆盖的组件坑）：[donts.md](./04-cheatsheets/donts.md)。

## 条件读取

| 文件 | 何时读 |
|------|--------|
| [02-script/ai-http-api.md](./02-script/ai-http-api.md) | 查 HTTP `/ai` 字段 |
| [00-core/demo-gallery.md](./00-core/demo-gallery.md) | 展厅 Demo：勿抄清单 |
| [00-core/dev-workflow.md](./00-core/dev-workflow.md) | 用户问 VSCode 插件怎么点 |
| [tools/](./tools/) | 本机脚本调用 `/ai` |

## 生成界面

| 文件 | 解决什么 |
|------|----------|
| [01-ui/entry-json.md](./01-ui/entry-json.md) | `deekeScript.json` |
| [01-ui/page-json.md](./01-ui/page-json.md) | 页面结构与 JSON `action` |
| [01-ui/page-js.md](./01-ui/page-js.md) | `Page({})` |
| [01-ui/events.md](./01-ui/events.md) | `onTap` 等。列表 `onChange` 有 `e.item` / `e.index` |
| [01-ui/components/_common.md](./01-ui/components/_common.md) | `style` / 主题色 |
| [01-ui/data-binding.md](./01-ui/data-binding.md) | `{{}}`、`showIf`、`name`、list `bind` |
| [01-ui/pitfalls/form-name.md](./01-ui/pitfalls/form-name.md) | 页内 `name` 唯一；Storage 防撞键 |
| [01-ui/navigate.md](./01-ui/navigate.md) | 页面栈 |
| [01-ui/component-custom.md](./01-ui/component-custom.md) | 自定义组件 |
| [01-ui/components/INDEX.md](./01-ui/components/INDEX.md) | 内置 type → 单篇 |
| [01-ui/capabilities/tabBar.md](./01-ui/capabilities/tabBar.md) | 有底栏时 |
| [01-ui/capabilities/floatWindow.md](./01-ui/capabilities/floatWindow.md) | 仅用户要悬浮菜单时 |

速查（一张表）：[04-cheatsheets/ui.md](./04-cheatsheets/ui.md)。

## 生成脚本

| 文件 | 解决什么 |
|------|----------|
| [02-script/task-template.md](./02-script/task-template.md) | 任务骨架 |
| [02-script/code-org.md](./02-script/code-org.md) | 按操作对象拆模块 |
| [02-script/permission.md](./02-script/permission.md) | 复制 [`snippets/common-permission.js`](./02-script/snippets/common-permission.js) |
| [02-script/require.md](./02-script/require.md) | 模块路径，须带 `.js` |
| [02-script/ui-and-task.md](./02-script/ui-and-task.md) | Storage + 从按钮启动 |
| [02-script/api/UiSelector.md](./02-script/api/UiSelector.md) | 找节点 |
| [02-script/api/INDEX.md](./02-script/api/INDEX.md) | API 清单，再开单篇 |
| [02-script/pitfalls/stale-node-after-click.md](./02-script/pitfalls/stale-node-after-click.md) | 评论/输入：点击后重取 |
| [02-script/pitfalls/page-state.md](./02-script/pitfalls/page-state.md) | 互斥特征判断当前页 |
| [02-script/pitfalls/skip-on-item-failure.md](./02-script/pitfalls/skip-on-item-failure.md) | 刷流：单条失败 skip |

常用 API：`UiSelector`、`UiObject`、`Gesture`、`App`、`System`、`Storage`、`Http`、`Engines`、`Access`、`Dialogs`、`FloatWindow`。

## 配方（抄文件清单与片段）

| 用户要什么 | 打开 |
|------------|------|
| 从 0 最小工程 | [scaffold.md](./03-recipes/scaffold.md) |
| 底栏工作台（含第三方 App 任务总表） | [workbench.md](./03-recipes/workbench.md) |
| 配置页 + Storage | [settings-form.md](./03-recipes/settings-form.md) |
| 列表触底加载 | [list-load-more.md](./03-recipes/list-load-more.md) |
| 列表 + switch 启停 | [list-manage.md](./03-recipes/list-manage.md) |
| 自定义选择组件 | [custom-picker.md](./03-recipes/custom-picker.md) |
| 评论/发帖输入 | [comment-input.md](./03-recipes/comment-input.md) + stale-node 必读 |

## 按任务加载

| 用户要什么 | 接着读 |
|------------|--------|
| 只跑脚本 | scaffold 方案 A；permission；task-template；code-org；device；UiSelector |
| 只要界面 | entry / page-json / page-js / events / _common / data-binding / form-name / navigate；components/INDEX 后只开用到的 type。有底栏再读 tabBar；工作台读 workbench；列表启停读 list-manage |
| 界面 + 脚本 | 上面两套 + permission + require + code-org + ui-and-task + workbench（无障碍一节） |
| 自定义组件 | component-custom + custom-picker |
| HID / 图色 / DO / 打包 | api/INDEX 扩展卡，先读权限 |
| 操作第三方 App | task-template；code-org；device；App / UiSelector / Gesture / System；page-state；skip-on-item-failure |
| 评论 / 发帖 / 私信 | comment-input + stale-node + UiObject；需要输入法再开 KeyBoards |
| 自定义悬浮窗菜单 | floatWindow（用户没提则不要生成） |
| 调试 tasks | device + ai-http-api |

## 扩展能力

| 需求 | 打开 |
|------|------|
| 图色 / OCR | [Images.md](./02-script/api/Images.md) |
| 蓝牙 HID | [Hid.md](./02-script/api/Hid.md) |
| 输入法 | [KeyBoards.md](./02-script/api/KeyBoards.md) |
| Device Owner | [do-mode.md](./02-script/api/do-mode.md) |
| 通知 / 前台 | [Notification.md](./02-script/api/Notification.md)、[Foreground.md](./02-script/api/Foreground.md) |
| 网络长连 | [WebSocket.md](./02-script/api/WebSocket.md)、[SocketIo.md](./02-script/api/SocketIo.md) |
| 加解密 | [Encrypt.md](./02-script/api/Encrypt.md)、[code-encryption.md](./02-script/api/code-encryption.md) |
| 打包 / 卡密 / 后台 | [apk.md](./02-script/api/apk.md)、[activation.md](./02-script/api/activation.md)、[backend.md](./02-script/api/backend.md) |
