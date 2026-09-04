# 标准任务骨架

自动化脚本放在 `tasks/*.js`。入口顺序：权限 → 读配置 → 循环。**默认不要**绑 `FloatWindow.on`（用户没提悬浮窗菜单时）。

依赖：[`permission.md`](permission.md)、[`ui-and-task.md`](ui-and-task.md)、[`require.md`](require.md)、[`UiSelector.md`](api/UiSelector.md)、[`automation-loop.md`](../00-core/automation-loop.md)。

## 默认骨架（无悬浮菜单）

```javascript
let permission = require('../common/permission.js');

if (!permission.ensureRun()) {
  // 无障碍或悬浮窗未开启，ensureRun 已弹窗引导
} else {
  let keyword = Storage.get('myapp.keyword');
  if (!keyword) {
    keyword = '发送';
  }
  let maxCount = 20;
  if (Storage.contains('myapp.max_count')) {
    maxCount = Storage.getInteger('myapp.max_count');
  }

  let i = 0;
  while (i < maxCount) {
    let btn = UiSelector().text(keyword).findOne();
    if (btn) {
      btn.click();
    }
    System.sleep(1000);
    i++;
  }

  // 业务跑完自动停（须在本任务线程）
  Engines.closeAll();
}
```

未配 `floatWindow.menus` 时，用户可连点悬浮球两次停止。不必生成 stop 菜单。

## 仅当用户要悬浮窗菜单时

与 JSON `menus` **同一轮**生成。完整示例见 [`03-recipes/float-window.md`](../03-recipes/float-window.md)。要点：

- 手动停：`FloatWindow.stopTask()`（不要在菜单里 `Engines.closeAll()`）
- 跳过等自定义项：在循环外设标志，`FloatWindow.on({ skip: ... })`

```javascript
let skipped = false;
FloatWindow.on({
  skip: function () {
    skipped = true;
  },
  stop: function () {
    FloatWindow.stopTask();
  }
});

let i = 0;
while (i < maxCount && !skipped) {
  // ...
  i++;
}
```

## 页面侧启动

```javascript
let permission = require('../../common/permission.js');

Page({
  data: {
    keyword: '发送'
  },
  onSave: function () {
    Storage.put('myapp.keyword', this.data.keyword);
    Storage.putInteger('myapp.max_count', 20);
  },
  onRun: function () {
    this.onSave();
    permission.runScript('tasks/xxx.js');
  }
});
```

## 注意

- `ensureRun()` 未授权时立刻返回 `false`，必须停下来。
- `Engines.executeScript('tasks/xxx.js')` 路径相对**项目根**。
- **提示**：页面用 `this.toast`；任务仍在本 App 前台可用 `System.toast`；已切到抖音/微信等后台用 [`FloatDialogs`](api/FloatDialogs.md)。
- 找节点用 [`UiSelector`](api/UiSelector.md)；点击前一般先 `filter` 屏内。
- **`while` 里 `continue` 必须递增计数或设 retry 上限**，否则会无限 toast。
