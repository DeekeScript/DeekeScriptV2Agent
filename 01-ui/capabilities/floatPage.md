# FloatPage 悬浮窗

用户要**系统悬浮层上的 JSON 界面**（进度 HUD、控制面板）时才生成。与悬浮球 menus 无关。

## MUST

- 目录：`floats/<id>/page.json` + `page.js`（同正式页语法）。
- 显示前检查 `Access.isFloatWindowsEnabled()`。
- 脚本用 `FloatPage.setData(id, data)` 更新；浮层内用 `Page({ data, onTap... })`。
- 同时最多 3 个；`navigate` / `switchTab` / 底栏 / 下拉刷新不要用。

## MUST NOT

- 不要用 `FloatWindow.setMenus` 冒充悬浮窗界面。
- 用户只要停任务球 / 扇形菜单时，不要生成 `FloatPage`。
- 不要把 `floats/` 写进 `tabBar` / `pages` 注册（除非用户明确还要当正式页打开）。

API 卡：[`../../02-script/api/FloatPage.md`](../../02-script/api/FloatPage.md)。
