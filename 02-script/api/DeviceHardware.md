# DeviceHardware

Device Owner 下控制截屏、锁屏界面、状态栏。未设 DO 时返回失败。开启见 [`do-mode.md`](./do-mode.md)。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 可调用 |
| `tasks/*.js` | 是 |

## 前置

`DevicePolicy.isDeviceOwner()` 为 true。

- `setScreenCaptureDisabled`：API 28（Android 9.0）+
- `setStatusBarDisabled`：API 26（Android 8.0）+
- `setKeyguardDisabled`：需要 Device Owner 或 Profile Owner

## 方法

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `setScreenCaptureDisabled(disabled)` | `true` 禁用截屏 | `boolean` | 禁用后用户无法用系统快捷键截屏 |
| `setKeyguardDisabled(disabled)` | `true` 禁用锁屏界面 | `boolean` | 可能仍需解锁 |
| `setStatusBarDisabled(disabled)` | `true` 隐藏状态栏 | `boolean` | 禁用状态栏 |

## 最小片段

```javascript
if (DevicePolicy.isDeviceOwner()) {
  DeviceHardware.setScreenCaptureDisabled(true);
  DeviceHardware.setStatusBarDisabled(true);
} else {
  console.log('不是 Device Owner');
}
```

## 注意

- 版本不够或不是 DO 时返回 `false`。
- 禁用截屏会影响 [`Images.capture()`](./Images.md)，Kiosk 场景要想清楚。
- 相关：[`DeviceKiosk.md`](./DeviceKiosk.md)。
