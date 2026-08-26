# WebSocket

原生 WebSocket 客户端。用 `new WebSocket(url)` 创建实例，事件用实例字段赋值。不用时手动 `close()`。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 是（短连可以；长连建议放 `tasks/*.js`） |
| `tasks/*.js` | 是 |

## 方法 / 字段

静态：

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `WebSocket.closeAll()` | 无 | `void` | 关闭所有 WebSocket 客户端 |

实例（`new WebSocket(url)`）：

| 成员 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `onOpen` | 无 | — | 连接成功后执行 |
| `onMessage` | `data {string}` | — | 收到消息 |
| `onClose` | `code {number}`，`reason {string}` | — | 连接关闭 |
| `onError` | `errorMsg {string}` | — | 出错 |
| `send(data)` | `data {string}` | `void` | 发送文本 |
| `close()` | 无 | `void` | 关闭当前连接 |

## 最小片段

```javascript
let client = new WebSocket('ws://192.168.0.100:8080');

client.onMessage = function (msg) {
  console.log('消息来了' + msg);
};

client.onOpen = function () {
  client.send('测试');
};

client.onClose = function (code, reason) {
  console.log('关闭了', code, reason);
};

client.onError = function (errorMsg) {
  console.log('出错了：' + errorMsg);
};

setInterval(function () {
  console.log('当前线程不关闭');
}, 1000);
```

## 注意

- 主线程一结束，WebSocket 也会关掉。任务脚本里用 `setInterval` 保活。
- 不用时手动 `close()`。未关闭时，`Engines.closeAll()` 会关掉当前线程和子线程的 WebSocket。
- `send` 只传字符串。
- 相关：[`timer.md`](./timer.md)、[`SocketIo.md`](./SocketIo.md)。
