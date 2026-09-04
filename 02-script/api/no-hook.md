# 入口与初始化

工程入口字段见 [`entry-json.md`](../../01-ui/entry-json.md)。

启动与业务逻辑放在：

- 页面 `pages/*/page.js` 的 `onLoad` / `onShow`
- 任务脚本 `tasks/*.js`（由按钮 `onTap` 里 `Engines.executeScript` 启动）
- 需要保活时用 [`timer.md`](./timer.md)、[`Foreground.md`](./Foreground.md)

动态改界面用 `setData`、Storage、Http。

硬规则见 [`constraints.md`](../../00-core/constraints.md)。
