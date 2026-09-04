# Threads

创建和管理线程。优先用 [`timer.md`](./timer.md) 的 `setTimeout` / `setInterval`，或 [`Engines.md`](./Engines.md) 起子脚本；`Threads` 易有竞态，非必要不要生成。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 可用，慎用 |
| `tasks/*.js` | 可用，慎用 |

## 方法

`Threads`：

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `create(runnable)` | 函数，或带 `run` 方法的对象 | `ThreadWrapper` | 创建线程。使用线程池时任务会自动启动 |
| `sleep(millis)` | 毫秒 | `void` | 休眠当前线程。被中断抛 `InterruptedException` |
| `yield()` | 无 | `void` | 让出 CPU 时间片 |
| `currentThread()` | 无 | `ThreadWrapper` | 当前线程 |

`ThreadWrapper`：

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `start()` | 无 | `void` | 启动。线程池场景通常不必调 |
| `join()` | 无 | `void` | 等待结束 |
| `join(millis)` | 最多等待毫秒 | `void` | 超时后继续 |
| `interrupt()` | 无 | `void` | 中断 |
| `isAlive()` | 无 | `boolean` | 是否仍在运行 |
| `isInterrupted()` | 无 | `boolean` | 是否被中断 |
| `setName(name)` / `getName()` | 名称 | — / `string` | 线程名 |
| `setPriority(priority)` / `getPriority()` | `1`～`10` | — / `number` | 优先级，数字越大越高 |
| `getThread()` | 无 | Java `Thread` | 底层对象，一般不用 |

## 最小片段

```javascript
let thread = Threads.create({
  run: function () {
    console.log('在子线程中执行');
    Threads.sleep(500);
  }
});
thread.join();
```

## 注意

- 优先用定时器或 `Engines.executeScript`，不要默认上多线程。
- 回调写成 `function` 或 `{ run: function () {} }`，不要箭头函数。
- `Threads.sleep` 与 `System.sleep` 都是休眠，前者可被 `interrupt` 打断。
- 也可用 Java：`new java.lang.Thread(new java.lang.Runnable(obj))`，见 [`extension.md`](./extension.md)。
