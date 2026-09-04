# 入口与初始化

工程入口只有根目录的 `deekeScript.json`。不要写其它入口文件名，也不要在入口里写 `hooks`、`groups`。

启动与业务逻辑放在：

- 页面 `pages/*/page.js` 的 `onLoad` / `onShow`
- 任务脚本 `tasks/*.js`（由按钮 `onTap` 里 `Engines.executeScript` 启动）
- 需要保活时用 [`timer.md`](./timer.md)、[`Foreground.md`](./Foreground.md)

不要调用 `Engines.closeHook()`。动态改界面用 `setData`、Storage、Http。

自检见 [`donts.md`](../../04-cheatsheets/donts.md)。
