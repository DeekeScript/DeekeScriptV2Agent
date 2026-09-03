# 标准任务骨架

自动化脚本放在 `tasks/*.js`。入口不要写业务细节，按下面顺序：权限 → 读配置 → 可选绑定悬浮球 → `while` 循环。停止在 `FloatWindow.on` 里调 `FloatWindow.stopTask()`；跳过靠脚本里自己设的标志。

依赖：[`permission.md`](permission.md)、[`ui-and-task.md`](ui-and-task.md)、[`require.md`](require.md)、[`api/INDEX.md`](api/INDEX.md)。

## 流程

1. `require('../common/permission.js')`，调用 `ensureRun()`。默认检查无障碍 + 悬浮窗；未开则弹窗引导并结束。
2. 用 `Storage.get` / `getInteger` 等读取页面写入的配置。键名加项目前缀，见 [`ui-and-task.md`](ui-and-task.md)。
3. （可选）`FloatWindow.on` 绑定开始/停止/跳过等——**与 JSON menus 同一轮、同一文件**。示例：`stop` → `FloatWindow.stopTask()`。完整菜单见 [`03-recipes/float-window.md`](../03-recipes/float-window.md)。
4. `while` 里找节点、点击、休眠。循环条件同时看次数和跳过标志。点悬浮球「停止」会关掉整个运行时，循环自然结束。

## 完整最小 `tasks/xxx.js`

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

  let skipped = false;
  FloatWindow.on({
    skip: function () {
      skipped = true;
      FloatWindow.update('skip', {
        label: '已跳过',
        background: '#E8F5E9'
      });
    }
  });

  let i = 0;
  while (i < maxCount && !skipped) {
    let btn = UiSelector().text(keyword).findOne();
    if (btn) {
      btn.click();
    }
    System.sleep(1000);
    i++;
  }
}
```

页面侧保存配置并启动（`pages/*/page.js`）：

```javascript
let permission = require('../../common/permission.js');

Page({
  data: {
    keyword: '发送'
  },
  onSave() {
    Storage.put('myapp.keyword', this.data.keyword);
    Storage.putInteger('myapp.max_count', 20);
  },
  onRun() {
    this.onSave();
    permission.runScript('tasks/xxx.js');
  }
});
```

## 注意

- `ensureRun()` 弹窗是异步的：未授权时立刻返回 `false`，调用方必须停下来，不要继续找节点。
- `Engines.executeScript('tasks/xxx.js')` 路径相对**项目根**。规则见 [`require.md`](require.md) 与 [`api/Engines.md`](api/Engines.md)。
- 后台 toast / 弹窗用 [`FloatDialogs`](api/FloatDialogs.md)，不要用 `Dialogs` / `System.toast`。
- 找节点、点击用 [`UiSelector`](api/UiSelector.md) 与 [`UiObject`](api/UiObject.md)。坐标手势用 [`Gesture`](api/Gesture.md)。
- **`while` 里 `continue` 必须递增循环变量或设 retry 上限**，否则检测失败时会无限弹 toast、脚本像卡死。
