# Engines

JavaScript 运行时管理器。在当前环境中再开一个**完全独立**的运行时去执行其它脚本（不阻塞当前代码），或关闭运行时。

Pro **没有 Hook**。`closeHook()` 只用于关掉 V1 Hook 拉起的脚本，Pro 工程不必调用。

运行时由**线程池**实现，**有数量限制**，不能无限同时持续执行，否则会报错。

## 可用上下文

- **page.js**：点按钮启动 `tasks/*.js`。
- **tasks.js**：拉起子脚本（如心跳），或 `closeOther` / `closeAll`。

`executeScript` 的路径**相对项目根**（如 `'tasks/xxx.js'`），不要写成 `./tasks/...`。这与 [`require`](../require.md) 不同：`require` **优先**用 `./`、`../` 相对当前文件。

## 方法

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| executeScript | `executeScript(file: string)` | JS 文件路径 | `void` | 在新运行时执行该文件。官方文档写返回 Thread；以 d.ts 的 `void` 为准 |
| executeScriptStr | `executeScriptStr(name: string, content: string)` | 任务名（排障用）、脚本源码 | `void` | 在新堆栈执行字符串。与当前脚本无共享 |
| closeAll | `closeAll()` | 无 | `void` | 关闭**当前任务脚本**（含子脚本、定时器、socket）。须在 `tasks/*.js` 执行线程内调用。停整项任务见 `FloatWindow.stopTask()` |
| closeOther | `closeOther()` | 无 | `void` | 关闭除当前之外的其它脚本及其子脚本/定时器/socket |
| closeHook | `closeHook()` | 无 | `void` | 关闭 V1 Hook 启动的脚本。Pro 无 Hook，不必使用 |
| childScriptCount | `childScriptCount()` | 无 | `number` | 通过 Engines 手动启动的子脚本总数 |

## 最小片段

```javascript
Engines.executeScript('tasks/xxx.js');
```

## 关闭任务：底层逻辑

与 [`FloatWindow.md`](FloatWindow.md) 对照。以下均为**对外 JS API**，无其它可调用入口。

| JS API | 关闭范围 |
|--------|----------|
| `Engines.closeAll()` | **当前任务脚本**及其子脚本 |
| `FloatWindow.stopTask()` | **整项项目任务** + 恢复悬浮球 |

`Engines.closeAll()` 必须在 **`tasks/*.js` 执行线程**内调用。悬浮窗菜单回调不在该线程，故菜单里用它**停不掉任务**——须用 `FloatWindow.stopTask()`。

### 何时用 Engines.closeAll

- 写在 **`tasks/*.js`** 里**自动**结束：条件满足、循环跑完、业务收尾。
- 调用后当前脚本不再往下执行；会停掉当前任务下的定时器、WebSocket 等。

### 何时用 FloatWindow.stopTask

- **用户手动**点悬浮窗菜单停止。
- 结束逻辑不在任务脚本线程、但仍要停**整项**任务时。

### 不要混用

| 错误 | 正确 |
|------|------|
| 菜单 `FloatWindow.on` 里 `Engines.closeAll()` | `FloatWindow.stopTask()` |
| 任务内部自动结束却只绑菜单 stop | 在 `tasks/*.js` 里 `Engines.closeAll()` 或条件退出循环 |

## 注意

- 子脚本依赖父脚本还活着：父脚本立刻结束，子脚本也会停。页面启动任务后页面可以停；任务脚本若还要保活子任务，自己的 `while` / 休眠不能马上结束。
- 悬浮球菜单里停止任务用 `FloatWindow.stopTask()`（走悬浮窗关闭项目任务）；`Engines.closeAll()` 只在**脚本线程内**关闭自身，见 [`FloatWindow.md`](FloatWindow.md)。
- 索引见 [`INDEX.md`](INDEX.md)。
