# DeekeScript V2 Agent 文档

这份文档给 **AI** 读。读完后应能生成可运行的 DeekeScript V2 工程：

- 界面：`deekeScript-v2.json` + `pages/*/page.json` + `pages/*/page.js`
- 自动化：`tasks/*.js` 以及权限、悬浮球等公共模块

不是给人浏览的官网。人读文档见 [doc.deeke.cn](https://doc.deeke.cn)。

## 怎么用

1. 把本仓库放进 AI 的工作区或 RAG 语料。
2. AI **必须先读** [`AGENTS.md`](./AGENTS.md)，再按 [`INDEX.md`](./INDEX.md) 按需打开其它篇。
3. 生成代码前对照 [`00-core/constraints.md`](./00-core/constraints.md) 和 [`04-cheatsheets/donts.md`](./04-cheatsheets/donts.md)。
4. 整包工程优先抄 [`03-recipes/`](./03-recipes/) 的文件清单，不要从 Auto.js 或 V1 文档迁移写法。

## 目录

| 目录 | 何时读 |
|------|--------|
| [`AGENTS.md`](./AGENTS.md) | 永远先读：生成规则 |
| [`INDEX.md`](./INDEX.md) | 按任务选篇 |
| [`00-core/`](./00-core/) | 心智模型、工程结构、硬约束、Rhino、上下文边界 |
| [`01-ui/`](./01-ui/) | 生成界面（JSON + Page JS + 组件） |
| [`02-script/`](./02-script/) | 生成自动化脚本与运行时 API |
| [`03-recipes/`](./03-recipes/) | 端到端最小配方，优先抄结构 |
| [`04-cheatsheets/`](./04-cheatsheets/) | 极短速查 |

## 来源

内容整理自官方 V2 文档、共享自动化 API 文档，以及 [deekeScriptV2Demo](https://github.com/DeekeScript/deekeScriptV2Demo) 的真实约定。
