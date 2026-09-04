# 带界面的第三方 App 自动化工具

本工程常见形态：底栏工作台（首页摘要 + 开始）+ 设置表单 + 可启用列表 + 操作记录，任务脚本 `launch` 目标 App，做完 `App.backApp()`。生成前对照 [`form-name.md`](../01-ui/pitfalls/form-name.md)、[`workbench.md`](./workbench.md)、[`code-org.md`](../02-script/code-org.md)、[`automation-loop.md`](../00-core/automation-loop.md)。

## 界面层

| 规则 | 原因 |
|------|------|
| 底栏根页用 `onShow` 从 Storage **重新读**再 `setData` | 切 Tab 只走 `onShow`，不走 `onLoad`。设置页保存后回首页，否则摘要仍是旧值。见 [`page-js.md`](../01-ui/page-js.md) |
| `page.js` 只存配置、刷新展示、`permission.runScript` | 找节点、循环、滑动放 `tasks/*.js` |
| 开始任务前校验必填（关键词、启用评论等），用 `this.toast` | 不要把空配置丢进任务再弹 `Dialogs` |
| 列表项带稳定 `id`；`onChange`/`onTap` 用 `e.item` 或 `e.index` | 否则开关/删除会对错行 |
| `Storage.getObj` 得到的数组先拷成纯对象再改再 `putObj` | 避免 Rhino 包装对象写回异常 |
| `putInteger`/`getInteger`、`putBoolean`/`getBoolean` 成对；整数先 `contains` 再读，缺省写在代码里 | 类型不对会读错；未写入时 `getInteger` 可能是 0 |
| 改 `pages/` 后 `write`；有表单/列表的页不能只测脚本 Storage | 开关联动、Tab 不刷新属于界面问题 |

## 任务层（无障碍）

| 规则 | 原因 |
|------|------|
| 包名做成常量；先 `App.isAppInstalled`，再 `launch` | 未安装要提示，不要空点 |
| 后台拉起目标 App 时检查后台弹窗权限 | 部分机型 `launch` 停在后台 |
| **不要**用 `System.currentPackage()` 判断是否已在目标 App | 跑任务后它仍可能是本工程包名，会误判死循环。用目标页**互斥节点**。见 [`System.md`](../02-script/api/System.md)、[`page-state.md`](../02-script/pitfalls/page-state.md) |
| 写选择器前 `snapshot`；点击前 `filter` 屏内 | 禁止凭记忆猜 id/desc |
| `waitFindOne()` 禁止用于任务循环 | 会一直阻塞。用 `findOne` / `findOneBy(timeout)` |
| `while` 必须有次数上限；刷流以内容条为进度，失败 skip 并划走 | 见 [`skip-on-item-failure.md`](../02-script/pitfalls/skip-on-item-failure.md) |
| 目标 App 弹窗点文案关掉；Deeke 弹窗用 `FloatDialogs.closeAll()` | 两类弹窗不要混 |
| 已切到目标 App：提示用 `FloatDialogs`，不要 `Dialogs` / 指望前台 toast | |
| 坐标点击前 `FloatDialogs.setFloatWindowClickable(false)`，点完改回 | 避免点到悬浮球 |
| 输入：click → sleep → **重新 find** → `setText` → 校验 `text` | [`stale-node-after-click.md`](../02-script/pitfalls/stale-node-after-click.md) |
| 屏宽高用 `Device.width()` / `Device.height()` | 不要用 `/ai/status` 的 screenHeight |
| 用户要求「做完回到本 App」时，任务结束调用 `App.backApp()`，再 `Engines.closeAll()` | 停在第三方页不算完成 |
| 按操作对象拆 `common/<app>/page.js`、`video.js` 等，任务里只组合；业务用对象方法，禁止顶层 `function` | [`code-org.md`](../02-script/code-org.md) |

## 文件分工（对照本形态）

```
pages/home      摘要 + 唯一「开始」
pages/settings  关键词、数量、概率、休眠 → Storage
pages/comments  话术列表 + switch 启停
pages/logs      只展示记录
common/store.js 所有 Storage 键（带项目+模块前缀）
common/<app>/   页面态、对象操作
tasks/*.js      权限 → 读配置 → 有界循环 → backApp
```
