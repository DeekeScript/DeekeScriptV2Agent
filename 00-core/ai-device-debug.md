# AI 连接手机并自动调试脚本

当用户让你**编写或调试自动化脚本**（`tasks/*.js`）时，在交付代码之前，应尝试连接用户手机上的 DeekeScript，用 HTTP `/ai` 接口**实机验证**。不要只生成代码就结束。

配套工具：

| 平台 | 脚本 |
|------|------|
| Windows | [`tools/deeke-device.ps1`](../tools/deeke-device.ps1) |
| macOS / Linux | [`tools/deeke-device.sh`](../tools/deeke-device.sh)（推荐）；已装 PowerShell 7 也可用 `.ps1` |

接口详情：[`02-script/ai-http-api.md`](../02-script/ai-http-api.md)

## 固定流程

```
1. 读取已保存地址（工作区根目录 .deeke-device.local.json）
      ↓ 没有或连不上
2. 运行设备发现命令扫描局域网
      ↓ 扫不到
3. 明确让用户填写手机地址（http://IP:8080），写入 .deeke-device.local.json
      ↓ 连上后
4. GET /ai/status 检查权限
5. 写/改工程文件（电脑工作区）→ **write 同步到手机** → POST /ai/run 或 run-file → 看 logs 调试 → 重复直到通过
6. 需要看界面时 `GET /ai/snapshot?type=0`（简单+快速；节点难分再升复杂或非快速，见 [`ai-http-api.md`](../02-script/ai-http-api.md)）
```

**必须同步**：只改电脑上的 `tasks/*.js` / `page.js` 等，手机不会自动更新。交付或 `run-file` 前，用 `POST /ai/project/write`（或工具 `write`）把改过的文件推到手机。短验证可用 `run` 直接传代码字符串，不必先落盘同步。
## 第一步：发现设备

在工作区根目录执行：

**Windows（PowerShell）**

```powershell
powershell -ExecutionPolicy Bypass -File tools/deeke-device.ps1 discover
```

**macOS / Linux（bash，推荐）**

```bash
bash tools/deeke-device.sh discover
# 或
chmod +x tools/deeke-device.sh && ./tools/deeke-device.sh discover
```

**macOS（已安装 PowerShell 7+ 时可选）**

```bash
pwsh tools/deeke-device.ps1 discover
```

脚本行为：

| 本机局域网 IP | 行为 |
|---------------|------|
| `192.168.*` | 扫描同网段 `x.x.1`–`x.x.254` 的 **8080** 端口，并请求 `/ai/status` 确认是 DeekeScript |
| 非 `192.168` 开头 | **放弃扫描**，输出 `skipScan: true`，你必须让用户手动提供地址 |

输出 JSON 示例：

```json
{
  "skipScan": false,
  "localIp": "192.168.1.100",
  "devices": [
    { "ip": "192.168.1.113", "baseUrl": "http://192.168.1.113:8080", "status": { "accessibility": true, "capture": true } }
  ]
}
```

- 找到 **1 台**：自动选用，写入 `.deeke-device.local.json`
- 找到 **多台**：列出让用户选一台
- **0 台**：不要猜 IP，直接问用户：

> 未在局域网发现 DeekeScript 设备。请在手机 DeekeScript App 侧栏开启「节点查看」，并告诉我手机地址（例如 `http://192.168.1.113:8080`）。

用户给出后：

```powershell
# Windows
powershell -ExecutionPolicy Bypass -File tools/deeke-device.ps1 set -BaseUrl "http://192.168.1.113:8080"
```

```bash
# macOS / Linux
bash tools/deeke-device.sh set --base-url "http://192.168.1.113:8080"
```

## 第二步：检查权限

```powershell
# Windows
powershell -ExecutionPolicy Bypass -File tools/deeke-device.ps1 status
```

```bash
# macOS / Linux
bash tools/deeke-device.sh status
```

关注 `data` 字段：

| 字段 | 含义 | 未开启时 |
|------|------|----------|
| `accessibility` | 无障碍 | 提示用户在 App 开启无障碍 |
| `accessibilityQuick` | 快速模式（`true`=快速，`false`=非快速） | 节点难分时可切换，见 [`ai-http-api.md`](../02-script/ai-http-api.md) |
| `floatWindow` | 悬浮窗 | 执行脚本需要 |
| `capture` | 截图/图色 | `/ai/snapshot` 无图 |
| `httpServer` | 8080 服务 | 提示开启「节点查看」 |
| `scriptRunning` | 是否有脚本在跑 | 先 `stop` 再调试 |

权限不齐时先指导用户开启，不要硬跑脚本。

## 第三步：同步文件到手机，再调试

在电脑工作区新建或修改任何工程文件后，**先同步再执行**：

```powershell
# Windows — 同步单个文件到手机（路径相对项目根）
powershell -ExecutionPolicy Bypass -File tools/deeke-device.ps1 write -File "tasks/sample.js"
```

```bash
# macOS / Linux
bash tools/deeke-device.sh write --file "tasks/sample.js"
```

改了多个文件就逐个 `write`（或至少同步本次改动相关的全部文件）。同步当前打开页的 `page.json` / `page.js` 时手机会自动热更新；若页未打开或热更新失败，再让用户点刷新。

## 第四步：自动调试循环

编写或修改 `tasks/*.js` 并 **write 同步** 后：

**先片段、再整体**：用 `run` 短代码分别验证「找节点 / 点击 / 输入」，确认无误后再 `run-file` 跑完整任务。不要一上来就整段盲跑。

若工程或上次调试用过 `FloatDialogs.show` / `confirm`，**每次执行前先关弹窗**：

```bash
bash tools/deeke-device.sh run --script "FloatDialogs.closeAll(); console.log('dialogs cleared');"
```

```powershell
# Windows — 方式 A：短代码（不必同步，代码经 HTTP 直接执行）
powershell -ExecutionPolicy Bypass -File tools/deeke-device.ps1 run -Script "console.log('test'); let n = UiSelector().find(); console.log('nodes', n.length);"
# Windows — 方式 B：任务文件（须已 write 到手机）
powershell -ExecutionPolicy Bypass -File tools/deeke-device.ps1 run-file -ScriptFile "tasks/sample.js"
```

```bash
# macOS / Linux — 方式 A：短代码
bash tools/deeke-device.sh run --script "console.log('test'); let n = UiSelector().find(); console.log('nodes', n.length);"
# macOS / Linux — 方式 B：任务文件（须已 write）
bash tools/deeke-device.sh run-file --script-file "tasks/sample.js"
```

`run` / `run-file` 会**阻塞到脚本结束**，在 JSON 的 `data.logs` 里返回全部 `console.log` 和控制台输出。

调试策略：

1. **片段**：短脚本验证 `UiSelector`（含 `filter` 后）能否找到目标节点，打印 `bounds` / text / desc
2. **片段**：单独验证点击、输入（`setText` / 剪贴板），不要先跑完整任务
3. 报错看 `data.error` 和 `logs` 里 `code` 为错误的项
4. 界面不对时 `snapshot` 拿节点树 + 截图对照
5. 脚本卡死用 `stop`；有残留弹窗先 `FloatDialogs.closeAll()`
6. 修代码 → **再次 `write` 同步** → 再 `run` / `run-file`，直到 logs 符合预期
7. **整体**：片段都通过后再 `run-file` 跑完整 `tasks/*.js`

```powershell
# Windows
powershell -ExecutionPolicy Bypass -File tools/deeke-device.ps1 snapshot
powershell -ExecutionPolicy Bypass -File tools/deeke-device.ps1 stop
```

```bash
# macOS / Linux
bash tools/deeke-device.sh snapshot
bash tools/deeke-device.sh stop
```

## 配置文件

工作区根目录 `.deeke-device.local.json`（已 gitignore，勿提交）：

```json
{
  "baseUrl": "http://192.168.1.113:8080"
}
```

优先读此文件；`discover` 成功后会自动写入。

## 与 VSCode 插件的关系

| 方式 | 适用 |
|------|------|
| VSCode DeekeScript 插件 + WebSocket 8088 | 人手动开发、项目同步 |
| HTTP `/ai` + 本工具（含 `write`） | **AI 自动写脚本、同步到手机、自动调试** |

AI 调试时不要依赖用户已开「开发模式」；只需手机开启「节点查看」（8080）和脚本所需权限。改文件后用 `write`（`POST /ai/project/write`），不要假设 VSCode 插件已同步。

## 交付前自检

- [ ] 已连接设备（`status` 返回 `code: 0`）
- [ ] 本次改动的工程文件已 `write` 同步到手机（若用了 `run-file` 或交付给用户在手机执行）
- [ ] 关键逻辑已在真机 `run` / `run-file` 过，`logs` 无未处理错误
- [ ] 找节点类脚本至少验证过一次 `UiSelector` 结果
- [ ] 若用户环境无法连接，已说明需开启的权限，并仍交付完整代码
