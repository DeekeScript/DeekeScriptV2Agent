# V2 没有 Hook

**DeekeScript V2 没有 Hook。** 不要生成 `hooks` 配置，不要写 `app_start_before` / `app_start` / `app_active_after`，不要调用 `Engines.closeHook()` 当初始化手段。

Hook 只存在于 **V1** 的 `deekeScript.json`：

```json
{
  "hooks": {
    "app_start_before": "scripts/hooks/app_start_before.js",
    "app_start": "scripts/hooks/app_start.js",
    "app_active_after": "scripts/hooks/app_active_after.js"
  }
}
```

V2 工程入口是 `deekeScript-v2.json`。把启动逻辑放在：

- 首页 `pages/*/page.js` 的 `onLoad` / `onShow`
- 任务脚本 `tasks/*.js`，由按钮 `onTap` 里 `Engines.executeScript` 启动
- 需要保活时用 [`timer.md`](./timer.md)、[`Foreground.md`](./Foreground.md)

## 注意

- `Engines.closeHook()` 仍出现在 d.ts 里，那是 V1 关闭 hook 脚本用的。V2 不要为此去创建 hook 文件。
- 动态改首页模块、功能开关：V1 靠 hook + `DeekeScriptJson`。V2 用页面 `setData` 和自己的 Storage / Http。
- 自检见 [`donts.md`](../../04-cheatsheets/donts.md)。
