# Access

检查与申请权限。无障碍、悬浮窗是自动化默认门槛；其它按需申请。封装用法见 [`../permission.md`](../permission.md)。

## 可用上下文

- **page.js**：启动前检查，引导去系统设置。
- **tasks.js**：开头再 `ensureRun` / `ensureXxx`，未开则结束。

## 方法

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| isAccessibilityServiceEnabled | `isAccessibilityServiceEnabled()` | 无 | `boolean` | 无障碍是否已开。必须 |
| isFloatWindowsEnabled | `isFloatWindowsEnabled()` | 无 | `boolean` | 悬浮窗是否已开。必须。未开则项目悬浮球创建不了 |
| isBackgroundAlertEnabled | `isBackgroundAlertEnabled()` | 无 | `boolean` | 后台弹窗。部分机型从后台打开其它 App 需要 |
| isMediaProjectionEnable | `isMediaProjectionEnable()` | 无 | `boolean` | 录屏/截图（图色） |
| openAccessibilityServiceSetting | `openAccessibilityServiceSetting()` | 无 | `void` | 打开无障碍设置 |
| openFloatWindowsSetting | `openFloatWindowsSetting()` | 无 | `void` | 打开系统悬浮窗设置，用户自己开 |
| openBackgroundAlertSetting | `openBackgroundAlertSetting()` | 无 | `void` | 打开后台弹窗设置 |
| openMediaProjectionSetting | `openMediaProjectionSetting()` | 无 | `void` | 打开录屏/截图设置 |
| requestNotificationAccess | `requestNotificationAccess()` | 无 | `void` | 申请通知读取 |
| hasNotificationAccess | `hasNotificationAccess()` | 无 | `boolean` | 是否有通知读取权限 |
| hasMediaReadPermission | `hasMediaReadPermission()` | 无 | `boolean` | 是否有媒体读取（相册/视频/音频等） |
| requestMediaPermissions | `requestMediaPermissions()` | 无 | `void` | 申请媒体权限（按 Android 版本自动选权限） |
| openPermissionSettings | `openPermissionSettings()` | 无 | `void` | 打开本应用权限设置页 |
| isMediaPermissionPermanentlyDenied | `isMediaPermissionPermanentlyDenied()` | 无 | `boolean` | 媒体权限被永久拒绝（不再询问） |
| hasStoragePermission | `hasStoragePermission()` | 无 | `boolean` | 文件读写权限 |
| requestStoragePermission | `requestStoragePermission()` | 无 | `void` | 申请文件权限 |
| isStoragePermissionPermanentlyDenied | `isStoragePermissionPermanentlyDenied()` | 无 | `boolean` | 文件权限被永久拒绝 |
| hasLocationPermission | `hasLocationPermission()` | 无 | `boolean` | 位置权限（`Device.getLocation` 需要） |
| requestLocationPermissions | `requestLocationPermissions()` | 无 | `void` | 申请精确/粗略位置 |
| isLocationPermissionPermanentlyDenied | `isLocationPermissionPermanentlyDenied()` | 无 | `boolean` | 位置权限被永久拒绝 |
| hasBluetoothConnectionPermission | `hasBluetoothConnectionPermission()` | 无 | `boolean` | 蓝牙连接权限（Hid）。Android 12 以下无需申请 |
| requestBluetoothConnectionPermission | `requestBluetoothConnectionPermission()` | 无 | `void` | 申请蓝牙 |
| isBluetoothPermissionPermanentlyDenied | `isBluetoothPermissionPermanentlyDenied()` | 无 | `boolean` | 蓝牙权限被永久拒绝 |
| openBluetoothPermissionSettings | `openBluetoothPermissionSettings()` | 无 | `void` | 打开蓝牙相关设置 |

## 最小片段

```javascript
if (!Access.isAccessibilityServiceEnabled()) {
  Dialogs.confirm('温馨提示', '请开启无障碍权限', function (ok) {
    if (ok) {
      Access.openAccessibilityServiceSetting();
    }
  });
}
```

## 注意

- 工程默认检查无障碍 + 悬浮窗，不要假设系统已自动弹过。
- 永久拒绝时打开设置页，不要反复 `requestXxx`。
- 授权后回到页面再启动脚本。索引见 [`INDEX.md`](INDEX.md)。
