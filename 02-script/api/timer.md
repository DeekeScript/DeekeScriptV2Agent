# Timer

全局定时器，API 接近浏览器：`setTimeout` / `setInterval` / `clearTimeout` / `clearInterval`。实现类似单线程事件循环。`page.js` 与 `tasks/*.js` 都能用。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 是 |
| `tasks/*.js` | 是 |

## 方法

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `setTimeout(callback, delay)` | `callback` 函数；`delay` 毫秒 | 定时器 id | 延时执行一次 |
| `setInterval(callback, delay)` | 同上 | 定时器 id | 按间隔循环执行 |
| `clearTimeout(id)` | `setTimeout` 返回的 id | — | 取消一次性定时任务 |
| `clearInterval(id)` | `setInterval` 返回的 id | — | 取消循环定时任务 |

## 最小片段

```javascript
let timer = setInterval(function () {
  console.log('每 2 秒执行一次');
}, 2000);

setTimeout(function () {
  clearInterval(timer);
}, 10000);
```

## 注意

- 不用时手动 `clearTimeout` / `clearInterval`。未手动关闭时，`Engines.closeAll()` 会关掉当前线程和子线程的定时器。
- 主脚本关闭后，该脚本上的定时器会自动关闭。
- 长连接（WebSocket、通知监听、前台服务）常靠 `setInterval` 保持线程不退出。
- 回调写成 `function`，不要用箭头函数。
