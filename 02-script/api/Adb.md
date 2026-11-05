# Adb

Android 11+ **无线调试**：App 在本机与 `adbd` 配对后，脚本可 `shell`、点击、授权、装包。不依赖电脑，也不依赖蓝牙 HID。认界面主要靠 [`Images.md`](./Images.md) / [`Ocr.md`](./Ocr.md)，再用 `Adb.tap` / `Adb.swipe`。无障碍在一些场景也要用图色认内容。

不要对 `Adb` 使用 `typeof`。多数方法返回 `{ ok, error?, result?, all?, ... }`；先看 `ok`。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 引导开无线调试、输入配对码 / 连接端口 |
| `tasks/*.js` | 实际 shell、点击、装包 |

## 前置

1. Android 11+：`Adb.isSupported()`。
2. 打开 Wi‑Fi，打开「开发者选项 → 无线调试」。
3. **第一次**（或清数据 / 撤销授权 / 换 applicationId 后）：点「使用配对码配对设备」，用 `App.notifyInput` 在通知栏回复 6 位码，再 `Adb.pairWithCode`。不要切回本应用，否则配对弹窗常被关掉。
4. **日常**：无线调试开着即可；`Adb.connectSaved()` 会自动扫描连接端口。扫不到再 `pairWithCode`（同样自动扫描）。手填端口只在手动配对。

配对端口和连接端口**不是同一个**。默认不用抄。只有手动配对才区分：配对码弹窗上的是配对端口；主界面 `IP:端口` 里是连接端口。

```javascript
if (!Adb.isSupported()) {
  throw new Error('需要 Android 11+');
}
let c = Adb.connectSaved();
if (!c.ok) {
  let code = App.notifyInput(
    '无线调试配对',
    '点「输入」回复 6 位配对码。不要回到本应用。',
    '6 位配对码',
    function () {
      Adb.openWirelessDebuggingSettings();
    }
  );
  if (!code) {
    throw new Error(c.error || '连接失败');
  }
  c = Adb.pairWithCode(String(code));
}
if (!c.ok) {
  throw new Error(c.error || '连接失败');
}
console.log(Adb.shell('id'));
```

## 相近方法

| 需求 | 用 | 不用 |
|------|----|------|
| 第一次信任本 App | `pairWithCode(code)` 或 `{code, pairPort, connectPort}` | 不要每次任务都 pair |
| 日常重连 | `connectSaved()`（自动扫描） | 不要一上来手填端口；扫不到再 `pairWithCode`，仍失败才手动配对 |
| 任意命令 | `shell(cmd)` | 返回对象，读 `result` / `all` |
| 点一下 / 滑动 | `tap` / `swipe` | 与 Hid/Gesture 不同通道；已连 Adb 即可 |
| 电脑上的 `adb` CLI | 本 API 无关 | Agent 设备调试仍用工程 `/ai` 与电脑 adb，不要混 |

## 配对与连接

| 方法 | 签名 | 返回值 | 说明 |
|------|------|--------|------|
| isSupported | `isSupported()` | `boolean` | API ≥ 30 |
| status | `status()` | `object` | host/port/开关等摘要 |
| isConnected | `isConnected()` | `boolean` | 是否已连上 |
| getConnectState | `getConnectState()` | `boolean` | 同 `isConnected` |
| pairWithCode | `pairWithCode(code[, timeoutMs])` 或 `pairWithCode({code, timeoutMs?, pairPort?, connectPort?})` | `object` | 推荐首次配对。6 位码用 `App.notifyInput` 在通知栏回复。默认扫描约 60s。可选手填端口（与 Mac `adb pair IP:端口` 同思路） |
| pairCode / easyPair | 同 `pairWithCode` | `object` | 别名 |
| pair | `pair(port, code)` / `pair(host, port, code)` / `pair({host,port,code})` | `object` | 只配对不自动 connect |
| connect | `connect()` / `connect(port)` / `connect(host, port)` / `connect("ip:port")` / `connect({host,port})` | `object` | 无参等同 `connectSaved`。本机自动试 Wi‑Fi IP |
| connectSaved | `connectSaved()` | `object` | 已连接直接成功；历史端口失败会短时自动发现连接端口 |
| connectByDiscovery | `connectByDiscovery(timeoutMs?)` | `object` | 只扫连接端口再 connect |
| tryConnect | `tryConnect(...)` | `object` | 失败返回错误对象 |
| reconnect | `reconnect()` | `object` | 断开再按上次地址连 |
| disconnect | `disconnect()` | `boolean` | 断开 |
| openWirelessDebuggingSettings | `openWirelessDebuggingSettings()` | `boolean` | 跳转系统无线调试页 |
| openDeveloperOptions | `openDeveloperOptions()` | `boolean` | 跳转开发者选项 |
| localIpAddresses | `localIpAddresses()` | `string[]` | 本机 IPv4 |
| ensureIdentity / rotateIdentity / clearIdentity | 无参 | `object` / `boolean` | 密钥；rotate/clear 后需重新配对 |
| help | `help()` | `string` | 方法列表打到控制台 |

```javascript
// 首次：通知栏回复 6 位码，保持配对弹窗
let code = App.notifyInput('无线调试配对', '点「输入」回复 6 位码', '6 位配对码', function () {
  Adb.openWirelessDebuggingSettings();
});
Adb.pairWithCode(String(code));
// 或与 Mac 一样手抄端口
Adb.pairWithCode({ code: '643102', pairPort: 37123, connectPort: 5555 });

// 日常：自动扫描，不用手填端口
Adb.connectSaved();
```

## 执行与文件

| 方法 | 签名 | 返回值 | 说明 |
|------|------|--------|------|
| shell | `shell(command)` | `object` | 一次性命令（底层 `exec:`）。`home`/`tap` 等也走这条，不会因 `shell:` 不关流而挂死 |
| exec / execute | 同 `shell` | `object` | 别名 |
| service | `service(destination, writeUtf8?, maxBytes?)` | `object` | 原始 Adb service |
| serviceBytes | `serviceBytes(destination, maxBytes?)` | `object` | 返回字节 |
| push | `push(local, remote)` | `object` | 把本地文件推到设备路径 |
| pull / pullAndSave | `pull(remote, local)` | `object` | 把设备文件拉到本地 |
| install / pushAndInstall | `install(apkPath, ...extraArgs)` | `object` | 安装 apk |
| installMultiple | `installMultiple(apkPaths)` | `object` | 按顺序安装多个 apk |
| uninstall | `uninstall(packageName)` | `object` | 卸载应用 |

## 输入与系统

| 方法 | 签名 | 返回值 | 说明 |
|------|------|--------|------|
| tap | `tap(x, y)` | `object` | 点击 |
| swipe | `swipe(x1, y1, x2, y2, durationMs?)` | `object` | 直线滑动，默认 300ms |
| drag | `drag(x1, y1, x2, y2, durationMs?)` | `object` | 按住拖动，默认 500ms |
| longPress / press | `longPress(x, y, durationMs?)` | `object` | 长按，默认 800ms |
| keyEvent / key | `keyEvent(codeOrName)` | `object` | 发送按键。名字全集见文档「按键名」；其它键传 Android KeyEvent 数字码 |
| text / type | `text(value)` | `object` | 向当前焦点输入文字 |
| power | `power()` | `object` | 亮屏 |
| wake | `wake()` | `object` | 亮屏 |
| sleep | `sleep()` | `object` | 息屏 |
| home | `home()` | `object` | 回到桌面 |
| back | `back()` | `object` | 返回上一层 |
| recents | `recents()` | `object` | 打开最近任务 |
| volumeUp | `volumeUp()` | `object` | 音量加 |
| volumeDown | `volumeDown()` | `object` | 音量减 |
| mute | `mute()` | `object` | 静音 |
| enter | `enter()` | `object` | 回车 |
| del | `del()` | `object` | 退格 |
| menu | `menu()` | `object` | 菜单键 |
| screenshot / screencap | `screenshot(localPath)` | `object` | 截图保存到文件 |
| screenshotBytes | `screenshotBytes()` | `object` | 截图返回字节 |
| startApp | `startApp(packageName, activity?)` | `object` | 启动应用 |
| forceStop | `forceStop(pkg)` | `object` | 强行停止应用 |
| clearApp | `clearApp(pkg)` | `object` | 清除应用数据 |
| grant | `grant(pkg, permission)` | `object` | 授予运行时权限 |
| revoke | `revoke(pkg, permission)` | `object` | 撤销运行时权限 |
| settingsGet | `settingsGet(namespace, key)` | `object` | 读取系统设置 |
| settingsPut | `settingsPut(namespace, key, value)` | `object` | 写入系统设置 |
| settingsDelete | `settingsDelete(namespace, key)` | `object` | 删除系统设置 |
| dumpsys | `dumpsys(service)` | `object` | 导出系统服务调试信息 |
| activityTop | `activityTop()` | `object` | 查看当前前台 Activity |
| currentFocus | `currentFocus()` | `object` | 查看当前焦点窗口 |
| waitForShell | `waitForShell(cmd, expectContains, timeoutMs?, intervalMs?)` | `object` | 反复执行命令，直到输出包含期望文字 |
| waitConnected | `waitConnected(timeoutMs?, intervalMs?)` | `object` | 等到连上 adbd |

```javascript
Adb.shell('pm list packages | head');
Adb.home();
Adb.tap(500, 800);
Adb.swipe(500, 1400, 500, 400, 300);
Adb.grant('com.example.app', 'android.permission.CAMERA');
```

## 注意

- `connectSaved` 会自动扫描连接端口。仍失败再 `pairWithCode`（只填 6 位码，端口也自动扫描）。两条都扫不到才手填端口，见手动配对。
- 华为等机型 adbd 常不监听 `127.0.0.1`，实现会自动试 Wi‑Fi IP；手填时也可抄设置页局域网 IP。
- 6 位码用 `App.notifyInput`，不要用 `Dialogs.input` 把本应用拉回前台，否则系统配对弹窗常被关掉。自动发现失败时再手填 `pairPort` + `connectPort`，同样用通知栏逐条回复。
- 调试时勿循环 `Adb.home()` / `Adb.back()` 把宿主送走；原则同 [`keep-host-alive.md`](../pitfalls/keep-host-alive.md)。
