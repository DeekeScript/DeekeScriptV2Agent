# Hid

蓝牙 HID：点击、滑动、按键、输入，以及找图 / 找色 / 找字后点击。HID **不能**做节点检索。界面识别用 [`Images.md`](./Images.md) / [`Ocr.md`](./Ocr.md)，或继续用无障碍读节点、只用 Hid 点滑。

坐标是像素，原点在屏幕左上角，包含状态栏。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 只做权限引导 |
| `tasks/*.js` | 实际点击、滑动、按键 |

## 前置

1. 蓝牙权限：`Access.hasBluetoothConnectionPermission()`，没有则 `requestBluetoothConnectionPermission()` 后 `System.exit()`。
2. `Hid.initBluetooth()` **不传参数**。脚本里没有 `context`。这一步只检查蓝牙是否打开，不连接板子。
3. 再 `Hid.connectAndWait()` 或 `Hid.ensureConnected()`。连上后坐标已经按当前屏幕真实宽高设好，**不要再写 `setXY`**。
4. 找图、找色、找字还要录屏：`Access.isMediaProjectionEnable()`。

```javascript
if (!Access.hasBluetoothConnectionPermission()) {
  Access.requestBluetoothConnectionPermission();
  System.exit();
}
Hid.initBluetooth();
if (!Hid.connectAndWait()) {
  console.log('未连接');
} else {
  Hid.tap(500, 800);
}
```

## 相近方法

| 需求 | 用 | 不用 |
|------|----|------|
| 返回 | 先 `back()`（按住约 40ms）。页面没回去再 `back1()`（按住 150ms） | 不要连着调用两次。返回值只表示指令发到板子，不表示页面已返回 |
| 屏幕宽高 | 不用设置 | 只有坐标不是这块屏幕时才 `setXY(宽, 高)`。参数不是点击位置 |
| 点一下 | `tap(x, y)` | 不要自己拼 `touchDown`，容易不抬起 |
| 直线滑 / 弧线滑 | `swipe` / `swipex` | |
| Android 键值 | `keyPress(code)`，回车 `66`，A `29`，退格 `67` | |
| HID 键盘用途号 | `keyPress_code(usage)`，a 是 `0x04`，回车 `0x28`，退格 `0x2A` | 不要把 Android 键值传给 `_code` |
| 退格 / 向后删除 | `key_del` 删光标前；`key_delete` 删光标后 | |
| 输入一串 | `type`。字母数字逐键，中文整段粘贴 | 中文不要 `key_abc` |
| 是否连上 | `isConnected()`。`getConnectState()` 与它相同 | |

## 连接

| 方法 | 签名 | 返回值 | 说明 |
|------|------|--------|------|
| initBluetooth | `initBluetooth()` | `boolean` | 蓝牙已开且有权限。不连接 |
| connect | `connect(autoconnect?, index?)` | `boolean` | 连上并可发指令。默认 `true, 0`。阻塞，最长约 25 秒。序号先在已配对的 `DeekeScript-*` 里取，没有再扫描 |
| connectAndWait | `connectAndWait(autoconnect?, index?, timeoutMs?)` | `boolean` | 连接并等到就绪。默认 `true, 0, 10000`。三个参数都可省略 |
| ensureConnected | `ensureConnected()` | `boolean` | 已连接直接 `true`，否则 `connectAndWait()` |
| isConnected | `isConnected()` | `boolean` | 指令通道是否还在 |
| getConnectState | `getConnectState()` | `boolean` | 同 `isConnected`，兼容旧脚本 |
| getConnectedDevices | `getConnectedDevices()` | `BluetoothDevice\|null` | 当前这一台，不是列表 |
| getName | `getName()` | `string` | 设备名，如 `DeekeScript-000001`。未连接为 `""` |
| disconnect | `disconnect()` | `boolean` | 断开本次连接。系统配对还在 |

第一次配对时手机上可能要点确认。`disconnect` 不会取消配对。

## 点击与滑动

| 方法 | 签名 | 返回值 | 说明 |
|------|------|--------|------|
| tap | `tap(x, y)` | `boolean` | 点一下，按下约 30ms。时长用 `setRnd` 改 |
| press | `press(x, y, durationMs?)` | `boolean` | 按住，默认 800ms。未连接会先连 |
| longClick | `longClick(x, y)` | `boolean` | `press(x, y, 800)` |
| doubleTap | `doubleTap(x, y)` | `boolean` | 同点两次，间隔 80ms |
| tapRandom | `tapRandom(x, y, rx?, ry?)` | `boolean` | 在 ±rx、±ry 内随机点。默认半径 5 |
| swipe | `swipe(x1, y1, x2, y2, step?, down_timeout?, up_timeout?, timeout?, up_down_times?)` | `boolean` | 直线。后 5 个可省略：step 20–51，按下后等 100–180，到终点等 100–180，步间隔 8–15，次数默认 1 |
| swipex | `swipex(x1, y1, x2, y2, radian?, ...)` | `boolean` | 弧线。`radian` 是中点偏移的像素，不是数学弧度，常用 10–100。其余同 `swipe` |
| touchDown | `touchDown(x, y)` | `boolean` | 按下不抬。之后必须 `touchMove` 或 `touchUp` |
| touchMove | `touchMove(x, y)` | `boolean` | 移动已按下的手指 |
| touchUp | `touchUp()` 或 `touchUp(x, y)` | `boolean` | 无参在最后一点抬起；有参在指定点抬起 |
| touchUp2 | `touchUp2()` | `boolean` | 连抬 3 次。一次抬起没松开时用 |

`swipe` 的 `up_down_times` 默认 1，只滑一次。大于 1 时，滑完后在终点再点 `次数 - 1` 下。

```javascript
Hid.tap(500, 800);
Hid.press(500, 800, 1000);
Hid.swipe(540, 1600, 540, 600);
Hid.swipex(540, 1600, 540, 600, 80);
```

## 系统键

都会作用在当前前台界面。调试时不要用 `home` / `recents` 把 DeekeScript 送走。

| 方法 | 签名 | 返回值 | 说明 |
|------|------|--------|------|
| back | `back()` | `boolean` | 返回，按住约 40ms。优先用这个 |
| back1 | `back1()` | `boolean` | 同一个返回键，按住 150ms。短按页面没回去时再用 |
| home | `home()` | `boolean` | 回桌面，约 40ms |
| recents | `recents()` | `boolean` | 最近任务，约 40ms |
| power | `power()` 或 `power(time)` | `boolean` | 无参约 80ms，亮屏或息屏。传入毫秒会按住那么久，过长会进关机界面 |
| volUp | `volUp()` | `boolean` | 音量加，约 40ms |
| volDown | `volDown()` | `boolean` | 音量减，约 40ms |

```javascript
Hid.back();
// 页面没有返回时再：
// Hid.back1();
```

## 键盘

`keyDown` / `keyUp` / `keyPress` 的 `code` 是 Android `KeyEvent` 键值。`keyDown_code` / `keyUp_code` / `keyPress_code` 的 `code` 是 HID 用途号，两套不能混用。

| 方法 | 签名 | 返回值 | 说明 |
|------|------|--------|------|
| keyDown | `keyDown(code)` | `boolean` | 按下不抬。不认识的键值返回 `false` |
| keyUp | `keyUp(code)` | `boolean` | 抬起 Android 键值 |
| keyPress | `keyPress(code)` | `boolean` | 点一下。回车 `66`，A `29`，退格 `67` |
| keyDown_code | `keyDown_code(usage)` | `boolean` | 按下 HID 用途号 |
| keyUp_code | `keyUp_code(usage)` | `boolean` | 抬起 HID 用途号 |
| keyPress_code | `keyPress_code(usage)` | `boolean` | 点一下用途号。a=`0x04`，回车=`0x28`，退格=`0x2A` |
| keyUpAll | `keyUpAll()` | `boolean` | 松开还按着的键 |
| key_select | `key_select()` | `boolean` | Ctrl+A |
| key_copy | `key_copy()` | `boolean` | Ctrl+C |
| key_paste | `key_paste()` | `boolean` | Ctrl+V。光标要在输入框 |
| key_cat | `key_cat()` | `boolean` | Ctrl+X |
| key_del | `key_del()` | `boolean` | 退格，删光标前 |
| key_delete | `key_delete()` | `boolean` | Delete，删光标后 |
| key_enter | `key_enter()` | `boolean` | 回车 |
| key_num | `key_num(n)` | `boolean` | 一个数字键，`n` 为 0–9。多位数用 `type` |
| key_abc | `key_abc(letter)` | `boolean` | 一个英文字母，大写带 Shift。只取第一个字符 |

## 输入

光标要已经在输入框里。未连接时会先 `ensureConnected()`。

| 方法 | 签名 | 返回值 | 说明 |
|------|------|--------|------|
| type | `type(text)` | `boolean` | 数字和字母逐键；换行是回车；空格和其他符号走粘贴。含中文则整段粘贴。空串返回 `true` |
| paste | `paste(text)` | `boolean` | 写入剪贴板再 Ctrl+V |
| clear | `clear()` | `boolean` | 全选后退格。退格失败再试 Delete |

```javascript
Hid.type('hello');
Hid.type('你好世界');
Hid.paste('粘贴内容');
Hid.clear();
```

## 图色与文字

未连接时会先 `ensureConnected()`。需要录屏。`ImageMatch` 含 `x` `y` `centerX` `centerY` `score` `width` `height`。`mode`：`contains`（默认）/ `exact` / `regex`。

| 方法 | 签名 | 返回值 | 说明 |
|------|------|--------|------|
| tapImage | `tapImage(templateFile, threshold?)` | `ImageMatch\|null` | 找到并点模板中心。阈值默认 `0.8` |
| pressImage | `pressImage(templateFile, durationMs?, threshold?)` | `ImageMatch\|null` | 找到后长按。时长默认 800，阈值默认 0.8 |
| tapColor | `tapColor(color, tolerance?)` | `Point\|null` | 点色块中心。`color` 支持 `#RRGGBB` / `rgb` / `rgba`。容差默认 0 |
| waitImage | `waitImage(templateFile, timeoutMs?, intervalMs?, threshold?)` | `ImageMatch\|null` | 只等图出现。默认 10000 / 500 / 0.8。超时 `null` |
| waitColor | `waitColor(color, timeoutMs?, intervalMs?, tolerance?)` | `Point\|null` | 只等颜色。默认 10000 / 500 / 0 |
| waitImageGone | `waitImageGone(templateFile, timeoutMs?, intervalMs?, threshold?)` | `boolean` | 图消失为 `true` |
| clickText | `clickText(keyword, timeoutMs?, mode?)` | `Rect\|null` | OCR 后点文字中心。默认超时 10000，`contains` |
| waitText | `waitText(keyword, timeoutMs?, intervalMs?, mode?)` | `object\|null` | 只等待。命中含 `text` `rect` `confidence` |
| waitTextGone | `waitTextGone(keyword, timeoutMs?, intervalMs?, mode?)` | `boolean` | 文字消失为 `true` |
| swipeUntilImage | `swipeUntilImage(x1, y1, x2, y2, templateFile, maxTimes?, threshold?)` | `ImageMatch\|null` | 按方向滑，直到出现图。默认最多 10 次、阈值 0.8。找到后不自动点击 |

```javascript
let m = Hid.tapImage('/sdcard/btn.png', 0.85);
let hit = Hid.waitText('加载完成', 10000);
let found = Hid.swipeUntilImage(500, 1500, 500, 500, '/sdcard/item.png', 8, 0.8);
if (found) Hid.tap(found.centerX, found.centerY);
```

## 设备与原始数据

| 方法 | 签名 | 返回值 | 说明 |
|------|------|--------|------|
| setXY | `setXY(width, height)` | `boolean` | 一般不调用。连接时已设为当前屏幕宽高，横竖屏变化也会自动更新。参数是宽高，不是点击坐标 |
| setRnd | `setRnd(minMs, maxMs)` | `boolean` | 只影响 `tap` 的按下时长。默认 30–30。不影响 `press` / `swipe` |
| setBattery | `setBattery(level)` | `boolean` | 改蓝牙列表里显示的电量 0–100，不是真实电量 |
| reg | `reg(key)` | `boolean` | 把注册字符串存进板子。业务脚本通常不用。空串表示清掉 |
| reboot | `reboot()` | `boolean` | 重启板子并断开，名称不变，之后要重新连接 |
| ver | `ver()` | `number` | 固件版本。失败为 `0`。不是 App 版本 |
| sendData | `sendData(str)` | `boolean` | 自定义通道，不会变成点击 |
| sendDataAwait | `sendDataAwait(str, time?)` | `boolean` | 同上，并等待板子确认。默认 1000ms |
| getData | `getData()` | `string` | 最近一次已收到的数据，不等待 |
| getData | `getData(time)` | `string` | 等待新数据。超时 `"超时"`，断开 `"连接已断开"` |
| waitFor | `waitFor()` / `waitFor(time)` / `waitFor(time, sleep)` | `string` | 等 **板子数据**，不是等界面。无参一直等。单参时间、间隔默认 200ms。`time` 为 0 表示一直等 |

## 注意

- 禁止 `Hid.initBluetooth(context)`。
- 禁止连接后再默认写 `Hid.setXY(Device.width(), Device.height())`。
- `waitFor` / `getData` 不是等待界面文字。等界面用 `waitText` / `waitImage`。
- 纯 HID 优先 `tapImage` / `waitImage` / `type` / `ensureConnected`，不要再手写截图加 `tap`。
- 相关：[`Access.md`](./Access.md)、[`Images.md`](./Images.md)、[`Ocr.md`](./Ocr.md)、[`Gesture.md`](./Gesture.md)。
