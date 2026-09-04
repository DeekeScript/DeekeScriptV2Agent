# 标准任务骨架

自动化脚本放在 `tasks/*.js`。入口顺序：权限 → 读配置 → 循环。**默认不要**绑 `FloatWindow.on`（用户没提悬浮窗菜单时）。多功能 / 多对象 App 自动化须按 [`code-org.md`](code-org.md) 按操作对象拆到 `common/`，任务里组合调用。

依赖：[`permission.md`](permission.md)、[`code-org.md`](code-org.md)、[`ui-and-task.md`](ui-and-task.md)、[`require.md`](require.md)、[`UiSelector.md`](api/UiSelector.md)、[`device.md`](../00-core/device.md)。刷推荐流 / 进主页取号时再读 [`skip-on-item-failure.md`](pitfalls/skip-on-item-failure.md)。

## 默认骨架（无悬浮菜单）

```javascript
let permission = require('../common/permission.js');

let task = {
  run() {
    if (!permission.ensureRun()) {
      return;
    }
    let keyword = Storage.get('myapp.settings.keyword');
    if (!keyword) {
      keyword = '发送';
    }
    let maxCount = 20;
    if (Storage.contains('myapp.task.max_count')) {
      maxCount = Storage.getInteger('myapp.task.max_count');
    }

    let i = 0;
    while (i < maxCount) {
      let btn = UiSelector().text(keyword).filter(function (n) {
        return n && n.bounds() && n.bounds().top >= 0;
      }).findOne();
      if (btn) {
        btn.click();
      }
      System.sleep(1000);
      i++;
    }

    Engines.closeAll();
  }
};

task.run();
```

## 刷流骨架（单条失败也前进）

以「一条视频 / 帖子」为进度。进主页弹窗、读不到字段时 **skip 本条并划走**，不要对同一条反复进主页。完整规则见 [`skip-on-item-failure.md`](pitfalls/skip-on-item-failure.md)。

```javascript
let permission = require('../common/permission.js');
// let page = require('../common/dy/page.js');
// let video = require('../common/dy/video.js');

if (!permission.ensureRun()) {
} else {
  let maxCount = 20;
  let processed = 0;
  let skipCount = 0;

  while (processed < maxCount) {
    if (!page.isFeed()) {
      page.dismissAppDialogs && page.dismissAppDialogs();
      page.ensureFeed();
      if (!page.isFeed()) {
        skipCount++;
        processed++;
        page.ensureFeed();
        if (page.isFeed()) {
          page.swipeNext();
        }
        continue;
      }
    }

    // 进主页最多 1 次；失败返回占位，禁止重进
    let author = video.getAuthorOnce();
    // like / comment ...

    processed++;
    if (processed < maxCount) {
      page.swipeNext();
    }
  }

  Engines.closeAll();
}
```

未配 `floatWindow.menus` 时，用户可连点悬浮球两次停止。不必生成 stop 菜单。

## 仅当用户要悬浮窗菜单时

与 JSON `menus` **同一轮**生成。完整示例见 [`floatWindow.md`](../01-ui/capabilities/floatWindow.md)。要点：

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
- **刷流**：`continue` 若未划走当前内容，须有 skip 上限并最终强制前进；进主页单次尝试。见 [`skip-on-item-failure.md`](pitfalls/skip-on-item-failure.md)。
