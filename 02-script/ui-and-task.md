# UI 与脚本数据共享

页面负责收集配置并启动脚本；脚本负责读配置、找节点、点击。两边不共享 JS 变量，只共享 [`Storage`](api/Storage.md)。启动脚本用 [`Engines.executeScript`](api/Engines.md)，路径相对项目根。事件字段见 [`events.md`](../01-ui/events.md)。

## 页面 JSON（按钮启动）

```json
{
  "body": [
    { "type": "input", "name": "task_name", "label": "任务名", "variant": "box" },
    {
      "type": "row",
      "style": { "gap": 8 },
      "children": [
        {
          "type": "button",
          "text": "保存",
          "onTap": "onSave",
          "action": { "type": "save", "toast": "已保存" },
          "style": { "weight": 1 }
        },
        { "type": "button", "text": "立即运行", "onTap": "onRun", "style": { "weight": 1 } }
      ]
    }
  ]
}
```

`onTap` 与 `action` 同时存在时先 JS 再 `action`。`save` 只负责 toast。列表项运行：`onRun(e) { Engines.executeScript(e.item.jsFile); }`。

## 页面写入，脚本读取

`pages/*/page.js`：

```javascript
let permission = require('../../common/permission.js');

Page({
  data: {
    keyword: '发送',
    max_count: 20
  },
  onSave() {
    Storage.put('myapp.settings.keyword', this.data.keyword);
    Storage.putInteger('myapp.task.max_count', this.data.max_count);
  },
  onRun() {
    this.onSave();
    permission.runScript('tasks/xxx.js');
  }
});
```

`tasks/xxx.js`：

```javascript
let permission = require('../common/permission.js');
let task = {
  run() {
    if (!permission.ensureRun()) {
      return;
    }
    let keyword = Storage.get('myapp.settings.keyword');
    let maxCount = Storage.getInteger('myapp.task.max_count');
    console.log(keyword, maxCount);
  }
};
task.run();
```

读写类型必须成对：`put` / `get`（字符串）、`putInteger` / `getInteger`、`putBoolean` / `getBoolean`、`putDouble` / `getDouble`、`putObj` / `getObj`、`putArray` / `getArray`。类型不对会读错。

## 键名

默认 `Storage` 跨页共享。禁止用裸字段名（`keyword`、`enabled`）当 key。用 `项目前缀.模块或页面.字段`，例如 `myapp.settings.keyword`、`myapp.task.max_count`。两个页面都可以有控件 `name: "keyword"`，但存盘键不能相同，除非你有意共享同一份配置。

见 [`form-name.md`](../../01-ui/pitfalls/form-name.md)。不要用过短的全局名。

`Storage.create('其它库名')` 会换一套库；页面和脚本必须 `create` 同一个名字才能读到。不调用 `create` 时走默认库，页面表单与 `Storage.put` 默认也在这套库。

## 启动路径

```javascript
Engines.executeScript('tasks/xxx.js');
```

不以 `./`、`../` 开头时，相对**项目根**。不要写磁盘绝对路径。`require` 优先相对当前文件，见 [`require.md`](require.md)；`executeScript` 见 [`api/Engines.md`](api/Engines.md)。

悬浮球菜单的开始、停止、隐藏、跑脚本都在 `FloatWindow.on` 里写（与 JSON **同一轮**生成）。见 [`floatWindow.md`](../01-ui/capabilities/floatWindow.md)。

```javascript
FloatWindow.on({
  start: function () {
    Engines.executeScript('tasks/xxx.js');
  },
  stop: function () {
    FloatWindow.stopTask();
  },
  hide: function () {
    FloatDialogs.setFloatWindowVisible(false);
  }
});
```


## 注意

- `page.js` 的 `action` / 事件里只做存配置、调 `runScript` / `executeScript`。找节点、循环点击放在 `tasks/*.js`。
- 脚本与页面是不同运行时：页面 `let` 变量脚本读不到。
- 后台提示用 [`FloatDialogs`](api/FloatDialogs.md)。骨架见 [`task-template.md`](task-template.md)。
