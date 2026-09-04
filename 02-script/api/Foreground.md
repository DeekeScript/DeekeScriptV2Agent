# Foreground

前台服务，用于后台常驻任务。全局对象名是 `ForegroundServiceBridge`。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 可以启动，常驻逻辑仍建议在任务脚本 |
| `tasks/*.js` | 是 |

## 方法

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `setContent(title, content)` | 标题、描述 | `void` | 设置通知栏文案 |
| `register(func)` | 服务启动后要执行的函数 | `void` | **必须在 `startService` 之前调用** |
| `startService()` | 无 | `void` | 启动前台服务 |
| `stopService()` | 无 | `void` | 停止服务 |

## 最小片段

```javascript
ForegroundServiceBridge.setContent('测试', '前台服务');
ForegroundServiceBridge.register(function () {
  console.log('前台服务启动成功');
  setInterval(function () {
    console.log('正在执行任务...');
  }, 3000);
});
ForegroundServiceBridge.startService();

setInterval(function () {
  console.log('主线程保活');
}, 10000);
```

## 注意

- `register` 必须在 `startService` 之前。
- 主线程仍要保活，否则脚本结束服务也会停。
- Android 9+ 后台播放等也依赖前台服务，见 [`Audio.md`](./Audio.md) 的 `hasForegroundServicePermission`。
- 停服务调用 `ForegroundServiceBridge.stopService()`，不要写成 `NotificationBridge.stopService()`。
