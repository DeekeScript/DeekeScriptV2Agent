# Promise

Rhino 环境下的 `Promise`。**没有 `async` / `await`**。用 `then` 接结果。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 是 |
| `tasks/*.js` | 是 |

## 用法

| 成员 | 说明 |
|------|------|
| `new Promise(function (resolve, reject) { ... })` | 构造。成功调 `resolve(value)`，失败调 `reject(reason)` |
| `promise.then(onFulfilled, onRejected)` | 两个回调都是 `function` |

不要编造未在本卡列出的 Promise API（如 `Promise.all`）。

## 最小片段

```javascript
let promise = new Promise(function (resolve, reject) {
  setTimeout(function () {
    resolve('成功');
  }, 1000);
});

promise.then(function (value) {
  console.log(value);
}, function (reason) {
  console.log(reason);
});
```

## 注意

- 禁止 `async function`、`await`。生成代码用 `then` 或直接同步写法。
- executor 和 `then` 回调都写 `function`，不要箭头函数。
- `page.js` 里不要用 `System.sleep` 堵 UI；延时用 `setTimeout`。任务脚本里同步 `System.sleep` 更常见。
- 相关：[`timer.md`](./timer.md)、[`donts.md`](../../04-cheatsheets/donts.md)。
