# 心智模型

生成任何 Pro 工程前先读这篇。DeekeScript Pro 做两件事：跑无障碍脚本，以及（可选）用 JSON 做界面。界面不是前提；没有 `pages/` 也能跑任务。长任务、找节点、点击滑动只写在 `tasks/*.js`，不要写进 JSON 的 `action`。

## 两层

| 层 | 写什么 | 怎么跑 | 是否必须 |
|----|--------|--------|----------|
| 任务脚本 | `tasks/*.js`：点击、滑动、`UiSelector` 找节点 | VSCode「仅当前文件执行」，或页面里 `Engines.executeScript` | 是（要自动化就必须有） |
| 界面（可选） | `page.json` 描述结构，`page.js` 填数据、响应点击 | 同步到手机后刷新，进入 `homePage` | 否 |

只跑脚本时，根目录仍必须有 [`deekeScript.json`](../01-ui/entry-json.md)（插件靠它识别工程），不必打开任何页面。

## JSON 只管 UI

| 文件 | 职责 | 禁止 |
|------|------|------|
| `deekeScript.json` | 识别工程；有界面时写 `homePage`、`window`、`pages`、`bottomMenus`、`floatWindow` | 写业务循环、无障碍操作 |
| `pages/<id>/page.json` | 这一页长什么样：`title` / `body` / `popups` | 把长任务塞进 `action` |
| `pages/<id>/page.js` | `Page({})`：数据、生命周期、点击后跳转或拉起脚本 | 当普通脚本点「仅当前文件执行」 |
| `tasks/*.js` | 真正的无障碍自动化 | 依赖页面已打开才能运行（无界面也应能跑） |

`action` 只做轻触后的界面动作（`navigate` / `toast` / `save` 等）。从按钮跑任务：JSON 写 `onTap`，在 `page.js` 里调用 `Engines.executeScript('tasks/xxx.js')`。对照见 [约束](./constraints.md)、[跳转](../01-ui/navigate.md)。

## 有界面时的数据流

1. 表单 `name` 双向绑定 `Page.data`。
2. 保存时 `Storage.put`；任务脚本用 `Storage.get*` 读配置。
3. 页面不「执行」自动化，只启动 `tasks/*.js`。

```javascript
// pages/task/page.js
Page({
  data: {
    task_name: '早间养号'
  },
  onSave: function () {
    Storage.put('demo.task_name', this.data.task_name);
  },
  onRun: function () {
    Engines.executeScript('tasks/sample.js');
  }
});
```

```javascript
// tasks/sample.js
let permission = require('common/permission.js');
if (!permission.ensureRun()) {
  // 无障碍 / 悬浮窗未开，已弹窗引导
} else {
  var name = Storage.getString('demo.task_name');
  System.toast(name);
}
```
