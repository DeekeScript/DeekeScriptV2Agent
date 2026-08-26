# Notification

监听其它 App 发出的系统通知。全局对象名是 `NotificationBridge`。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 权限引导可以 |
| `tasks/*.js` | 监听放任务脚本并保活 |

## 前置权限

通知读取权限：

```javascript
let hasAccess = Access.hasNotificationAccess();
if (!hasAccess) {
  Access.requestNotificationAccess();
  System.exit();
}
```

## 方法

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `startService()` | 无 | `void` | 启动通知监听服务 |
| `startListening(onNotification, onNotificationRemoved)` | 收到通知回调、通知关闭回调。参数均为 `(packageName, title, text)` | `void` | 开始监听 |
| `stopService()` | 无 | `void` | 停止服务 |

## 最小片段

```javascript
if (!Access.hasNotificationAccess()) {
  Access.requestNotificationAccess();
  System.exit();
}

NotificationBridge.startService();
NotificationBridge.startListening(function (packageName, title, text) {
  console.log('收到通知', packageName, title, text);
}, function (packageName, title, text) {
  console.log('通知已关闭', packageName, title, text);
});

setInterval(function () {
  console.log('正在监听中...');
}, 10000);
```

## 注意

- 先申请权限，再 `startService` + `startListening`。
- 主线程退出监听也会停，用 `setInterval` 保活。
- 回调用 `function`，不要箭头函数。
- 相关：[`Access.md`](./Access.md)、[`timer.md`](./timer.md)。
