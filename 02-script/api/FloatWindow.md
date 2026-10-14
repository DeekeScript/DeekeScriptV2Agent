# FloatWindow

**项目**悬浮球菜单 API。不写 `floatWindow` 则不展示球。只要默认球写 `"floatWindow": {}`（连点两次停任务）。`menus` 有内容时才写 `FloatWindow.on`。

悬浮窗（进度 HUD 等）用 [`FloatPage`](./FloatPage.md)，不要扩写 menus。

权威说明：[`floatWindow.md`](../../01-ui/capabilities/floatWindow.md)。硬规则：[`constraints.md`](../../00-core/constraints.md) MUST 10–11。

| 方法 | 说明 |
|------|------|
| `setMenus(menus)` | 运行时替换菜单；脚本结束后恢复 JSON |
| `on(id, fn)` / `on({ ... })` | 绑点击（不绑则点了无反应） |
| `update(id, patch)` | 改 label / icon / background / visible |
| `collapse()` | 收起菜单 |
| `stopTask()` | 停**整项**项目任务并恢复球 UI |

菜单停任务用 `stopTask()`，不要用 `Engines.closeAll()`（菜单线程里无效）。

```javascript
FloatWindow.on({
  stop: function () {
    FloatWindow.stopTask();
  },
  hide: function () {
    FloatDialogs.setFloatWindowVisible(false);
  }
});
```

显隐球：[`FloatDialogs.setFloatWindowVisible`](FloatDialogs.md)。索引：[`INDEX.md`](INDEX.md)。
