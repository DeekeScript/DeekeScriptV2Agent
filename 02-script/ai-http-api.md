# DeekeScript AI HTTP 接口（8080 /ai）

手机 App 侧栏开启「节点查看」后，电脑可通过局域网访问 `http://{手机IP}:8080/ai/*`。

统一响应：

```json
{ "code": 0, "msg": "success", "data": { } }
```

`code !== 0` 时看 `msg`。命令行工具：Windows [`tools/deeke-device.ps1`](../tools/deeke-device.ps1)，macOS/Linux [`tools/deeke-device.sh`](../tools/deeke-device.sh)。

## 前置条件

| 能力 | App 侧操作 |
|------|------------|
| 所有 `/ai` 接口 | 侧栏开启「节点查看」 |
| 节点树 | 无障碍权限 |
| 截图 | 图色/截图权限 |
| 执行脚本 | 悬浮窗权限 |

## 接口列表

### GET `/ai/help`

返回接口说明与示例。

### GET `/ai/status`

设备状态与权限，**用于发现设备时验证**。

```json
{
  "code": 0,
  "data": {
    "httpServer": true,
    "accessibility": true,
    "accessibilityQuick": true,
    "floatWindow": true,
    "capture": true,
    "scriptRunning": false,
    "ip": "192.168.1.113",
    "port": 8080,
    "projectDir": "/storage/...",
    "screenWidth": 1080,
    "screenHeight": 2400,
    "screenRotation": 0
  }
}
```

### GET `/ai/nodes?type=0|1`

UI 节点树。`type` 控制**简单 / 复杂模式**（窗口范围），与脚本里 `UiSelector(simpleMode)` 一致（见 [`UiSelector.md`](api/UiSelector.md)）：

| `type` | 模式 | 行为 |
|--------|------|------|
| `0` | **简单模式** | 仅当前活动窗口的根节点 |
| `1` | **复杂模式** | 所有窗口（含状态栏、悬浮层等系统节点） |

另有一个独立维度：**快速 / 非快速模式**（节点密度）。这不是 `type` 参数，而是手机全局无障碍设置：

| 模式 | 手机侧 | 脚本侧 | 效果 |
|------|--------|--------|------|
| **快速模式** | App 侧栏「快速模式」开启 | `System.setAccessibilityMode('fast')` | 过滤不重要节点，树更小、响应更快 |
| **非快速模式** | 侧栏关闭快速模式 | `System.setAccessibilityMode('normal')` 等非 `fast` 值 | 包含不重要节点，树更全 |

`/ai/status` 的 `accessibilityQuick: true/false` 表示当前是否为快速模式。

#### AI 选用策略

**默认优先：简单模式 + 快速模式** → `GET /ai/nodes?type=0`（确认 `accessibilityQuick: true`）。

节点**差不多、难以区分**时，按顺序升级（每次只改一个维度，对比 `nodeInfos`）：

1. **复杂 + 快速**：`type=1`，保持快速模式
2. **简单 + 非快速**：`type=0`，`POST /ai/run` 执行 `System.setAccessibilityMode('normal');` 或让用户关闭侧栏快速模式
3. **复杂 + 非快速**：`type=1` + 非快速模式（信息最全，树最大）

`/ai/snapshot` 的 `type` 含义相同；**默认用 `type=0`**，需要时再升到 `1`。

```json
{
  "code": 0,
  "data": {
    "nodeInfos": [ { "text": "...", "className": "...", "boundsInScreen": {}, "isClickable": true } ],
    "screenRotation": 0
  }
}
```

节点 `key` 为内存 hash，**跨请求不稳定**；用 `text` + `viewIdResourceName` + `boundsInScreen` 定位。

### GET `/ai/snapshot?type=0|1&image=1`

节点 + 截图一次返回。`type` 同 [`/ai/nodes`](#get-ainodestype01)（**默认 `type=0` 简单+快速**）。

`data.image` 为 PNG 的 Base64；无截图权限时 `image` 为 `null`。

### GET `/ai/capture`

仅截图，PNG Base64。

### POST `/ai/run`

**同步执行 DeekeScript 代码**，结束后在 `data.logs` 返回全部 `console.log`。

请求：

```json
{
  "script": "console.log('hello');\nlet btn = UiSelector().text('发送').findOne();\nconsole.log(btn ? 'found' : 'not found');",
  "file": "ai_debug.js",
  "timeout": 60000
}
```

响应：

```json
{
  "code": 0,
  "data": {
    "running": false,
    "durationMs": 1523,
    "logs": [
      { "code": 1, "message": "14:30:01.123      hello", "time": 1234567890 }
    ],
    "error": null
  }
}
```

注意：

- **不是流式**；脚本跑完后一次性返回 logs
- 默认超时 60s，最大 600s
- 同时只能跑一个脚本；冲突时先 `POST /ai/stop`
- 代码须符合 [Rhino 约束](../00-core/rhino.md)：无 `async/await` / `?.` / `??` / `import`/`export`

### POST `/ai/run-file`

执行项目内已有脚本文件。

```json
{ "file": "tasks/main.js", "timeout": 120000 }
```

路径相对手机项目根目录（与工程里 `tasks/` 一致）。若工程尚未同步到手机，优先用 `/ai/run` 传代码字符串。

### POST `/ai/stop`

停止正在执行的脚本。

### GET `/ai/logs`

拉取控制台队列中尚未消费的日志（调试用）。

### GET `/ai/project/list?path=`

列出手机项目目录文件。

### GET `/ai/project/read?file=tasks/foo.js`

读取手机项目文件内容。

### POST `/ai/project/write`

**把电脑侧写好的文件同步到手机项目目录**（HTTP，等价于编辑器「文件同步」）。

请求：

```json
{
  "file": "tasks/test.js",
  "content": "Y29uc29sZS5sb2coJ3Rlc3QnKTs=",
  "isDir": false
}
```

| 字段 | 说明 |
|------|------|
| `file` | 相对项目根的路径，如 `tasks/douyin_like.js`、`pages/home/page.js` |
| `content` | 文件内容的 **Base64**（UTF-8 文本先编码再 Base64） |
| `isDir` | 可选；`true` 时只创建目录，可省略 `content` |

响应：`{ "file", "isDir", "message": "写入成功" }`。

命令行（推荐）：

```powershell
# Windows — 把本地文件同步到手机同名路径
powershell -ExecutionPolicy Bypass -File tools/deeke-device.ps1 write -File "tasks/test.js"
```

```bash
# macOS / Linux
bash tools/deeke-device.sh write --file "tasks/test.js"
```

**硬规则**：在电脑上新建或修改工程文件后，若要用手机执行 / 看界面，**必须先** `write` 同步到手机。同步 `page.json` / `page.js`（及当前页已嵌入的组件）时，若该页正打开，手机会自动热更新；`tasks/*.js` 同步后可用 `run-file` 执行。只改电脑磁盘、不同步，手机仍是旧文件。

## AI 调试推荐组合

| 步骤 | 接口 |
|------|------|
| 连上设备 | `GET /ai/status`（看 `accessibilityQuick`） |
| 看界面 | `GET /ai/snapshot?type=0&image=1`（不够再升 `type` 或切换快速模式） |
| **同步文件** | `POST /ai/project/write`（或工具 `write`） |
| 验证选择器 | `POST /ai/run` 短脚本 + `console.log` |
| 跑完整任务 | `POST /ai/run-file`（须已同步该文件） |
| 中断 | `POST /ai/stop` |

## curl 示例

```bash
curl -s "http://192.168.1.113:8080/ai/status"
curl -s "http://192.168.1.113:8080/ai/snapshot?type=0&image=1"
curl -s -X POST "http://192.168.1.113:8080/ai/run" -H "Content-Type: application/json" -d "{\"script\":\"console.log(123);\",\"timeout\":30000}"
# 同步文件（content 为 Base64）
curl -s -X POST "http://192.168.1.113:8080/ai/project/write" -H "Content-Type: application/json" \
  -d "{\"file\":\"tasks/test.js\",\"content\":\"Y29uc29sZS5sb2coMTIzKTs=\"}"
```

完整流程见 [`00-core/ai-device-debug.md`](../00-core/ai-device-debug.md)。
