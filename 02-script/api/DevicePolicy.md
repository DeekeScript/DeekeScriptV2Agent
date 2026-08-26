# DevicePolicy

Device Owner 模式下的设备策略：是否 DO、立即锁屏、亮屏。未设为 Device Owner 时方法返回失败。开启步骤见 [`do-mode.md`](./do-mode.md)。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 可检查状态 |
| `tasks/*.js` | 是 |

## 前置

应用必须已是 Device Owner。先 `DevicePolicy.isDeviceOwner()`。`wakeScreen()` 还需要 Manifest 里的 `WAKE_LOCK`（打包模板已处理则不必自己写）。

## 方法

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `isDeviceOwner()` | 无 | `boolean` | 当前应用是否为 Device Owner |
| `lockNow()` | 无 | `boolean` | 立即锁屏/息屏 |
| `wakeScreen()` | 无 | `boolean` | 亮屏/唤醒 |

## 最小片段

```javascript
if (!DevicePolicy.isDeviceOwner()) {
  console.log('当前应用不是 Device Owner');
} else {
  DevicePolicy.lockNow();
  System.sleep(1000);
  DevicePolicy.wakeScreen();
}
```

## 注意

- 不是 DO 时 `lockNow` 返回 `false`，不要当成成功。
- DO 权限只能恢复出厂设置移除，见 [`do-mode.md`](./do-mode.md)。
