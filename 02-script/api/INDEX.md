# 运行时 API 索引

生成脚本时**只打开用到的 API 文件**，不要整目录灌进上下文。方法表以 d.ts 为准；说明以官方文档为准。骨架与约定见 [`../task-template.md`](../task-template.md)、[`../permission.md`](../permission.md)、[`../ui-and-task.md`](../ui-and-task.md)、[`../require.md`](../require.md)。

| 名字 | 用途 | 主要上下文 | 链接 |
|------|------|------------|------|
| UiSelector | 按 text/id/className 等筛选屏幕节点 | tasks.js | [UiSelector.md](UiSelector.md) |
| UiObject | 对节点点击、输入、滚动、读属性 | tasks.js | [UiObject.md](UiObject.md) |
| Gesture | 按坐标点击、滑动、返回/Home/最近任务 | tasks.js | [Gesture.md](Gesture.md) |
| App | 当前包名与版本、启动应用、打开 URL | 两者 | [App.md](App.md) |
| System | 休眠、剪贴板、toast、等界面、退出 | 两者 | [System.md](System.md) |
| Storage | 键值存储；页面写入、脚本读取 | 两者 | [Storage.md](Storage.md) |
| Http | GET/POST、上传下载、流式 POST | 两者 | [Http.md](Http.md) |
| Engines | 启动/关闭独立脚本运行时 | 两者 | [Engines.md](Engines.md) |
| Access | 检查与申请无障碍、悬浮窗及其它权限 | 两者 | [Access.md](Access.md) |
| Dialogs | APP 在前台时的弹窗、输入、确认 | 两者 | [Dialogs.md](Dialogs.md) |
| FloatWindow | 项目悬浮球菜单：绑定、更新、收起 | 两者 | [FloatWindow.md](FloatWindow.md) |
| FloatDialogs | 后台弹窗、toast、悬浮球显隐与可点 | 两者 | [FloatDialogs.md](FloatDialogs.md) |
| Device | 屏幕尺寸、机型、网络、位置、已装应用 | 两者 | [Device.md](Device.md) |
| Files | 应用私有目录文件读写与路径 | 两者 | [Files.md](Files.md) |
| DeekeScript | 框架版本、读项目文件、批量取节点原始数据 | tasks.js | [DeekeScript.md](DeekeScript.md) |
| console | 打印调试；日志悬浮窗显示与样式 | 两者 | [console.md](console.md) |
| Log | 把日志写入文件（不打印到控制台） | 两者 | [Log.md](Log.md) |
| Images | 截图、找图、找色、OCR | tasks.js | [Images.md](Images.md) |
| MediaStore | 系统媒体库：图/视频/音频/下载/文档 | 两者 | [MediaStore.md](MediaStore.md) |
| Audio | 音频播放 | 两者 | [Audio.md](Audio.md) |
| KeyBoards | DeekeScript 输入法 | tasks.js | [KeyBoards.md](KeyBoards.md) |
| Hid | 蓝牙 HID 点击/滑动/按键 | tasks.js | [Hid.md](Hid.md) |
| Encrypt | MD5/SHA/Base64/AES | 两者 | [Encrypt.md](Encrypt.md) |
| Threads | 创建线程（慎用，优先定时器或 Engines） | 两者 | [Threads.md](Threads.md) |
| Timer | setTimeout / setInterval | 两者 | [timer.md](timer.md) |
| Promise | Promise.then（无 async/await） | 两者 | [Promise.md](Promise.md) |
| WebSocket | 原生 WebSocket | 两者 | [WebSocket.md](WebSocket.md) |
| SocketIoClient | Socket.IO 客户端 | 两者 | [SocketIo.md](SocketIo.md) |
| NotificationBridge | 监听其它 App 通知 | tasks.js | [Notification.md](Notification.md) |
| ForegroundServiceBridge | 前台服务保活 | tasks.js | [Foreground.md](Foreground.md) |
| Intent | URI/Intent 打开 Activity | 两者 | [Intent.md](Intent.md) |
| Cos | 腾讯云对象存储上传 | 两者 | [Cos.md](Cos.md) |
| DevicePolicy | Device Owner：锁屏、亮屏 | 两者 | [DevicePolicy.md](DevicePolicy.md) |
| DeviceApp | Device Owner：静默安装卸载与权限 | tasks.js | [DeviceApp.md](DeviceApp.md) |
| DeviceHardware | Device Owner：截屏/状态栏等 | 两者 | [DeviceHardware.md](DeviceHardware.md) |
| DeviceKiosk | Device Owner：Kiosk 锁定任务 | tasks.js | [DeviceKiosk.md](DeviceKiosk.md) |
| JavaImporter | Rhino 调用 Java 类 | 两者 | [extension.md](extension.md) |

工程/运营（不是日常脚本 API）：[activation.md](activation.md)、[backend.md](backend.md)、[apk.md](apk.md)、[do-mode.md](do-mode.md)、[code-encryption.md](code-encryption.md)、[no-hook.md](no-hook.md)。

`两者` 表示 `page.js` 与 `tasks.js` 都能调用。`UiSelector` / `UiObject` / `Gesture` 依赖无障碍，写在任务脚本里。APP 已到后台时用 `FloatDialogs`，不要用 `Dialogs`。
