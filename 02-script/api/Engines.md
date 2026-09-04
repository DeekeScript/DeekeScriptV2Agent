# Engines

在当前环境中再开一个**独立**运行时执行其它脚本，或关闭运行时。Pro **没有 Hook**——不要生成 `hooks` / 调用 `closeHook()`。

## 可用上下文

- **page.js**：点按钮启动 `tasks/*.js`（不要在页面回调里 `closeAll`）。
- **tasks.js**：拉起子脚本，或任务内 `closeAll` / `closeOther`。

`executeScript` 路径**相对项目根**（`'tasks/xxx.js'`）。`require` 优先 `./`、`../`，见 [`require.md`](../require.md)。

## 方法

| 方法 | 签名 | 返回 | 说明 |
|------|------|------|------|
| executeScript | `executeScript(file: string)` | `void` | 新运行时执行文件 |
| executeScriptStr | `executeScriptStr(name: string, content: string)` | `void` | 新运行时执行源码字符串 |
| closeAll | `closeAll()` | `void` | 结束**当前任务脚本**（含子脚本/定时器）。**仅 tasks 线程** |
| closeOther | `closeOther()` | `void` | 结束其它运行时，留下当前 |
| closeHook | `closeHook()` | `void` | 仅 V1；Pro 勿用 |
| childScriptCount | `childScriptCount()` | `number` | 经 Engines 拉起且未结束的脚本数 |

## 最小片段

```javascript
Engines.executeScript('tasks/xxx.js');
```

## 停任务（权威对照）

硬规则见 [`constraints.md`](../../00-core/constraints.md) MUST 11；悬浮窗细节见 [`floatWindow.md`](../../01-ui/capabilities/floatWindow.md#停任务权威)。

| 场景 | API |
|------|-----|
| 任务内自动结束 | `Engines.closeAll()`（写在 `tasks/*.js`） |
| 用户点菜单停止 | `FloatWindow.stopTask()` |
| 未配 menus | 连点悬浮球两次（不必再写 stop） |

菜单回调里 `Engines.closeAll()` **无效**。

## 注意

- 父脚本立刻结束则子脚本也会停；页面启动任务后页面可停，任务若要保活子任务则自身不能马上结束。
- 索引见 [`INDEX.md`](INDEX.md)。
