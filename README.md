# DeekeScript Pro — AI 生成规格

本仓库供 **AI** 读取，用于生成可运行的 DeekeScript Pro 工程。

入口：先读 [`AGENTS.md`](./AGENTS.md)，再按 [`INDEX.md`](./INDEX.md) 打开本任务需要的篇。

## 产物

- 界面：`deekeScript.json` + `pages/*/page.json` + `pages/*/page.js`
- 自动化：`tasks/*.js`、权限等公共模块

## 目录

| 路径 | 用途 |
|------|------|
| [`AGENTS.md`](./AGENTS.md) | 生成契约：先读 |
| [`INDEX.md`](./INDEX.md) | 按任务选篇 |
| [`00-core/`](./00-core/) | 心智模型、硬约束、Rhino、上下文边界；写 tasks 时读 automation-loop + ai-device-debug |
| [`01-ui/`](./01-ui/) | 界面 JSON / Page JS / 组件 |
| [`02-script/`](./02-script/) | 任务脚本与运行时 API |
| [`03-recipes/`](./03-recipes/) | 端到端文件清单与可复制片段 |
| [`04-cheatsheets/`](./04-cheatsheets/) | 速查 |
| [`tools/`](./tools/) | 发现手机、调用 `/ai` |

## 冲突处理

本仓库与外部资料冲突时，**以本仓库为准**。只按本规格生成，不要套用其它自动化框架的写法。
