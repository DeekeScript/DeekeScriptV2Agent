function confirmOpen(content, openSetting) {
  Dialogs.confirm('提示', content, function (ok) {
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
    Dialogs.show('提示', '没有可执行的脚本文件');
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
