# 运行时：两层结构、Rhino、API 边界

生成前读这篇。DeekeScript Pro 做两件事：跑 `tasks/*.js`，以及（可选）用 JSON 做界面。没有 `pages/` 也能跑脚本。硬规则见 [`constraints.md`](./constraints.md)；目录见 [`project-layout.md`](./project-layout.md)。

## 两层

| 层 | 写什么 | 怎么跑 | 必须？ |
|----|--------|--------|--------|
| 任务脚本 | `tasks/*.js` 设备自动化 | `Engines.executeScript` 或「仅当前文件执行」 | 要自动化就必须有 |
| 界面 | `page.json` 结构 + `page.js` 数据/点击 | 同步到手机后进 `homePage` | 否 |

| 文件 | 职责 |
|------|------|
| `deekeScript.json` | 识别工程；有界面时写 `homePage` / `window` / `pages` / `bottomMenus`；`floatWindow` 仅用户要自定义菜单时再写 |
| `pages/<id>/page.json` | 这一页长什么样；`action` 见 [`page-json.md`](../01-ui/page-json.md#json-action) |
| `pages/<id>/page.js` | `Page({})`：数据、生命周期、跳转或拉起脚本 |
| `tasks/*.js` | 找节点、循环、切 App |

数据流：表单 `name` ↔ `Page.data` → `Storage.put` → 任务 `Storage.get*`。页面与脚本不共享 JS 变量。

```javascript
// pages/task/page.js
let permission = require('../../common/permission.js');
Page({
  onSave() {
    Storage.put('demo.task_name', this.data.task_name);
  },
  onRun() {
    this.onSave();
    permission.runScript('tasks/sample.js');
  }
});
```

```javascript
// tasks/sample.js
let permission = require('../common/permission.js');
let task = {
  run() {
    if (!permission.ensureRun()) {
      return;
    }
    var name = Storage.getString('demo.task_name');
    System.toast(name);
  }
};
task.run();
```

`page.js` 的 `onTap` 只启动脚本并立刻返回。节点查找、滑动、循环放 `tasks/*.js`。

## Rhino 1.8

三处脚本同一套语法。可直接调 Java。`setTimeout` / `setInterval` / `console` / `Promise` / 箭头可用。

| 能写 | 不能写（替代） |
|------|----------------|
| `function` / `() => {}` / 对象方法简写 `open() {}` | `async/await` → `Promise.then` 或同步 API |
| `var` / `let` | `e?.detail` → `e && e.detail` |
| `require('../x.js')` + `module.exports` | `a ?? b` → `a != null ? a : b` |
| `if` / `for` / `while` / `try/catch` | `import`/`export` → `require` |
| `JSON.parse` / `stringify` | 磁盘绝对路径 `require` |

```javascript
// 错误：e?.detail?.keyword ?? ''
// 正确
onPicked(e) {
  var d = e && e.detail ? e.detail : {};
  var keyword = d.keyword ? d.keyword : '';
  this.setData({ picked: keyword || '未选' });
}
```

| 场景 | 写法 |
|------|------|
| `common/`、`tasks/` 业务 | **必须**对象 + 方法简写。见 [`code-org.md`](../02-script/code-org.md) |
| `Page` / `Component` / `module.exports` | `onLoad() {}`，不要 `onLoad: function () {}`，不要 `onLoad: () => {}`（绑错 `this`） |
| API 回调 / `.filter` | `function` 或箭头均可 |
| 回调里用页面 `this` | `var that = this;` 再进 `setTimeout` |
| 延时 | 页面 `setTimeout`；任务 `System.sleep` |
| 字符串 | `'已保存：' + name`（少用模板字符串） |

`Page({})` / `Component({})` 里未声明的生命周期不会调用。

## API 能用在哪

| API | page.js | component.js | tasks.js | 说明 |
|-----|---------|--------------|----------|------|
| `Page({})` | 是 | 否 | 否 | |
| `Component({})` | 否 | 是 | 否 | |
| `this.setData` / `appendData` | 是 | 是 | 否 | |
| `this.navigate` / `redirect` / `switchTab` / `back` | 是 | 走所在页 | 否 | [`navigate.md`](../01-ui/navigate.md) |
| `this.toast` / `openUrl` / `setTitle` / `scrollTo` | 是 | 走所在页 | 否 | 任务用 `System.toast` |
| `this.showPopup` / `hidePopup` / `showLoading` / `setTabBar*` | 是 | 走所在页 | 否 | |
| `this.selectComponent` | 是 | 否 | 否 | |
| `this.triggerEvent` | 否 | 是 | 否 | |
| 页面生命周期 `onLoad` 等 | 是 | 否 | 否 | |
| 组件 `created` / `attached` / `detached` | 否 | 是 | 否 | |
| `Engines.executeScript` | 是 | 是 | 是 | 路径相对**项目根** |
| `Engines.closeAll` | 勿用 | 勿用 | 是 | 仅任务线程自动结束 |
| `FloatWindow.stopTask` | 菜单回调 | 菜单回调 | 一般不用 | 用户手动停 |
| `require` / `Http` / `Storage` / `console` / `setTimeout` / `Dialogs` / `Access` / `FloatWindow` / `FloatDialogs` | 是 | 是 | 是 | |
| `System.sleep` | 禁止 | 禁止 | 是 | |
| `UiSelector` / `App.launch` / `Gesture` / `Images` | 不要当主流程 | 否 | 是 | |
| WebView ↔ Page | 无 | 无 | 无 | 外链用 `openUrl` |

切到第三方 App 后提示用 `FloatDialogs`，不要指望前台 toast。
