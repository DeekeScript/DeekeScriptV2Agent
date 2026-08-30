# Engines

JavaScript 运行时管理器。在当前环境中再开一个**完全独立**的运行时去执行其它脚本（不阻塞当前代码），或关闭运行时。

Pro **没有 Hook**。`closeHook()` 只用于关掉 V1 Hook 拉起的脚本，Pro 工程不必调用。

运行时由**线程池**实现，**有数量限制**，不能无限同时持续执行，否则会报错。

## 可用上下文

- **page.js**：点按钮启动 `tasks/*.js`。
- **tasks.js**：拉起子脚本（如心跳），或 `closeOther` / `closeAll`。

路径规则与 [`require`](../require.md) 相同：`./` `../` 相对当前文件，否则相对项目根。

## 方法

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| executeScript | `executeScript(file: string)` | JS 文件路径 | `void` | 在新运行时执行该文件。官方文档写返回 Thread；以 d.ts 的 `void` 为准 |
| executeScriptStr | `executeScriptStr(name: string, content: string)` | 任务名（排障用）、脚本源码 | `void` | 在新堆栈执行字符串。与当前脚本无共享 |
| closeAll | `closeAll()` | 无 | `void` | 关闭所有正在运行的脚本（含子脚本、定时器、socket）。**包括当前**。不含 V1 Hook 脚本 |
| closeOther | `closeOther()` | 无 | `void` | 关闭除当前之外的其它脚本及其子脚本/定时器/socket |
| closeHook | `closeHook()` | 无 | `void` | 关闭 V1 Hook 启动的脚本。Pro 无 Hook，不必使用 |
| childScriptCount | `childScriptCount()` | 无 | `number` | 通过 Engines 手动启动的子脚本总数 |

## 最小片段

```javascript
Engines.executeScript('tasks/xxx.js');
```

## 注意

- 子脚本依赖父脚本还活着：父脚本立刻结束，子脚本也会停。页面启动任务后页面可以停；任务脚本若还要保活子任务，自己的 `while` / 休眠不能马上结束。
- 悬浮球 `action: "stop"` 等同 `closeAll()`。不要把脚本路径塞进 `action`，见 [`ui-and-task.md`](../ui-and-task.md)。
- 索引见 [`INDEX.md`](INDEX.md)。
