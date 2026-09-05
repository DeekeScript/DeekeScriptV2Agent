# 生成前自检（constraints 未覆盖的坑）

硬规则（MUST / MUST NOT）只看 [`constraints.md`](../00-core/constraints.md)，不要和本表对着抄两遍。本表只列**界面与组件**易错点。

| 禁止 | 正确做法 |
|------|----------|
| 列表 `bind` 空数组指望自动 Empty | 自己放 `"type": "empty"` + `showIf` |
| `webview` 不写 `style.height` | 必须写高度，否则默认 240dp |
| HID / 图色 / 媒体不申请权限 | 图色 `Access.isMediaProjectionEnable`；媒体 `hasMediaReadPermission`；HID 蓝牙。见对应 API 卡 |
| DeviceApp 等 DO API 不先查 `isDeviceOwner` | 先 [`do-mode.md`](../02-script/api/do-mode.md) |
| `executeScript` 写成 `./tasks` | 相对**项目根**：`tasks/sample.js`（与 `require` 不同） |
| 默认用 KeyBoards 输入、且不检查状态 | 优先 `setText` / 剪贴板；要用输入法先 `KeyBoards.canInput()` |
| 找到「发送」但 `clickable=false` 就放弃 | 点 `parent()`，或 `Gesture.click` 中心；点坐标前可 `FloatDialogs.setFloatWindowClickable(false)` |
| 有 `FloatDialogs.show` 却不关弹窗就点节点 | 开始前 `FloatDialogs.closeAll()` |
| 用页面根 `title` 同时又放 `navBar` | 自制顶栏时 `"title": { "hidden": true }` |
| 用户要蓝色，按钮仍默认绿 | 入口 `window.theme.primary`；`button` 写 `style.background`；导航栏/状态栏/底栏 `selectedColor` 一起改 |
| 搜索框点击变绿/变红当成组件自带 | 旧引擎会把 `theme.primary` 刷到聚焦底。新引擎默认灰边白底。不要给 search 写艳色 `style.background` |
| 用「启用/停用」大按钮做布尔开关 | `"type": "switch"`。见 [`list-manage.md`](../03-recipes/list-manage.md) |
| 列表表单不用 `e.item` / `e.index`，去编每行假 `name` | 列表里 switch / input / checkbox / radio / slider 等 `onChange` 都有 `e.value`、`e.item`、`e.index`。见 [`switch.md`](../01-ui/components/switch.md)、[`events.md`](../01-ui/events.md) |
| 列表开关绑 `"{{item.enabled}}"` 却把字符串 `"false"` 当开 | 整段一个 `{{path}}` 会保留布尔。也可不写 `value`，Switch 默认读 `item.enabled` |
| 列表行次要操作用默认大按钮 | 必须 `"size": "sm"`。一页最多一个大实心主 CTA |
| 底栏已有的页，首页再放跳转 | 见 [`workbench.md`](../03-recipes/workbench.md) |
| Switch 写 `style.background` 给整行刷底 | 只写 `style.color` |
| 检测失败 `continue` 但不递增、无上限 | `retryCount` 或 `processed++`，超过 N 次 `break` |
