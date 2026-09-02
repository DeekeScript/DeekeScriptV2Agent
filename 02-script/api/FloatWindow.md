# FloatWindow

**项目**悬浮球的展开菜单。`floatWindow.menus` 与 `FloatWindow` 只作用于点「运行」之后（以及打包 App）的那颗球。

**生成时必读** [`01-ui/capabilities/floatWindow.md`](../../01-ui/capabilities/floatWindow.md) 与 [`03-recipes/float-window.md`](../../03-recipes/float-window.md)：**menus 与 `FloatWindow.on` 必须同一轮交付**。

d.ts 未声明 `FloatWindow`；显隐球用 [`FloatDialogs.setFloatWindowVisible`](FloatDialogs.md)。

## 可用上下文

- **tasks.js**（推荐绑 `on` / 跳过逻辑）
- **page.js**（可 `on` / `setMenus`，但自定义任务行为应跟 `tasks/` 走）

JSON 配在 `deekeScript.json` 的 `floatWindow.menus`，最多展示 5 个。

## action（menus 里）

**仅此四个**，不是页面 `action`：

| action | 行为 | 还要 JS |
|--------|------|---------|
| `stop` | `Engines.closeAll()` | 否 |
| `hide` | 隐藏球 | 否 |
| `start` | 启动工程主脚本 | 自定义路径时用 `onTap`+`on` |
| `executeScript` | 跑 `file` 字段脚本 | 写出该 tasks 文件 |

`onTap` / 跳过 / 改菜单状态 → **必须** `FloatWindow.on`，见配方。

## 方法

| 方法 | 说明 |
|------|------|
| `setMenus(menus)` | 运行时替换菜单 |
| `on(id, fn)` / `on({ ... })` | 绑点击 |
| `update(id, patch)` | 改 label / icon / background / visible |
| `collapse()` | 收起菜单 |

## 最小片段（与 JSON 同轮出现在 tasks/*.js）

```javascript
FloatWindow.on({
  skip: function () {
    skipped = true;
    FloatWindow.update('skip', { label: '已跳过', background: '#E8F5E9' });
  }
});
```

## 注意

- 未开悬浮窗权限球不会出现 → [`Access.md`](Access.md)
- 不要把脚本路径写进 `action` → [`ui-and-task.md`](../ui-and-task.md)
- 索引见 [`INDEX.md`](INDEX.md)
