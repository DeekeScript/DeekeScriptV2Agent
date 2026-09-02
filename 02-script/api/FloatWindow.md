# FloatWindow

**项目**悬浮球的展开菜单。`floatWindow.menus` 与 `FloatWindow` 只作用于点「运行」之后（以及打包 App）的那颗球。

**生成时必读** [`01-ui/capabilities/floatWindow.md`](../../01-ui/capabilities/floatWindow.md) 与 [`03-recipes/float-window.md`](../../03-recipes/float-window.md)：**menus 与 `FloatWindow.on` 必须同一轮交付**。

框架**没有内置 action**（无 `stop` / `start` / `hide` / `executeScript`）。每项点击在 `FloatWindow.on` 里自定义。

d.ts 未声明 `FloatWindow`；显隐球用 [`FloatDialogs.setFloatWindowVisible`](FloatDialogs.md)。

## 可用上下文

- **tasks.js**（推荐绑 `on` / 跳过逻辑）
- **page.js**（可 `on` / `setMenus`，但任务行为应跟 `tasks/` 走）

JSON 配在 `deekeScript.json` 的 `floatWindow.menus`，最多展示 5 个。

## 方法

| 方法 | 说明 |
|------|------|
| `setMenus(menus)` | 运行时替换菜单 |
| `on(id, fn)` / `on({ ... })` | 绑点击（**必填**，否则点了无反应） |
| `update(id, patch)` | 改 label / icon / background / visible |
| `collapse()` | 收起菜单 |

## 最小片段（与 JSON 同轮出现在 tasks/*.js）

```javascript
FloatWindow.on({
  stop: function () {
    Engines.closeAll();
  },
  hide: function () {
    FloatDialogs.setFloatWindowVisible(false);
  },
  skip: function () {
    skipped = true;
    FloatWindow.update('skip', { label: '已跳过', background: '#E8F5E9' });
  }
});
```

## 注意

- 未开悬浮窗权限球不会出现 → [`Access.md`](Access.md)
- 不要写废弃字段 `action` / `file` → [`ui-and-task.md`](../ui-and-task.md)
- 索引见 [`INDEX.md`](INDEX.md)
