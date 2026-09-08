# FloatPage

悬浮窗。用 `floats/<id>/page.json` + `page.js`（与正式页同语法），挂在系统悬浮层上；任务脚本用 `FloatPage.setData(id, …)` 推数据。

**不要**与 [`FloatWindow`](./FloatWindow.md)（悬浮球 menus）混淆。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 是 |
| `tasks/*.js` | 是 |

## 工程

```text
floats/<id>/page.json
floats/<id>/page.js
```

`show('status')` → `floats/status/`。也可 `floats/...` 或 `pages/...` 完整路径。最多同时 **3** 个。需悬浮窗权限：`Access.isFloatWindowsEnabled()`。

外壳默认黑底 `#000000`；`opacity`（0~1，默认 0.5）与 `background` 可配。`touchable: false` 点击穿透。内容区 `style.background` 建议透明，文字用浅色。

浮层内 **禁止依赖**：`navigate` / `redirect` / `back` / `switchTab` / 底栏 / 下拉刷新（调用无效）。

## 方法

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `show(id)` / `show(id, options)` | `x,y,width,height`,`path`,`opacity`,`background`,`draggable,focusable,touchable` | `boolean` | 无权限 / 无目录 / 超限 → `false` |
| `hide(id)` | | | 隐藏，保留实例与数据 |
| `close(id)` / `closeAll()` | | | 销毁实例并清空数据；下次 show 为新建；`stopTask` 也会 `closeAll` |
| `exists(id)` | | `boolean` | 实例是否存在（含 hide） |
| `isShowing(id)` | | `boolean` | 是否显示中 |
| `setData` / `getData` | | | 读写绑定数据 |
| `setPosition` / `getPosition` | px | `{x,y}` | |
| `setSize` / `getSize` | px | `{width,height}` | |
| `setOpacity` / `getOpacity` | 0~1 | number | 外壳透明度 |
| `setBackground` / `getBackground` | `#RRGGBB` | string | 外壳底色 |
| `setTouchable` / `isTouchable` | bool | | `false` 点击穿透 |
| `setDraggable` / `isDraggable` | bool | | `false` 隐藏手柄且不可拖 |
| `selfId()` | | string/null | floats 的 page.js 里取当前实例 id |

## 最小片段

```javascript
if (!Access.isFloatWindowsEnabled()) {
  Access.openFloatWindowsSetting();
  System.exit();
}

FloatPage.show('status', {
  width: Math.floor(Device.width() * 0.8),
  height: 500,
  opacity: 0.5,
  background: '#000000',
  draggable: true
});
FloatPage.setData('status', { count: 1, text: '运行中' });
let pos = FloatPage.getPosition('status');
console.log(pos && pos.x, pos && pos.y);
System.sleep(3000);
FloatPage.close('status');
```

## 注意

- 用户没提悬浮窗（JSON 面板 / HUD）时，**不要**生成 `floats/` / `FloatPage`。
- 停任务菜单仍用 `FloatWindow.stopTask()`，不是 `FloatPage`。
- 相关：[`FloatWindow.md`](./FloatWindow.md)、[`Access.md`](./Access.md)、[`FloatDialogs.md`](./FloatDialogs.md)。
