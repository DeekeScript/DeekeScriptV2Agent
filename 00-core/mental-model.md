# 心智模型

生成任何 Pro 工程前先读这篇。DeekeScript Pro 做两件事：跑任务脚本，以及（可选）用 JSON 做界面。界面不是前提；没有 `pages/` 也能跑任务。长任务与设备自动化写在 `tasks/*.js`。具体能力按任务打开对应 API 卡（见 [`INDEX.md`](../INDEX.md)）。

## 两层

| 层 | 写什么 | 怎么跑 | 是否必须 |
|----|--------|--------|----------|
| 任务脚本 | `tasks/*.js`：业务与设备自动化（API 按需查） | `Engines.executeScript`，或「仅当前文件执行」 | 是（要自动化就必须有） |
| 界面（可选） | `page.json` 描述结构，`page.js` 填数据、响应点击 | 同步到手机后刷新，进入 `homePage` | 否 |

只跑脚本时不必打开任何页面；工程识别靠入口文件，见 [`entry-json.md`](../01-ui/entry-json.md)。

## JSON 与脚本分工

| 文件 | 职责 |
|------|------|
| `deekeScript.json` | 识别工程；有界面时写 `homePage`、`window`、`pages`、`bottomMenus`；`floatWindow` **仅用户要自定义悬浮菜单时再写** |
| `pages/<id>/page.json` | 这一页长什么样：`title` / `body` / `popups`；`action` 见 [`page-json.md`](../01-ui/page-json.md#json-action) |
| `pages/<id>/page.js` | `Page({})`：数据、生命周期、点击后跳转或拉起脚本 |
| `tasks/*.js` | 设备自动化业务 |

从按钮跑任务：`onTap` → `page.js` 里启动 `tasks/*.js`，见 [`events.md`](../01-ui/events.md)。

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
let permission = require('../common/permission.js');
if (!permission.ensureRun()) {
  // 无障碍 / 悬浮窗未开，已弹窗引导
} else {
  var name = Storage.getString('demo.task_name');
  // 仍在本 App：System.toast；已切第三方 App：FloatDialogs
  System.toast(name);
}
```
