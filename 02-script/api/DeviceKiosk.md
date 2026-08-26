# DeviceKiosk

Device Owner 下的锁定任务（Lock Task / Kiosk）：设置允许进入锁定任务的包名列表。未设 DO 时返回失败。开启见 [`do-mode.md`](./do-mode.md)。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 可查询 |
| `tasks/*.js` | 是 |

## 前置

`DevicePolicy.isDeviceOwner()` 为 true。

## 方法

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `setLockTaskPackages(packages)` | 包名字符串数组 | `boolean` | 设置可进入锁定任务模式的应用 |
| `getLockTaskPackages()` | 无 | `string[]` 或 `null` | 当前列表，失败为 `null` |
| `isLockTaskModeEnabled()` | 无 | `boolean` | **是否已配置锁定任务应用**，不是“当前正处在锁定任务界面” |

## 最小片段

```javascript
if (!DevicePolicy.isDeviceOwner()) {
  console.log('不是 Device Owner');
} else {
  let packages = ['com.example.app', 'com.example.kiosk'];
  DeviceKiosk.setLockTaskPackages(packages);
  console.log('已配置', DeviceKiosk.isLockTaskModeEnabled());
}
```

## 注意

- `isLockTaskModeEnabled()` 只表示列表已配置。
- 配合 [`DeviceHardware.md`](./DeviceHardware.md) 禁用状态栏/锁屏，用于展陈机。
- 相关：[`DevicePolicy.md`](./DevicePolicy.md)。
