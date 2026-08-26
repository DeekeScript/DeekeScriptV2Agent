# UI 与脚本数据共享

页面负责收集配置并启动脚本；脚本负责读配置、找节点、点击。两边不共享 JS 变量，只共享 [`Storage`](api/Storage.md)。启动脚本用 [`Engines.executeScript`](api/Engines.md)，路径相对项目根。

## 页面写入，脚本读取

`pages/*/page.js`：

```javascript
let permission = require('common/permission.js');

Page({
  data: {
    keyword: '发送',
    max_count: 20
  },
  onSave() {
    Storage.put('myapp.keyword', this.data.keyword);
    Storage.putInteger('myapp.max_count', this.data.max_count);
  },
  onRun() {
    this.onSave();
    permission.runScript('tasks/xxx.js');
  }
});
```

`tasks/xxx.js`：

```javascript
let permission = require('common/permission.js');
if (!permission.ensureRun()) {
} else {
  let keyword = Storage.get('myapp.keyword');
  let maxCount = Storage.getInteger('myapp.max_count');
  console.log(keyword, maxCount);
}
```

读写类型必须成对：`put` / `get`（字符串）、`putInteger` / `getInteger`、`putBoolean` / `getBoolean`、`putDouble` / `getDouble`、`putObj` / `getObj`、`putArray` / `getArray`。类型不对会读错。

## 键名

建议项目前缀，避免和系统键、其它模块撞车。例如 `myapp.keyword`、`myapp.max_count`。不要用过短的全局名（如 `keyword`）。

`Storage.create('其它库名')` 会换一套库；页面和脚本必须 `create` 同一个名字才能读到。不调用 `create` 时走默认库，页面表单与 `Storage.put` 默认也在这套库。

## 启动路径

```javascript
Engines.executeScript('tasks/xxx.js');
```

不以 `./`、`../` 开头时，相对**项目根**。不要写磁盘绝对路径。完整规则见 [`require.md`](require.md) 与 [`api/Engines.md`](api/Engines.md)。

## 不要把脚本塞进 `action`

悬浮球 `floatWindow.menus` 的 `action` 只能是内置名：`start`、`stop`、`hide`、`executeScript`。不要写成脚本路径或一段 JS。

启动任务：在 `FloatWindow.on` 的 `start` 里调用 `Engines.executeScript`，或 JSON 里 `action: "executeScript"` 并设 `file`。`stop` 由框架执行（等同 `Engines.closeAll()`），不要用自定义 `onTap` 替换。

```javascript
FloatWindow.on({
  start: function () {
    Engines.executeScript('tasks/xxx.js');
  }
});
```

## 注意

- `page.js` 的 `action` / 事件里只做存配置、调 `runScript` / `executeScript`。找节点、循环点击放在 `tasks/*.js`。
- 脚本与页面是不同运行时：页面 `let` 变量脚本读不到。
- 后台提示用 [`FloatDialogs`](api/FloatDialogs.md)。骨架见 [`task-template.md`](task-template.md)。
