# FloatWindow

**项目**悬浮球的展开菜单。`floatWindow.menus` 与 `FloatWindow` 只作用于点「运行」之后（以及打包 App）的那颗球，不改变开发器里的球。

d.ts 未声明 `FloatWindow`；方法以[官方文档](https://script.deeke.cn)为准。显隐这颗球用 [`FloatDialogs.setFloatWindowVisible`](FloatDialogs.md)。

## 可用上下文

- **page.js** 与 **tasks.js** 都能 `on` / `setMenus` / `update` / `collapse`。

JSON 配在 `deekeScript.json` 的 `floatWindow.menus`，默认最多展示 5 个（含运行中框架补的停止）。

## 方法

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| setMenus | `setMenus(menus)` | 菜单项数组 | 未写返回值 | 运行时替换菜单。脚本结束后恢复 JSON 配置 |
| on | `on(id, fn)` | 菜单 id、点击函数 | 未写返回值 | 给某个 id 绑点击 |
| on | `on(map)` | `{ id: fn, ... }` | 未写返回值 | 一次绑多个 |
| update | `update(id, patch)` | id、补丁对象 | 未写返回值 | 改文案、图标、底色、`visible`。展开中会立刻刷新 |
| collapse | `collapse()` | 无 | 未写返回值 | 收起已展开的菜单 |

菜单项字段（JSON 或 `setMenus`）：`id`、`icon`（内置 `close`/`play`/`hide` 或工程内图片/SVG）、`label`、`action`、`file`（`action` 为 `executeScript` 时的脚本路径）、`onTap`、`show`（`always` / `running` / `idle`）、`background`。

内置 `action`：`stop`（`Engines.closeAll()`）、`hide`（隐藏球）、`start`（开始当前任务）、`executeScript`（执行 `file`）。`stop` 由框架执行，不要用自定义 `onTap` 替换。

## 最小片段

```javascript
FloatWindow.on({
  start: function () {
    Engines.executeScript('tasks/xxx.js');
  },
  skip: function () {
    FloatWindow.update('skip', { label: '已跳过', background: '#E8F5E9' });
  }
});
```

## 注意

- 未授予悬浮窗权限时球不会出现。先 [`Access.isFloatWindowsEnabled()`](Access.md)，不要依赖系统自动弹窗。
- **不要把脚本路径或代码塞进 `action`**。启动用 `Engines.executeScript` 或 `action: "executeScript"` + `file`。见 [`ui-and-task.md`](../ui-and-task.md)。
- JSON 的 `onTap: "onSkip"` 会找同名函数，或 `on('onSkip')` / `on('skip')` 绑过的回调。
- 索引见 [`INDEX.md`](INDEX.md)。
