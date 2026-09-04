# SocketIoClient

Socket.IO 客户端。先 `getInstance`，再注册 `on`，最后 `connect()`。自动重连时更要手动 `disconnect()`。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 短连可用 |
| `tasks/*.js` | 长连放这里 |

## 方法

工厂：

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `SocketIoClient.getInstance(url, reconnect, timeout)` | `url {string}` 服务器地址；`reconnect {boolean}` 是否自动重连；`timeout {number}` 连接超时毫秒 | 客户端实例 | 创建实例 |

实例：

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `connect()` | 无 | `void` | 连接服务端。放在事件定义之后 |
| `disconnect()` | 无 | `void` | 关闭连接 |
| `isConnected()` | 无 | `boolean` | 是否已连接 |
| `setReconnect(reconnect)` | `reconnect {boolean}` | `void` | 设置是否自动重连 |
| `on(eventName, callback)` | `eventName {string}`；`callback(data)` | `void` | 监听服务端事件 |
| `emit(eventName, msg)` | `eventName {string}`；`msg` 消息 | `void` | 向服务端发事件 |
| `emit(eventName, msg, callback)` | 同上，带确认回调 | `void` | d.ts 重载：带 ack 回调的 emit |
| `emitWithAck(eventName, msg, callback)` | 同上 | `void` | 发事件并等服务器确认 |
| `off(eventName)` | `eventName {string}` | `void` | 移除该事件全部监听 |
| `off(eventName, callback)` | 指定回调 | `void` | 移除指定监听 |
| `off()` | 无 | `void` | d.ts：移除全部监听 |

内置事件名：`connect`、`connect_error`、`connect_timeout`、`error`、`message`。

## 最小片段

```javascript
let socketIOClient = SocketIoClient.getInstance('http://192.168.1.106:3000', true, 5000);

socketIOClient.on('connect_error', function (error) {
  console.error('连接错误:', error);
});

socketIOClient.on('connect', function () {
  console.log('是否连接成功：', socketIOClient.isConnected());
  socketIOClient.on('message', function (data) {
    console.log(data);
  });
  socketIOClient.emit('message', {
    name: 'DeekeScript',
    age: 3
  });
});

socketIOClient.connect();

setInterval(function () {
  console.log('当前线程不关闭');
}, 1000);
```

## 注意

- `connect()` 写在事件定义之后。
- 自动重连时必须手动 `disconnect()`。未关闭时，`Engines.closeAll()` 会关掉当前线程和子线程的客户端。
- 主线程退出会导致连接断开，任务里用 `setInterval` 保活。
- `emit` 可传对象（勿因 d.ts 标 `string` 而只传字符串）。
- 相关：[`WebSocket.md`](./WebSocket.md)、[`timer.md`](./timer.md)。
