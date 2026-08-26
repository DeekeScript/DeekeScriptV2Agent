# 上下文边界

决定一段代码写在 `page.js`、`component.js` 还是 `tasks/*.js` 时读这篇。Page / Component 方法只在对应文件里有效。从页面启动任务用 `Engines.executeScript`。`UiSelector` 主要在任务脚本里找节点。不要在页面点击回调里跑长循环。

## API 分表

| API / 能力 | page.js | component.js | tasks.js | 说明 |
|------------|---------|--------------|----------|------|
| `Page({})` | 是 | 否 | 否 | 只在页面 `page.js` |
| `Component({})` | 否 | 是 | 否 | 只在 `component.js` |
| `this.setData` / `this.appendData` | 是 | 是 | 否 | 改自己的 `data` |
| `this.navigate` / `redirect` / `switchTab` / `back` | 是 | 是（走所在页） | 否 | 见 [跳转](../01-ui/navigate.md) |
| `this.toast` / `openUrl` / `setTitle` / `scrollTo` | 是 | 是（走所在页） | 否 | 任务里用 `System.toast` |
| `this.showPopup` / `hidePopup` | 是 | 是（走所在页） | 否 | 见 [弹层](../01-ui/capabilities/popup.md) |
| `this.showLoading` / `hideLoading` / `stopPullDownRefresh` | 是 | 是（走所在页） | 否 | |
| `this.setTabBar` / `setTabBarItem` / `setTabBarStyle` | 是 | 是（走所在页） | 否 | 见 [底栏](../01-ui/capabilities/tabBar.md) |
| `this.selectComponent` | 是 | 否（父页用） | 否 | 按节点 `id` 找子组件 |
| `this.triggerEvent` | 否 | 是 | 否 | 子 → 父 |
| `onLoad` / `onShow` / `onReady` / `onHide` / `onUnload` | 是 | 否 | 否 | 页面生命周期 |
| `created` / `attached` / `detached` | 否 | 是 | 否 | 组件生命周期 |
| `Engines.executeScript` | 是 | 是 | 是 | 从页面启动任务；任务里也可拉子脚本 |
| `Engines.closeAll` | 是 | 是 | 是 | 停全部脚本 |
| `require` / `module.exports` | 是 | 是 | 是 | 路径规则相同 |
| `Http.get` / `Http.post` | 是 | 是 | 是 | 页面和任务都能请求 |
| `Storage.put` / `get*` | 是 | 是 | 是 | 页面写配置，任务读配置 |
| `console` / `setTimeout` / `setInterval` / `Promise` | 是 | 是 | 是 | Rhino 全局 |
| `Dialogs` / `Access` | 是 | 是 | 是 | 权限引导、确认框 |
| `FloatWindow` / `FloatDialogs` | 是 | 是 | 是 | 项目悬浮窗；开发器球不读 `floatWindow.menus` |
| `System.toast` / `System.sleep` | 可用 | 可用 | 是（主场） | 任务里等待用 `sleep`；页面短提示优先 `this.toast` |
| `UiSelector` / `UiObject` | 不要作为主流程 | 否 | 是 | 找节点、点击、输入主要在任务脚本 |
| `App.launch` / `Gesture` / `Images` | 一般不用 | 否 | 是 | 自动化专用 |
| WebView 与 Page 通信 | 无 | 无 | 无 | 没有桥 |

## 从页面启动任务

```javascript
// pages/task/page.js
Page({
  onRun: function () {
    Engines.executeScript('tasks/sample.js');
  }
});
```

路径相对项目根。需要先检查无障碍和悬浮窗时：

```javascript
let permission = require('common/permission.js');

Page({
  onRun: function () {
    permission.runScript('tasks/sample.js');
  }
});
```

## 任务脚本里找节点

```javascript
// tasks/sample.js
let permission = require('common/permission.js');
if (!permission.ensureRun()) {
  // 已弹窗引导
} else {
  var node = UiSelector().text('关注').findOne();
  if (node) {
    node.click();
  }
}
```

`page.js` 的 `onTap` 只负责启动脚本并立刻返回。节点查找、滑动、循环等待放在 `tasks/*.js`。
