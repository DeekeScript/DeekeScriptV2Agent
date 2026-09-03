# 开发流程

连接手机、同步工程、执行任务脚本时读这篇。日常操作以 VSCode 的 DeekeScript 插件为准。自动化打开 `tasks/*.js` 用「仅当前文件执行」，不需要界面。`page.js` 不是任务脚本，打开对应页面时才加载。根目录没有 `deekeScript.json` 时，插件无法同步、无法运行 JS。

## 准备

| 项 | 要求 |
|----|------|
| VSCode | 最新版 |
| 插件 | 安装 DeekeScript 开发插件 |
| 手机 | 与电脑同一局域网；电脑 VPN 关掉 |
| App | DeekeScript Pro；侧边栏开启：无障碍、悬浮窗、图色查找、节点查看、开发模式 |

命令入口：编辑器右上角图标（打开 `deekeScript.json` 或任意 `page.js` / 任务 `js`），或「查看 → 命令面板」搜 DeekeScript。

## 连接与同步

| 命令 | 作用 |
|------|------|
| 连接手机 / 关闭连接 | 填手机局域网 IP；连上之后才能同步和执行 |
| 打开控制台 | 看 `console.log`、同步日志、报错 |
| 项目同步 | 同步整个工程：入口、页面、组件、公共模块、任务脚本 |
| 文件同步 | 只同步当前打开的文件 |
| 仅当前文件执行 | 执行当前 JS，用于 `tasks/`，不依赖界面 |
| 停止所有脚本 | 停掉手机上正在跑的脚本 |

同步后，手机端点 **刷新**（安卓图标右侧）。有界面的工程会进入 `homePage`。

## 执行任务（无界面）

1. 根目录放好 `deekeScript.json`。
2. 写 `tasks/sample.js`。
3. 用 VSCode 打开该文件，点「仅当前文件执行」。
4. 没有 `pages/`、不打开 `homePage` 也可以。

只改 `tasks/*.js` 时，可以只同步当前文件再执行，不必刷新页面。

## 改页面后刷新

1. 改 `page.json` / `page.js` / 组件。
2. 项目同步。
3. 手机点刷新，界面才会变。
4. 在手机上点底栏、按钮、列表，走的是 `page.js` 的 `onTap` / 生命周期。

页面按钮应调用 `Engines.executeScript('tasks/xxx.js')`，不要把任务写在 JSON `action` 里。

## 不要对 page.js 点执行

| 文件 | 怎么跑 |
|------|--------|
| `tasks/*.js` | 「仅当前文件执行」 |
| `page.js` | 只在打开该页时加载；不要当脚本执行 |
| `component.js` | 随页面/弹层里的组件实例加载 |

死循环或不想再跑时用「停止所有脚本」。工程结构见 [目录](./project-layout.md)，语法见 [Rhino](./rhino.md)。

## AI 自动调试（Cursor / Agent）

不依赖 VSCode 插件时，AI 可通过手机 **8080 `/ai` HTTP 接口** 实机跑脚本、看 `console.log`。

1. 读 [ai-device-debug.md](./ai-device-debug.md) 和 [ai-http-api.md](../02-script/ai-http-api.md)。
2. 按平台运行设备发现：Windows 用 `tools/deeke-device.ps1 discover`；macOS/Linux 用 `tools/deeke-device.sh discover`（本机须为 `192.168.*` 才扫描；否则让用户手填地址）。
3. **改完工程文件后先 `write` 同步到手机**，再用 `run` / `run-file` / `snapshot` / `status` 调试，根据返回的 `logs` 改代码。

手机侧至少开启：**节点查看**（8080）、**无障碍**、**悬浮窗**（执行脚本时）。
