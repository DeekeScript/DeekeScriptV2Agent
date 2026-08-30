# DO 模式

Device Owner（设备所有者）是 Android 最高级管理权限：静默安装卸载、管其它应用权限、锁屏、禁截屏、Kiosk。**DeekeScript 本身和打包后的 App 都可以设为 Device Owner。**

相关 API：[`DevicePolicy.md`](./DevicePolicy.md)、[`DeviceApp.md`](./DeviceApp.md)、[`DeviceHardware.md`](./DeviceHardware.md)、[`DeviceKiosk.md`](./DeviceKiosk.md)。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 检查 `isDeviceOwner`、展示状态 |
| `tasks/*.js` | 实际管理操作 |

## 前置（必须全部满足）

1. 设备未激活，或先**恢复出厂设置**。已激活无法设置 DO。
2. Android 8.0（API 26）+。
3. 每台设备只能有一个 Device Owner。
4. 删除全部用户账户（Google / 小米 / 华为等）。多用户、访客、应用双开也要关掉。
5. 开启 USB 调试，电脑能 `adb`。
6. **权限一旦授予，只能恢复出厂设置移除。**

Receiver（打包 App 把包名换成自己的，Receiver 类名不变）：

- 包名示例：`com.android.deeke.script`（开发器）或 `deekeScript.json` 里的 `packageName`
- Receiver：`top.deeke.script.service.AdminReceiver`

```bash
adb shell dpm set-device-owner \
com.android.deeke.script/top.deeke.script.service.AdminReceiver
```

成功输出类似：`Success: Device owner set to package ...`

小米：可能要先登录小米账号完成 adb 授权，执行前再退出账号。

## 能力对照

| 功能 | 普通应用 | Device Owner |
|------|----------|--------------|
| 安装 / 卸载 | 需用户确认 | 可静默 |
| 隐藏应用 | 不支持 | 支持 |
| 管其它应用权限 | 不支持 | 支持 |
| 锁屏 / 禁截屏 / Kiosk | 不支持或有限 | 支持 |

## 最小片段

```javascript
if (DevicePolicy.isDeviceOwner()) {
  console.log('Device Owner 已设置');
  DevicePolicy.lockNow();
  System.sleep(1000);
  DevicePolicy.wakeScreen();
} else {
  console.log('未设置 Device Owner，不要调用 DeviceApp / DeviceHardware / DeviceKiosk');
}
```

## 注意

- 生成脚本前先判断 `isDeviceOwner()`，不要对普通用户设备默认调用 DO API。
- 测试机上做。不要在个人主力机开启。
- 这不是 Hook，也不是无障碍。V2 工程不要写 `hooks`，见 [`no-hook.md`](./no-hook.md)。
