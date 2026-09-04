# 展厅 Demo 与生成产物

官方组件展厅工程（本地常见目录名 `deekeScript-v2-demo`，包名 `cn.deeke.v2demo`）是 **UI / 能力预览**，不是生成模板。

生成工程以本仓库契约为准。展厅里下列写法**禁止照抄进产物**：

| 展厅里可能看到 | 生成时 |
|----------------|--------|
| 历史文案 `deekeScript-v2.json` | 只用 `deekeScript.json` |
| 入口写 `host` / `debug` / `apis` | 不要写 |
| 默认就配了 `floatWindow.menus` | 用户没提菜单就不要写 `floatWindow` |
| `permission.hint('请在文件…')` | 不要写进产物 |
| `page.js` 里 `System.sleep` | 用 `setTimeout` |
| 页面按钮 `Engines.closeAll()` 停任务 | 用 `FloatWindow.stopTask()`；任务内自动停才 `Engines.closeAll()` |
| `require('common/xxx.js')`（相对项目根） | **优先** `require('../common/xxx.js')` 等相对当前文件 |

展厅可以保留：大量组件示例页、自定义菜单的 `FloatWindow.setMenus` / `update` / `collapse` 演示、内置 `"action": "stop"` 菜单项。

目录命名习惯（`pages/floatWindow`、`pages/tabBar`）可与展厅一致。
