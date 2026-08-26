# DeviceApp

Device Owner 下的应用管理：静默安装/卸载、隐藏应用、权限策略、授予运行时权限。未设 DO 时返回失败。开启见 [`do-mode.md`](./do-mode.md)。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 可查询 |
| `tasks/*.js` | 是 |

## 前置

`DevicePolicy.isDeviceOwner()` 为 true。

## 常量

权限策略：

| 常量 | 值 | 说明 |
|------|----|------|
| `DeviceApp.PERMISSION_POLICY_PROMPT` | `0` | 提示用户 |
| `DeviceApp.PERMISSION_POLICY_AUTO_GRANT` | `1` | 自动授予 |
| `DeviceApp.PERMISSION_POLICY_AUTO_DENY` | `2` | 自动拒绝 |

授予状态：

| 常量 | 值 | 说明 |
|------|----|------|
| `DeviceApp.PERMISSION_GRANT_STATE_DEFAULT` | `0` | 默认 |
| `DeviceApp.PERMISSION_GRANT_STATE_DENIED` | `1` | 已拒绝 |
| `DeviceApp.PERMISSION_GRANT_STATE_GRANTED` | `2` | 已授予 |

## 方法

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `installPackage(packageUri)` | 路径或 `file:///...` | `boolean` | 静默安装。true 表示会话已创建（异步） |
| `uninstallPackage(packageName)` | 包名 | `boolean` | 静默卸载。true 表示请求已提交 |
| `setApplicationHidden(packageName, hidden)` | 包名、是否隐藏 | `boolean` | 从启动器隐藏，不卸载 |
| `isApplicationHidden(packageName)` | 包名 | `boolean` | 是否已隐藏 |
| `setPermissionPolicy(policy)` | 上面三个常量之一 | `boolean` | 设置权限策略 |
| `grantRuntimePermission(packageName, permission)` | 包名、权限名如 `"android.permission.CAMERA"` | `boolean` | 授予运行时权限 |
| `isPermissionGranted(packageName, permission)` | 同上 | `boolean` | 是否已授予 |

## 最小片段

```javascript
if (!DevicePolicy.isDeviceOwner()) {
  console.log('不是 Device Owner');
} else {
  let ok = DeviceApp.installPackage('/sdcard/app.apk');
  console.log('安装会话', ok);
  DeviceApp.grantRuntimePermission('com.example.app', 'android.permission.CAMERA');
}
```

## 注意

- 安装/卸载是异步的，`true` 不代表已经装完。
- 权限字符串用 Android 全名，不要编造简称。
- 相关：[`DevicePolicy.md`](./DevicePolicy.md)、[`apk.md`](./apk.md)。
