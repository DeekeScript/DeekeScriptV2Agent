# Hid

蓝牙 HID 硬件：点击、滑动、按键、文本输入，以及找图/找色/找字后点击等高层封装。HID **不能**做节点检索；界面识别用图色（`Images`）或无障碍。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 权限引导可以 |
| `tasks/*.js` | 实际 HID 操作在任务里 |

## 前置权限与硬件

1. 蓝牙：`Access.hasBluetoothConnectionPermission()`；再 `Hid.initBluetooth(context)`。
2. 图色联动还需录屏：`Access.isMediaProjectionEnable()`，见 [`Images.md`](./Images.md)。

```javascript
if (!Access.hasBluetoothConnectionPermission()) {
  Access.requestBluetoothConnectionPermission();
  System.exit();
}
Hid.initBluetooth(context);
```

## 触控

### tap / press / longClick / doubleTap / tapRandom

```javascript
Hid.tap(500, 800);
Hid.press(500, 800, 1000);
Hid.longClick(500, 800);
Hid.doubleTap(540, 960);
Hid.tapRandom(500, 800, 10, 10);
```

### swipe / swipex / touchDown / touchMove / touchUp

```javascript
Hid.swipe(10, 1000, 1000, 1050);
Hid.swipex(100, 800, 900, 800, 40);
Hid.touchDown(500, 800);
Hid.touchMove(600, 900);
Hid.touchUp(600, 900);
```

## 图色联动（需 MediaProjection）

`ImageMatch`：`x` `y` `centerX` `centerY` `score` `width` `height`。

### tapImage / pressImage

```javascript
let m = Hid.tapImage('/sdcard/btn.png', 0.85);
Hid.pressImage('/sdcard/icon.png', 1000, 0.8);
```

### tapColor

```javascript
let p = Hid.tapColor('#3480F8', 10);
```

### waitImage / waitColor / waitImageGone

```javascript
Hid.waitImage('/sdcard/ok.png', 10000);
Hid.waitColor('#FF0000', 8000, 500, 5);
Hid.waitImageGone('/sdcard/loading.png', 10000);
```

### clickText / waitText / waitTextGone

`mode`：`contains`（默认）/ `exact` / `regex`。

```javascript
Hid.clickText('登录', 5000);
Hid.clickText('确定', 5000, 'exact');
let hit = Hid.waitText('加载完成', 10000);
Hid.waitTextGone('加载中', 8000);
```

### swipeUntilImage

```javascript
let m = Hid.swipeUntilImage(500, 1500, 500, 500, '/sdcard/item.png', 8, 0.8);
if (m) Hid.tap(m.centerX, m.centerY);
```

## 文本输入

```javascript
Hid.type('hello');
Hid.type('你好世界');
Hid.paste('粘贴内容');
Hid.clear();
Hid.key_enter();
Hid.key_num(1);
Hid.key_abc('a');
```

## 连接

```javascript
Hid.connect(true, 0);
Hid.connectAndWait(true, 0, 10000);
Hid.ensureConnected();
console.log(Hid.isConnected());
console.log(Hid.getName());
Hid.disconnect();
```

## 系统键（摘要）

```javascript
Hid.home();
Hid.back();
Hid.recents();
Hid.volUp();
Hid.volDown();
```

## 最小片段

```javascript
Hid.initBluetooth(context);
Hid.ensureConnected();
Hid.tapImage('/sdcard/btn.png', 0.85);
Hid.type('你好世界');
Hid.waitText('完成', 10000);
```

## 注意

- HID 不做 `UiSelector`。纯 HID 用 [`Images.md`](./Images.md) + 上表图色联动。
- `waitFor` 是等 **BLE 数据**，不是等 UI。
- 相关：[`Access.md`](./Access.md)、[`Images.md`](./Images.md)。
