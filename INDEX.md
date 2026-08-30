# 阅读路由

生成代码时**不要整库灌进上下文**。先读 [`AGENTS.md`](./AGENTS.md) 和 [`00-core/`](./00-core/)，再按本表打开对应篇。组件和 API 都是一文件一篇，只用到的才打开。

## 必读

| 文件 | 解决什么 |
|------|----------|
| [AGENTS.md](./AGENTS.md) | 生成契约、读取顺序、硬禁止 |
| [00-core/mental-model.md](./00-core/mental-model.md) | 脚本层 vs 界面层 |
| [00-core/project-layout.md](./00-core/project-layout.md) | 目录和注册 |
| [00-core/constraints.md](./00-core/constraints.md) | MUST / MUST NOT |
| [00-core/rhino.md](./00-core/rhino.md) | JS 能写 / 不能写 |
| [00-core/context-split.md](./00-core/context-split.md) | page.js vs tasks.js 的 API 边界 |
| [00-core/dev-workflow.md](./00-core/dev-workflow.md) | 同步、执行、刷新 |
| [04-cheatsheets/donts.md](./04-cheatsheets/donts.md) | 生成前自检 |

## 生成界面时

| 文件 | 解决什么 |
|------|----------|
| [01-ui/entry-json.md](./01-ui/entry-json.md) | `deekeScript.json` |
| [01-ui/page-json.md](./01-ui/page-json.md) | `page.json` 结构 |
| [01-ui/page-js.md](./01-ui/page-js.md) | `Page({})` 生命周期、事件、方法 |
| [01-ui/data-binding.md](./01-ui/data-binding.md) | `{{}}`、`showIf`、`name`、`bind` |
| [01-ui/navigate.md](./01-ui/navigate.md) | `action` 与 `this.navigate` 等 |
| [01-ui/component-custom.md](./01-ui/component-custom.md) | 自定义组件 |
| [01-ui/components/INDEX.md](./01-ui/components/INDEX.md) | 内置 type 清单，再打开单篇。**slider 可拖，progress 只读** |
| [01-ui/components/_common.md](./01-ui/components/_common.md) | 通用字段和 Style |
| [01-ui/capabilities/](./01-ui/capabilities/) | 下拉刷新、底栏、悬浮球、弹层 |

速查：[组件 type](./04-cheatsheets/component-types.md)、[action](./04-cheatsheets/action-types.md)、[页面方法](./04-cheatsheets/page-methods.md)。

## 生成脚本时

| 文件 | 解决什么 |
|------|----------|
| [02-script/task-template.md](./02-script/task-template.md) | 任务骨架 |
| [02-script/permission.md](./02-script/permission.md) | 权限检查与 `runScript` |
| [02-script/ui-and-task.md](./02-script/ui-and-task.md) | Storage 与启动路径 |
| [02-script/require.md](./02-script/require.md) | 模块路径 |
| [02-script/api/INDEX.md](./02-script/api/INDEX.md) | 运行时 API 清单，再打开单篇 |
| [02-script/api/no-hook.md](./02-script/api/no-hook.md) | Pro 无 Hook |

常用 API：`UiSelector`、`UiObject`、`Gesture`、`App`、`System`、`Storage`、`Http`、`Engines`、`Access`、`Dialogs`、`FloatWindow`。

## 端到端配方（优先抄结构）

| 文件 | 产物 |
|------|------|
| [03-recipes/scaffold.md](./03-recipes/scaffold.md) | 从 0 最小工程（无 UI / 一页界面） |
| [03-recipes/workbench.md](./03-recipes/workbench.md) | 首页工作台 |
| [03-recipes/settings-form.md](./03-recipes/settings-form.md) | 配置页 + Storage |
| [03-recipes/run-task-from-ui.md](./03-recipes/run-task-from-ui.md) | 按钮启动任务 |
| [03-recipes/list-load-more.md](./03-recipes/list-load-more.md) | 列表触底加载 |
| [03-recipes/custom-picker.md](./03-recipes/custom-picker.md) | 自定义选择组件 |

## 扩展能力（按需）

| 需求 | 打开 |
|------|------|
| 图色 / OCR | [02-script/api/Images.md](./02-script/api/Images.md) |
| 蓝牙 HID | [02-script/api/Hid.md](./02-script/api/Hid.md) |
| 输入法 | [02-script/api/KeyBoards.md](./02-script/api/KeyBoards.md) |
| Device Owner | [02-script/api/do-mode.md](./02-script/api/do-mode.md) |
| 通知 / 前台服务 | [Notification.md](./02-script/api/Notification.md)、[Foreground.md](./02-script/api/Foreground.md) |
| 网络长连 | [WebSocket.md](./02-script/api/WebSocket.md)、[SocketIo.md](./02-script/api/SocketIo.md) |
| 加解密 / 代码加密 | [Encrypt.md](./02-script/api/Encrypt.md)、[code-encryption.md](./02-script/api/code-encryption.md) |
| 打包 / 卡密 / 后台 | [apk.md](./02-script/api/apk.md)、[activation.md](./02-script/api/activation.md)、[backend.md](./02-script/api/backend.md) |
