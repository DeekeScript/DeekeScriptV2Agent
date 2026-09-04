# 自动化编写与调试闭环

编写或调试 `tasks/*.js` 时**必须**按本篇执行。设备连接与命令细节见 [`ai-device-debug.md`](./ai-device-debug.md)；HTTP 细节见 [`ai-http-api.md`](../02-script/ai-http-api.md)。骨架见 [`task-template.md`](../02-script/task-template.md)。

目标：先片段验证、再整体跑通，再交付。禁止「只生成长脚本、不验证」就结束。

## 强制流程

```
1. 确认目标：哪个 App、关键步骤、成功/失败条件、停条件
2. 连接设备 + status（见 ai-device-debug）
3. 需要时 snapshot：看清目标节点再写查找条件
4. 落盘骨架（permission + Storage + 有界循环）
5. 片段验证（run 短代码）：找节点 → 点击/输入 → 再拼循环
6. write 同步 → run-file 跑完整任务 → 读 logs
7. 失败则修代码 → 再 write → 再跑；通过后交付
```

连不上设备时：仍按契约生成完整可运行代码，并明确列出用户须开启的权限与地址；**不得假装已实机验证**。

## 丝滑约束（生成与调试时必守）

| # | 规则 |
|---|------|
| 1 | **先片段、后整体**。禁止一上来 `run-file` 整段盲跑。 |
| 2 | 找节点用 `UiSelector().…`；点击前一般先 `filter` 屏内。 |
| 3 | 每次 `run` / `run-file` 前：若用过悬浮弹窗，先 `FloatDialogs.closeAll()`。 |
| 4 | 改文件后要交付或 `run-file`：必须先 `write` 同步到手机。短验证可用 `run` 传代码字符串。 |
| 5 | `while` / 重试必须有上限（次数或 `retryCount`），禁止无递增的 `continue`。 |
| 6 | 步骤之间用 `System.sleep`；关键步骤打 `console.log`，便于读 `logs`。 |
| 7 | 已切到第三方 App 时用 `FloatDialogs` 提示，不用 `Dialogs` / 指望前台 toast。 |
| 8 | 自动结束：在 `tasks/*.js` 里 `Engines.closeAll()`。菜单停用 `FloatWindow.stopTask()`（用户要菜单时才写）。 |
| 9 | 同一失败模式连续修 **3 轮**仍不过 → 进入下方「请求用户协助」，不要空转猜测。 |

## 片段验证清单

按顺序用 `run` 短代码验证，通过一项再下一项：

1. **权限**：`Access.isAccessibilityServiceEnabled()` / 悬浮窗等为 true  
2. **在目标 App**：`App` / `System.currentPackage`（或等价）符合预期  
3. **找得到节点**：打印 `text` / `desc` / `bounds`；确认在屏内  
4. **点得动 / 输得进**：单独 `click` 或 `setText`（输入优先 `setText` / 剪贴板）  
5. **再拼循环**：带上限的 `while`，再 `write` + `run-file`

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

- [ ] 关键逻辑已在真机片段或 `run-file` 验证（或已声明无法连机并列出用户侧步骤）  
- [ ] 改动文件已 `write`（若交付给用户在手机执行）  
- [ ] `logs` 无未处理错误；循环有上限  
- [ ] 未在 `page.js` 里写无障碍主流程；未在页面 JSON `action` 里跑脚本  
- [ ] 若曾请求用户协助：用户完成的步骤已记入最终说明  

## 相关

- 连接与命令：[`ai-device-debug.md`](./ai-device-debug.md)  
- 运行边界：[`dev-workflow.md`](./dev-workflow.md)  
- 找节点：[`UiSelector.md`](../02-script/api/UiSelector.md)  
- 自检表：[`donts.md`](../04-cheatsheets/donts.md)  
