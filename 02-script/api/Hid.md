# Hid

蓝牙 HID 硬件：点击、滑动、按键、粘贴。被检测概率低于无障碍，适合游戏/羊毛类。HID **不能**做节点检索；界面识别用图色或无障碍，HID 只负责动作。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 权限引导可以 |
| `tasks/*.js` | 实际 HID 操作在任务里 |

## 前置权限与硬件

1. **蓝牙权限**（Hid.initBluetooth）：`Access.hasBluetoothConnectionPermission()`。Android 12+ 含 `BLUETOOTH_CONNECT` / `BLUETOOTH_SCAN`；API 31 以下不必申请。
2. 永久拒绝时 `Access.openBluetoothPermissionSettings()`，否则 `Access.requestBluetoothConnectionPermission()`。
3. 手机先打开蓝牙并连上 HID 设备，再 `Hid.initBluetooth(context)`、`Hid.connect(...)`。
4. 图色识别还需录屏权限，见 [`Images.md`](./Images.md)。

```javascript
if (!Access.hasBluetoothConnectionPermission()) {
  if (Access.isBluetoothPermissionPermanentlyDenied()) {
    Access.openBluetoothPermissionSettings();
    System.exit();
  } else {
    Access.requestBluetoothConnectionPermission();
    System.sleep(1000);
  }
} else {
  Hid.initBluetooth(context);
}
```

`context` 为官方示例中的 Android Context 参数，不要改成未文档化的其它对象。

## 方法

手势：

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `swipe(x1,y1,x2,y2, step?, downTimeout?, upTimeout?, timeout?, upDownTimes?)` | 坐标；可选步长 5–60（默认 20–51 随机）等 | `boolean` | 直线滑动 |
| `swipex(x1,y1,x2,y2, radian?, ...)` | `radian` 建议 10–100 | `boolean` | 曲线滑动 |
| `tap(x, y)` | 坐标 | `boolean` | 点击 |
| `touchDown(x, y)` / `touchMove(x, y)` / `touchUp(x?, y?)` | 坐标 | `boolean` | 按下 / 移动 / 抬起 |
| `touchUp()` | 无 | `boolean` | 在最后触摸点抬起 |
| `touchUp2()` | 无 | `boolean` | 多次尝试抬起 |

系统键与编辑：

| 方法 | 说明 |
|------|------|
| `home()` `recents()` `back()` `back1()` | Home / 任务 / 返回 |
| `keyDown(code)` `keyUp(code)` `keyPress(code)` | 按键按下 / 抬起 / 单击 |
| `keyPress_code` `keyDown_code` `keyUp_code` | 与上面不同的特定按键实现 |
| `keyUpAll()` | 松开所有按键 |
| `key_select()` `key_copy()` `key_cat()` `key_paste()` | 全选 / 复制 / 剪切 / 粘贴 |
| `key_del()` `key_delete()` `key_enter()` | 退格 / 删除 / 回车 |
| `key_num(n)` | 数字 0–9 |
| `key_abc(n)` | 字母 |
| `volUp()` `volDown()` | 音量 |
| `power()` / `power(time)` | 电源；可选按住毫秒 |
| `reboot()` | 重启蓝牙主板 |

连接与其它：

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `initBluetooth(ctx)` | Android Context | `boolean` | 初始化蓝牙 HID |
| `connect(autoconnect, index)` | 是否自动连接、设备索引 | `boolean` | 连接 |
| `disconnect()` | 无 | `boolean` | 断开 |
| `getConnectState()` | 无 | `boolean` | 是否已连接 |
| `getConnectedDevices()` | 无 | 设备或 `null` | 已连接设备 |
| `getName()` | 无 | `string` | 已连接设备名 |
| `sendData(str)` | 字符串 | `boolean` | 发数据 |
| `sendDataAwait(str, time)` | 等待毫秒 | `boolean` | 发送并等待响应 |
| `getData(time?)` | 可选等待毫秒 | `string` | 取数据 |
| `waitFor(time?, sleep?)` | 最大等待、检查间隔 | `string` | 等待数据 |
| `ver()` | 无 | `number` | 插件版本 |
| `getHidZcm()` | 无 | `string` | d.ts 有，官方 md 未说明用途，不要编造 |
| `setXY(x, y)` | 坐标 | `boolean` | 设置分辨率 |
| `reg(key)` | 注册密钥 | `boolean` | 注册设备 |
| `setRnd(x, y)` | 随机数 | `boolean` | 点击延时随机 |
| `setBattery(lv)` | 电量百分比 | `boolean` | 设置电量 |

## 最小片段

```javascript
if (!Access.hasBluetoothConnectionPermission()) {
  Access.requestBluetoothConnectionPermission();
  System.exit();
}

Hid.initBluetooth(context);
Hid.connect(true, 0);
if (Hid.getConnectState()) {
  Hid.tap(500, 800);
  Hid.swipe(10, 1000, 1000, 1050);
}
```

## 注意

- HID 不做 `UiSelector`。找控件用无障碍，或截图 + [`Images.md`](./Images.md)。
- 未开蓝牙权限不要 `initBluetooth`。
- 文本输入可配合 [`KeyBoards.md`](./KeyBoards.md)。
- 相关：[`Access.md`](./Access.md)、[`do-mode.md`](./do-mode.md)。
