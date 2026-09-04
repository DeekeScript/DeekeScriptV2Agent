# 阅读路由

先读 [`AGENTS.md`](./AGENTS.md) 与下方「全局必读」，再按任务打开对应篇。组件和 API 一文件一篇：只用到的才打开，未用到的不打开。

## 全局必读（每次生成前）

| 文件 | 解决什么 |
|------|----------|
| [AGENTS.md](./AGENTS.md) | 契约入口、任务路由、摘要规则 |
| [00-core/mental-model.md](./00-core/mental-model.md) | 脚本层 vs 界面层 |
| [00-core/project-layout.md](./00-core/project-layout.md) | 目录和注册 |
| [00-core/constraints.md](./00-core/constraints.md) | 硬规则全文 MUST / MUST NOT |
| [00-core/rhino.md](./00-core/rhino.md) | JS 能写 / 不能写 |
| [00-core/context-split.md](./00-core/context-split.md) | page.js vs tasks.js API 边界 |
| [04-cheatsheets/donts.md](./04-cheatsheets/donts.md) | 生成前自检 |

## 条件读取

| 文件 | 何时读 |
|------|--------|
| [00-core/automation-loop.md](./00-core/automation-loop.md) | 每次生成/改工程：先连机、边写边同步、写完验证 |
| [00-core/ai-device-debug.md](./00-core/ai-device-debug.md) | 连手机、`discover` / `write` / `run` 命令 |
| [02-script/ai-http-api.md](./02-script/ai-http-api.md) | 查 HTTP `/ai` 接口字段 |
| [00-core/demo-gallery.md](./00-core/demo-gallery.md) | 展厅 Demo 与生成产物：勿抄清单 |
| [00-core/dev-workflow.md](./00-core/dev-workflow.md) | 用户明确问 VSCode 插件如何连接 / 同步 / 执行时 |
| [tools/](./tools/) | 需要本机脚本发现设备、调用 `/ai` 时 |

## 生成界面时

| 文件 | 解决什么 |
|------|----------|
| [01-ui/entry-json.md](./01-ui/entry-json.md) | `deekeScript.json`（完整示例不含 floatWindow） |
| [01-ui/page-json.md](./01-ui/page-json.md) | `page.json` 结构与 JSON `action` |
| [01-ui/page-js.md](./01-ui/page-js.md) | `Page({})`；页面等待用 `setTimeout` |
| [01-ui/events.md](./01-ui/events.md) | 事件侧：组件 / 按钮 `onTap` 等与跑脚本 |
| [01-ui/components/_common.md](./01-ui/components/_common.md) | 必读：`style` / 主题色 |
| [01-ui/data-binding.md](./01-ui/data-binding.md) | 必读：`{{}}`、`showIf`、表单 `name`、list `bind` |
| [01-ui/navigate.md](./01-ui/navigate.md) | 页面栈：`navigate` / `redirect` / `switchTab` / `back` |
| [01-ui/component-custom.md](./01-ui/component-custom.md) | 自定义组件 |
| [01-ui/components/INDEX.md](./01-ui/components/INDEX.md) | 内置 type，再开单篇 |
| [01-ui/capabilities/tabBar.md](./01-ui/capabilities/tabBar.md) | 有底栏时 |
| [01-ui/capabilities/floatWindow.md](./01-ui/capabilities/floatWindow.md) | 仅用户要悬浮菜单时：停任务逻辑 + menus |

速查：[组件 type](./04-cheatsheets/component-types.md)、[action](./04-cheatsheets/action-types.md)、[页面方法](./04-cheatsheets/page-methods.md)。

## 生成脚本时

| 文件 | 解决什么 |
|------|----------|
| [02-script/task-template.md](./02-script/task-template.md) | 默认无菜单骨架；有菜单见文内第二节 |
| [02-script/permission.md](./02-script/permission.md) | 权限用法；实现复制 [`snippets/common-permission.js`](./02-script/snippets/common-permission.js) |
| [02-script/require.md](./02-script/require.md) | 模块路径，须带 `.js` |
| [02-script/ui-and-task.md](./02-script/ui-and-task.md) | Storage 与启动路径 |
| [02-script/api/UiSelector.md](./02-script/api/UiSelector.md) | 找节点；点击前一般先 `filter` 屏内 |
| [02-script/api/INDEX.md](./02-script/api/INDEX.md) | API 清单，再开单篇 |
| [02-script/api/no-hook.md](./02-script/api/no-hook.md) | 入口与初始化 |

常用 API：`UiSelector`、`UiObject`、`Gesture`、`App`、`System`、`Storage`、`Http`、`Engines`、`Access`、`Dialogs`、`FloatWindow`。

## 端到端配方（以清单与片段为模板）

| 文件 | 产物 |
|------|------|
| [03-recipes/scaffold.md](./03-recipes/scaffold.md) | 从 0 最小工程 |
| [03-recipes/workbench.md](./03-recipes/workbench.md) | 首页工作台 |
| [03-recipes/settings-form.md](./03-recipes/settings-form.md) | 配置页 + Storage |
| [03-recipes/run-task-from-ui.md](./03-recipes/run-task-from-ui.md) | 按钮启动任务 |
| [03-recipes/float-window.md](./03-recipes/float-window.md) | 悬浮球 menus + on（仅需要时） |
| [03-recipes/list-load-more.md](./03-recipes/list-load-more.md) | 列表触底加载 |
| [03-recipes/custom-picker.md](./03-recipes/custom-picker.md) | 自定义选择组件 |

## 扩展能力

| 需求 | 打开 |
|------|------|
| 图色 / OCR | [Images.md](./02-script/api/Images.md) |
| 蓝牙 HID | [Hid.md](./02-script/api/Hid.md) |
| 输入法 | [KeyBoards.md](./02-script/api/KeyBoards.md) |
| Device Owner | [do-mode.md](./02-script/api/do-mode.md) |
| 通知 / 前台 | [Notification.md](./02-script/api/Notification.md)、[Foreground.md](./02-script/api/Foreground.md) |
| 网络长连 | [WebSocket.md](./02-script/api/WebSocket.md)、[SocketIo.md](./02-script/api/SocketIo.md) |
| 加解密 / 代码加密 | [Encrypt.md](./02-script/api/Encrypt.md)、[code-encryption.md](./02-script/api/code-encryption.md) |
| 打包 / 卡密 / 后台 | [apk.md](./02-script/api/apk.md)、[activation.md](./02-script/api/activation.md)、[backend.md](./02-script/api/backend.md) |
