# Events

统一事件总线：按键、屏幕亮灭、无障碍事件、窗口切换；可用 `emit` 派发自定义事件。全局对象名是 `Events`。按键需无障碍已连接，且服务配置允许过滤按键事件。脚本结束会自动清理监听。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 可以，长监听建议放任务 |
| `tasks/*.js` | 是（主场景） |

## 前置

- 无障碍已开启（多数事件依赖无障碍回调）。
- 监听按键前先 `Events.observeKey()`；需服务端开启 filter key events（API 30+ 配置中已开）。

## 方法

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `observeKey()` | 无 | `void` | 开始观察按键 |
| `ignoreKey()` | 无 | `void` | 停止观察按键 |
| `isObservingKey()` | 无 | `boolean` | 是否正在观察按键 |
| `on(event, callback)` | 事件名、回调 | `void` | 持续监听（系统或自定义名） |
| `once(event, callback)` | 同上 | `void` | 只触发一次 |
| `emit(event, ...args)` | 事件名、可选参数 | `void` | 派发事件，参数原样传给回调 |
| `off(event)` | 事件名 | `void` | 移除该事件全部监听 |
| `off(event, callback)` | 事件名、回调 | `void` | 移除指定回调 |
| `removeAllListeners()` | 无 | `void` | 清空全部监听并停止按键观察 |

## 事件名

| 事件 | 回调参数 | 说明 |
|------|----------|------|
| `key_down` | `(event, keyCode)` | 键按下 |
| `key_up` | `(event, keyCode)` | 键抬起 |
| `key` | `(event, keyCode)` | 按下与抬起都会触发 |
| `screen_on` | 无参 | 亮屏 |
| `screen_off` | 无参 | 灭屏 |
| `accessibility` | `(obj, eventType)` | 无障碍事件 |
| `window_changed` | `(obj)` | 窗口状态变化 |
| 自定义名 | `(...args)` | 用 `Events.emit` 自行派发 |

按键 `event` 对象字段：`keyCode`、`action`、`key`（如 `volume_up` / `volume_down` / `back`）、`repeatCount`。

## 最小片段

```javascript
Events.observeKey();
Events.on('key_down', function (e, keyCode) {
  console.log(e.key, keyCode, e.repeatCount);
});

Events.on('screen_off', function () {
  console.log('屏幕灭了');
});

Events.on('window_changed', function (obj) {
  console.log(obj.packageName, obj.className);
});

// 自定义事件
Events.on('task_done', function (name, ok) {
  console.log(name, ok);
});
Events.emit('task_done', 'login', true);

setInterval(function () {
  console.log('监听中');
}, 10000);
```

## 注意

- 未 `observeKey()` 时不会派发按键事件。
- 事件名会规范化：去首尾空白、转小写、`-` 变 `_`（`Task-Done` 与 `task_done` 相同）。
- 主线程退出监听也会停，用 `setInterval` 保活；脚本结束会自动清理。
- 相关：[`Access.md`](./Access.md)、[`timer.md`](./timer.md)、[`Notification.md`](./Notification.md)。
