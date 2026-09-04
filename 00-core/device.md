# 连机、同步、调试

生成或改工程时按本篇执行。HTTP 字段见 [`ai-http-api.md`](../02-script/ai-http-api.md)。硬规则见 [`constraints.md`](./constraints.md) MUST 9 / 16。

目标：先连机 → 边写边 `write` → 写完必须验证。禁止只交代码。设备已连上时，禁止用「声明未验证」代替调试。

## 什么算已验证（tasks）

**算：** 已 `launch` 目标 App；写选择器前已 `snapshot`（或 `/ai/nodes`）；片段 `run` 打出目标页关键节点的 `text`/`desc`/`bounds`；点击或输入按清单验证过；再 `run-file`（可用数量=1）。回复须引用这些 logs。

**不算：** 只 `status` / 只 `write` / 只 `Storage` / 只本工程页面能打开 / 只 `require` 不报错。

连不上设备：仍生成完整可运行代码，列出用户须开的权限与地址；**不得假装已实机验证**。`status` 已通则必须 snapshot + 片段验证，不得改口「请用户自己运行」。

## 强制流程

```
1. 编写前：discover / set + status
2. 确认目标：界面要什么 / 哪个 App、步骤、停条件
3. 操作第三方 App：写选择器前必须 snapshot，禁止凭记忆猜 desc/id
4. 落盘 → 每改一批就 write（不要攒到最后）
5. 验证：界面点测；任务先 run 片段（目标 App），再 write → run-file → 读 logs
6. 失败则修 → write → 再验；通过后交付
```

短验证可用 `run` 传代码字符串（可不先 `write`）；`run-file` 或交付前必须已 `write`。

## 调试时必守

| # | 规则 |
|---|------|
| 1 | 找节点 `UiSelector().…`；点击前一般先 `filter` 屏内 |
| 2 | 每次 `run` / `run-file` 前：若用过悬浮弹窗，先 `FloatDialogs.closeAll()` |
| 3 | `while` / 重试必须有上限；刷流以内容条为进度，单条失败 skip 前进。见 [`skip-on-item-failure.md`](../02-script/pitfalls/skip-on-item-failure.md) |
| 4 | 步骤之间 `System.sleep`；关键步骤 `console.log` |
| 5 | 已切第三方 App 用 `FloatDialogs` 提示。目标 App 业务弹窗点文案关掉，勿与 Deeke 弹窗混用 |
| 6 | 自动结束：`tasks/*.js` 里 `Engines.closeAll()`。菜单停用 `FloatWindow.stopTask()` |
| 7 | 同一失败模式连续修 **3 轮**仍不过 → 请求用户协助，不要空转 |

## 片段验证清单

1. 权限：`Access.isAccessibilityServiceEnabled()` / 悬浮窗等为 true
2. 在目标页：用**互斥特征**（不要用评论列表也会出现的通用 id）。见 [`page-state.md`](../02-script/pitfalls/page-state.md)
3. 找得到：打印 `text` / `desc` / `bounds`，确认屏内
4. 点得动 / 输得进：普通按钮看界面变化；**输入**必须 `click` → `sleep` → **重新 find**（优先 `editable(true).focused(true)`）→ `setText` → 再读 `text`。见 [`stale-node-after-click.md`](../02-script/pitfalls/stale-node-after-click.md)
5. 再拼循环：有上限；刷流须验证「失败会划走」。再 `write` + `run-file`

用户需求本身就是搜索 / 点赞 / 评论 / 刷流时，这些步骤就是调试，**不必再问可不可以调试**。整段可用 `maxCount=1`。

## 何时问用户 / 不要问

| 问用户 | 自己解决 |
|--------|----------|
| 扫不到设备 / 非 `192.168.*` | 已有 `.deeke-device.local.json` 且 `status` 正常 |
| `status` 权限为 false（让用户开开关） | logs / snapshot 已能定位（选错节点、漏 filter/sleep/write） |
| 多台设备选一台 | 契约内 API / 路径 / Rhino 错误 |
| 登录 / 验证码 / 生物识别 | 用户已要求赞评刷流：自己 launch 做片段验证 |
| 连续 3 轮实机仍失败：要当前屏幕或正确节点特征 | |
| 业务次数/间隔不清 | |
| 支付、批量删除、向**用户未要求**的对象发私信：整段 `run-file` 前口头确认（找节点片段仍要做） | |

请求时写清：已尝试了什么、卡在哪、需要用户做什么。

## 交付前

- [ ] 编写前已连机（仅连不上才声明无法验证）
- [ ] 改动已 `write`
- [ ] `tasks/*.js` 已在目标 App 片段验证，回复含节点 logs
- [ ] 写选择器前已 snapshot
- [ ] 片段通过后已 `run-file`（可用数量=1）；循环有上限
- [ ] 刷流类：单条失败会 skip
- [ ] 多对象已按 [`code-org.md`](../02-script/code-org.md) 拆模块

设备 `status` 正常却未跑目标 App 片段 = **未完成，不得交付**。

用户若只用 VSCode 插件：插件走 WebSocket 8088。你仍优先用本篇 `/ai`（8080「节点查看」）自动调试。插件点法见 [`dev-workflow.md`](./dev-workflow.md)（仅用户问插件时再打开）。

---

## 命令（tools）

| 平台 | 脚本 |
|------|------|
| Windows | [`tools/deeke-device.ps1`](../tools/deeke-device.ps1) |
| macOS / Linux | [`tools/deeke-device.sh`](../tools/deeke-device.sh) |

工作区根目录 `.deeke-device.local.json`（gitignore，勿提交）：`{ "baseUrl": "http://192.168.1.113:8080" }`。`discover` 成功会自动写入。

```
1. 读 .deeke-device.local.json → 没有或连不上则 discover
2. 扫不到则让用户提供 http://IP:8080 并 set
3. status 查权限
4. 写/改文件 → write → 目标 App 上 run 片段 / run-file → 读 logs
```

### discover / set / status

```bash
bash tools/deeke-device.sh discover
bash tools/deeke-device.sh set --base-url "http://192.168.1.113:8080"
bash tools/deeke-device.sh status
```

```powershell
powershell -ExecutionPolicy Bypass -File tools/deeke-device.ps1 discover
powershell -ExecutionPolicy Bypass -File tools/deeke-device.ps1 set -BaseUrl "http://192.168.1.113:8080"
powershell -ExecutionPolicy Bypass -File tools/deeke-device.ps1 status
```

`192.168.*` 扫描同网段 8080；非 `192.168` 开头放弃扫描（`skipScan: true`），必须问用户地址。找到 1 台自动选用；多台让用户选；0 台不要猜 IP。

`status` 关注：`accessibility`、`floatWindow`、`capture`（snapshot 要图）、`httpServer`、`scriptRunning`（先 `stop` 再调）。`accessibilityQuick` 见 [`ai-http-api.md`](../02-script/ai-http-api.md)。

### write / run / run-file / snapshot / stop

```bash
bash tools/deeke-device.sh write --file "tasks/sample.js"
bash tools/deeke-device.sh run --script "FloatDialogs.closeAll(); console.log('dialogs cleared');"
bash tools/deeke-device.sh run --script "console.log('test'); let n = UiSelector().find(); console.log('nodes', n.length);"
bash tools/deeke-device.sh run-file --script-file "tasks/sample.js"
bash tools/deeke-device.sh snapshot
bash tools/deeke-device.sh stop
```

```powershell
powershell -ExecutionPolicy Bypass -File tools/deeke-device.ps1 write -File "tasks/sample.js"
powershell -ExecutionPolicy Bypass -File tools/deeke-device.ps1 run -Script "console.log('test');"
powershell -ExecutionPolicy Bypass -File tools/deeke-device.ps1 run-file -ScriptFile "tasks/sample.js"
powershell -ExecutionPolicy Bypass -File tools/deeke-device.ps1 snapshot
powershell -ExecutionPolicy Bypass -File tools/deeke-device.ps1 stop
```

只改电脑文件，手机不会自动更新。`run` / `run-file` 阻塞到结束，日志在返回 JSON 的 `data.logs`。同步当前打开页的 `page.json` / `page.js` 会热更新；失败则让用户点刷新。

### 日志

`/ai/run` 有时丢掉靠前的 `console.log`。关键断言合成**一条**：`console.log('result=' + JSON.stringify(ret))`，或带 `step1_` 前缀。屏宽高用 `Device.width()` / `Device.height()`，不要用 `/ai/status` 的 `screenHeight`。
