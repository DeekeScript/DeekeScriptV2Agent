# 权限：页面启动与脚本自检

无障碍、悬浮窗是运行自动化的默认门槛。页面点「运行」时检查一次；任务脚本开头再检查一次。其它权限按业务调对应 `ensureXxx`。

API：[`Access.md`](api/Access.md)、[`Dialogs.md`](api/Dialogs.md)、[`Engines.md`](api/Engines.md)。

## 用法（先读这节）

从页面启动：

```javascript
let permission = require('../../common/permission.js');

Page({
  onRun: function () {
    permission.runScript('tasks/xxx.js');
  }
});
```

脚本内自检：

```javascript
let permission = require('../common/permission.js');

if (!permission.ensureRun()) {
  // 未开启，已弹窗引导
} else {
  // 业务
}
```

## 规则

- `ensureRun()` **只检查无障碍 + 悬浮窗**。都开了返回 `true`。
- `Dialogs.confirm` 是异步回调：`ensureRun` / `ensureXxx` 弹出后立刻返回 `false`。调用方必须 `if (!permission.ensureRun())` 后停止。
- 不要把 Demo 的 `hint()` 写进工程。
- 图色 / 通知 / 媒体 / 文件 / 位置 / 蓝牙：用到再调对应 `ensureXxx`。
- 已被永久拒绝的权限，走设置页，不要反复 `requestXxx`。
- `runScript(jsFile)` 的路径相对**项目根**。

## 生成文件

需要权限模块时：把 [`snippets/common-permission.js`](snippets/common-permission.js) **整文件复制**为工程里的 `common/permission.js`。不要改导出表结构。

导出：`ensureRun`、`runScript`、`ensureAccessibility`、`ensureFloat`、`ensureScreenCapture`、`ensureBackgroundAlert`、`ensureNotification`、`ensureMedia`、`ensureStorage`、`ensureLocation`、`ensureBluetooth`。

任务骨架见 [`task-template.md`](task-template.md)。
