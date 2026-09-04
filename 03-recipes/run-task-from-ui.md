# 从界面运行任务

按钮 `onTap` → 检查权限 → `Engines.executeScript`。`page.js` 只负责启动，业务写在 `tasks/*.js`。见 [`events.md`](../01-ui/events.md)、[`page-json.md`](../01-ui/page-json.md#json-action)。

相关：[`Engines.md`](../02-script/api/Engines.md)、[`Access.md`](../02-script/api/Access.md)、[`Storage.md`](../02-script/api/Storage.md)、[`donts.md`](../04-cheatsheets/donts.md)。

## `pages/task/page.json`

```json
{
  "title": {
    "text": "任务",
    "fontSize": 18,
    "color": "#FFFFFF",
    "background": "#006A65"
  },
  "style": {
    "background": "#F5F5F5",
    "padding": 12
  },
  "body": [
    { "type": "input", "name": "task_name", "label": "任务名", "variant": "box" },
    { "type": "notice", "text": "上次脚本：{{lastFile}}" },
    {
      "type": "row",
      "style": { "gap": 8 },
      "children": [
        {
          "type": "button",
          "text": "保存",
          "onTap": "onSave",
          "action": { "type": "save", "toast": "已保存" },
          "style": { "weight": 1, "background": "#EEF2F1", "color": "#006A65" }
        },
        { "type": "button", "text": "立即运行", "onTap": "onRun", "style": { "weight": 1, "background": "#006A65", "color": "#FFFFFF" } }
      ]
    }
  ]
}
```

## `pages/task/page.js`

```javascript
let permission = require('../../common/permission.js');

Page({
  data: {
    task_name: '示例任务',
    lastFile: ''
  },
  onLoad: function () {
    let name = Storage.get('demo.task_name');
    if (name) {
      this.setData({ task_name: name });
    }
    let lastFile = Storage.get('demo.last_task');
    if (lastFile) {
      this.setData({ lastFile: lastFile });
    }
  },
  onSave: function () {
    Storage.put('demo.task_name', this.data.task_name);
  },
  onRun: function () {
    Storage.put('demo.task_name', this.data.task_name);
    Storage.put('demo.last_task', 'tasks/sample.js');
    this.setData({ lastFile: 'tasks/sample.js' });
    permission.runScript('tasks/sample.js');
  }
});
```

`Engines.executeScript` / `runScript` 的路径相对**项目根**，不要写成 `./tasks/sample.js`。`require` **优先**相对当前文件，见 [`require.md`](../02-script/require.md)。

## `tasks/sample.js`

```javascript
let permission = require('../common/permission.js');
if (!permission.ensureRun()) {
} else {
  let name = Storage.get('demo.task_name');
  console.log('运行任务', name);
  System.toast('开始：' + name);
}
```

默认检查无障碍 + 悬浮窗。图色再查 `Access.isMediaProjectionEnable()`，HID 再查蓝牙，见对应 API 卡。

## 注意

- `onTap` 与 `action` 同时存在时，先调 JS 再执行 `action`。`save` 只负责 toast。
- 列表项运行：`onRun(e) { Engines.executeScript(e.item.jsFile); }`，`jsFile` 来自 bind 数据。
- 不要在 `page.js` 里写找节点循环；那是任务脚本的工作。
