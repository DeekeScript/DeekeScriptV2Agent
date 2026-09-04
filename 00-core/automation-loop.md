# 编写与调试闭环

生成或修改**任何可交付工程**（界面、`tasks/*.js`、公共模块）时按本篇执行。设备命令见 [`ai-device-debug.md`](./ai-device-debug.md)；HTTP 见 [`ai-http-api.md`](../02-script/ai-http-api.md)。任务骨架见 [`task-template.md`](../02-script/task-template.md)。

目标：先连机 → 边写边同步 → 写完主动验证。禁止「只生成代码、不验证」就结束。

## 强制流程

```
1. 编写前：连接设备 + status（见 ai-device-debug）
2. 确认目标：界面要什么 / 哪个 App、关键步骤、成功失败与停条件
3. 需要时 snapshot：看清目标节点再写查找条件
4. 落盘（入口、页面、tasks、common…）
5. 每改一批文件：主动 write 同步到手机（不要攒到最后）
6. 验证：界面可预览/点测；任务先 run 片段，再 write → run-file → 读 logs
7. 失败则修代码 → 再 write → 再验；通过后交付
```

连不上设备时：仍按契约生成完整可运行代码，并明确列出用户须开启的权限与地址；**不得假装已实机验证**。

## 丝滑约束（生成与调试时必守）

| # | 规则 |
|---|------|
| 1 | **编写前先连机**。未连机不得声称已实机验证。 |
| 2 | **边写边 `write`**。改入口 / 页面 / `tasks` / `common` 后主动同步；禁止只改电脑文件、手机仍是旧版。 |
| 3 | **写完主动验证**。界面与脚本都要验；任务禁止一上来整段盲跑，先片段后整体。 |
| 4 | 找节点用 `UiSelector().…`；点击前一般先 `filter` 屏内。 |
| 5 | 每次 `run` / `run-file` 前：若用过悬浮弹窗，先 `FloatDialogs.closeAll()`。 |
| 6 | 短验证可用 `run` 传代码字符串（可不先 `write`）；`run-file` 或交付执行前必须已 `write`。 |
| 7 | `while` / 重试必须有上限（次数或 `retryCount`），禁止无递增的 `continue`。 |
| 7b | **刷流 / 列表**：以内容条为进度；单条失败（弹窗、读不到字段）默认 **skip 并前进**，禁止对同一条反复进主页。见 [`skip-on-item-failure.md`](../02-script/pitfalls/skip-on-item-failure.md)。 |
| 8 | 步骤之间用 `System.sleep`；关键步骤打 `console.log`，便于读 `logs`。 |
| 9 | 已切到第三方 App 时用 `FloatDialogs` 提示，不用 `Dialogs` / 指望前台 toast。目标 App 业务弹窗另用文案按钮 dismiss，勿与 `FloatDialogs` 混用。 |
| 10 | 自动结束：在 `tasks/*.js` 里 `Engines.closeAll()`。菜单停用 `FloatWindow.stopTask()`（用户要菜单时才写）。 |
| 11 | 同一失败模式连续修 **3 轮**仍不过 → 进入下方「请求用户协助」，不要空转猜测。 |

## 片段验证清单（tasks）

按顺序用 `run` 短代码验证，通过一项再下一项：

1. **权限**：`Access.isAccessibilityServiceEnabled()` / 悬浮窗等为 true  
2. **在目标 App / 目标页**：用**互斥特征**判断（不要用评论列表也会出现的通用 id）。见 [`page-state.md`](../02-script/pitfalls/page-state.md)  
3. **找得到节点**：打印 `text` / `desc` / `bounds`；确认在屏内（`filter`）  
4. **点得动 / 输得进**：  
   - 普通按钮：`click` 后看界面变化  
   - **输入框 / 评论**：`click` 占位框 → `sleep` → **重新 find**（优先 `editable(true).focused(true)`）→ `setText` / 剪贴板 → **再读 `text` 校验**。禁止对 click 前的变量直接写入。见 [`stale-node-after-click.md`](../02-script/pitfalls/stale-node-after-click.md)、配方 [`comment-input.md`](../03-recipes/comment-input.md)  
5. **再拼循环**：带上限的 `while`；刷流任务须验证「失败一条会划走、不会重进同一主页」，再 `write` + `run-file`。见 [`skip-on-item-failure.md`](../02-script/pitfalls/skip-on-item-failure.md)

## 请求用户协助（必要）

下列情况**停止盲目改代码**，向用户要信息或操作。请求时写清：已尝试了什么、卡在哪一步、需要用户做什么。

| 情况 | 向用户要什么 |
|------|----------------|
| 扫不到设备 / 非 `192.168.*` 跳过扫描 | 手机 `http://IP:8080`；确认已开「节点查看」 |
| `status` 权限为 false | 在手机 App 打开对应开关（无障碍 / 悬浮窗 / 图色等） |
| 多台设备 | 选一台 `baseUrl` |
| 需登录 / 验证码 / 生物识别 / 扫码 | 用户在手机上完成；完成后说「继续」 |
| 节点歧义或界面与假设不符 | 当前界面描述，或允许你 `snapshot`；必要时指出要点哪个文案 |
| 业务规则不清（次数、间隔、停条件） | 具体数值与边界 |
| 连续 3 轮实机仍失败 | 用户确认当前屏幕状态；或提供正确节点特征（text/id/desc） |
| 高风险操作（批量删除、发消息、支付相关） | 明确口头确认后再生成/执行 |

## 不要打扰用户

以下情况自己解决，不要中断：

- 已有 `.deeke-device.local.json` 且 `status` 正常  
- `logs` / `snapshot` 已足够定位（选错节点、漏 `filter`、漏 `sleep`、漏 `write`）  
- 契约内 API / 路径 / Rhino 语法错误  

## 交付前自检

- [ ] 编写前已连机（或已声明无法连机并列出用户侧步骤）  
- [ ] 过程中改动已主动 `write`  
- [ ] 关键逻辑 / 界面已在真机验证（或已声明未验证原因）  
- [ ] `logs` 无未处理错误；循环有上限  
- [ ] 刷流 / 进主页类任务：单条失败会 skip 前进，无「同一条死磕」  
- [ ] 多对象 / 多功能时已按 [`code-org.md`](../02-script/code-org.md) 拆模块，未在各 task 里复制底层操作  
- [ ] 若曾请求用户协助：用户完成的步骤已记入最终说明  

## 相关

- 连接与命令：[`ai-device-debug.md`](./ai-device-debug.md)  
- 运行边界：[`dev-workflow.md`](./dev-workflow.md)  
- 找节点：[`UiSelector.md`](../02-script/api/UiSelector.md)  
- HTTP：[`ai-http-api.md`](../02-script/ai-http-api.md)
