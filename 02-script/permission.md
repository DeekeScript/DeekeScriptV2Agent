# 权限：页面启动与脚本自检

无障碍、悬浮窗是运行自动化的默认门槛。页面点「运行」时检查一次；任务脚本开头再检查一次。其它权限（录屏、通知、媒体、文件、位置、蓝牙）按业务调用对应 `ensureXxx`。

API 见 [`api/Access.md`](api/Access.md)、[`api/Dialogs.md`](api/Dialogs.md)、[`api/Engines.md`](api/Engines.md)。

## 从页面启动

```javascript
let permission = require('../../common/permission.js');

Page({
  onRun() {
    permission.runScript('tasks/xxx.js');
  }
});
```

`runScript` 内部先 `ensureRun()`，通过后 `Engines.executeScript(jsFile)`。`jsFile` 相对项目根，例如 `tasks/xxx.js`。

## 脚本内自检

```javascript
let permission = require('../common/permission.js');

if (!permission.ensureRun()) {
  // 未开启，已弹窗引导，结束本次执行
} else {
  // 业务
}
```

## 默认检查

`ensureRun()` **只检查无障碍 + 悬浮窗**。缺哪项就提示哪项；都开了返回 `true`。弹窗回调里先开无障碍设置，已开无障碍再开悬浮窗设置。

`Dialogs.confirm` 是回调，`ensureRun` / `ensureXxx` 在弹出后立刻返回 `false`。调用方必须 `if (!permission.ensureRun())` 后停止。

## 可复制：`common/permission.js`

不要把 `hint()` 写进工程。需要图色、通知等时再调对应 `ensureXxx`。

```javascript
function confirmOpen(content, openSetting) {
  Dialogs.confirm('温馨提示', content, function (ok) {
    if (ok) {
      openSetting();
    }
  });
  return false;
}

function ensureAccessibility() {
  if (Access.isAccessibilityServiceEnabled()) {
    return true;
  }
  return confirmOpen('请开启无障碍权限', function () {
    Access.openAccessibilityServiceSetting();
  });
}

function ensureFloat() {
  if (Access.isFloatWindowsEnabled()) {
    return true;
  }
  return confirmOpen('请开启悬浮窗权限', function () {
    Access.openFloatWindowsSetting();
  });
}

function ensureScreenCapture() {
  if (Access.isMediaProjectionEnable()) {
    return true;
  }
  return confirmOpen('请开启屏幕截图（录屏）权限', function () {
    Access.openMediaProjectionSetting();
  });
}

function ensureBackgroundAlert() {
  if (Access.isBackgroundAlertEnabled()) {
    return true;
  }
  return confirmOpen('请开启后台弹窗权限', function () {
    Access.openBackgroundAlertSetting();
  });
}

function ensureNotification() {
  if (Access.hasNotificationAccess()) {
    return true;
  }
  return confirmOpen('请开启通知读取权限', function () {
    Access.requestNotificationAccess();
  });
}

function ensureMedia() {
  if (Access.hasMediaReadPermission()) {
    return true;
  }
  if (Access.isMediaPermissionPermanentlyDenied()) {
    return confirmOpen('媒体权限已被禁止，请在设置中手动开启', function () {
      Access.openPermissionSettings();
    });
  }
  Access.requestMediaPermissions();
  return false;
}

function ensureStorage() {
  if (Access.hasStoragePermission()) {
    return true;
  }
  if (Access.isStoragePermissionPermanentlyDenied()) {
    return confirmOpen('文件权限已被禁止，请在设置中手动开启', function () {
      Access.openPermissionSettings();
    });
  }
  Access.requestStoragePermission();
  return false;
}

function ensureLocation() {
  if (Access.hasLocationPermission()) {
    return true;
  }
  if (Access.isLocationPermissionPermanentlyDenied()) {
    return confirmOpen('位置权限已被禁止，请在设置中手动开启', function () {
      Access.openPermissionSettings();
    });
  }
  Access.requestLocationPermissions();
  return false;
}

function ensureBluetooth() {
  if (Access.hasBluetoothConnectionPermission()) {
    return true;
  }
  if (Access.isBluetoothPermissionPermanentlyDenied()) {
    return confirmOpen('蓝牙权限已被禁止，请在设置中手动开启', function () {
      Access.openBluetoothPermissionSettings();
    });
  }
  Access.requestBluetoothConnectionPermission();
  return false;
}

function ensureRun() {
  var missing = [];
  if (!Access.isAccessibilityServiceEnabled()) {
    missing.push('无障碍权限');
  }
  if (!Access.isFloatWindowsEnabled()) {
    missing.push('悬浮窗权限');
  }
  if (!missing.length) {
    return true;
  }
  return confirmOpen('请先开启' + missing.join('、'), function () {
    if (!Access.isAccessibilityServiceEnabled()) {
      Access.openAccessibilityServiceSetting();
      return;
    }
    Access.openFloatWindowsSetting();
  });
}

function runScript(jsFile) {
  if (!jsFile) {
    Dialogs.show('温馨提示', '没有可执行的脚本文件');
    return false;
  }
  if (!ensureRun()) {
    return false;
  }
  Engines.executeScript(jsFile);
  return true;
}

module.exports = {
  ensureRun: ensureRun,
  runScript: runScript,
  ensureAccessibility: ensureAccessibility,
  ensureFloat: ensureFloat,
  ensureScreenCapture: ensureScreenCapture,
  ensureBackgroundAlert: ensureBackgroundAlert,
  ensureNotification: ensureNotification,
  ensureMedia: ensureMedia,
  ensureStorage: ensureStorage,
  ensureLocation: ensureLocation,
  ensureBluetooth: ensureBluetooth
};
```

## 注意

- 无障碍、悬浮窗：官方视为必须权限；工程里仍要显式检查，不要假设系统已弹过。
- 后台弹窗、图色（录屏）、通知、媒体、文件、位置、蓝牙：可选。用到再 `ensureXxx`。
- 已被永久拒绝的运行时权限，走设置页（`openPermissionSettings` / `openBluetoothPermissionSettings`），不要反复 `requestXxx`。
- 授权后让用户回到页面再启动脚本。任务骨架见 [`task-template.md`](task-template.md)。
