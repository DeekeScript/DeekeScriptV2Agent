# 从 0 搭最小工程

两种骨架：**只跑脚本（无 UI）**，和 **带一页界面**。项目根必须有 `deekeScript.json`，否则无法识别工程、无法同步。

生成前对照 [`donts.md`](../04-cheatsheets/donts.md)。不要写 `hooks`，不要漏 `page.js`。下面示例用默认绿 `#006A65`；用户指定其它主题色时，入口写 `window.theme.primary`，导航栏、状态栏、底栏和 **button 的 `style.background`** 都要改，见 [`_common.md`](../01-ui/components/_common.md)。

## A. 无 UI（只有入口 + 任务）

### 文件清单

```
deekeScript.json
img/xhs.svg
common/permission.js
tasks/sample.js
```

### `deekeScript.json`

```json
{
  "name": "Demo",
  "packageName": "cn.deeke.demo",
  "versionCode": "100",
  "versionName": "1.0.0",
  "icon": "img/xhs.svg"
}
```

`icon` 必填，且 `img/xhs.svg`（或你写的路径）必须在工程里。只跑脚本不必写 `homePage`。打包字段含义见 [`apk.md`](../02-script/api/apk.md)。

### `common/permission.js`

权限模块：把 [`snippets/common-permission.js`](../02-script/snippets/common-permission.js) 整份复制为 `common/permission.js`。不要漏这个文件。

### `tasks/sample.js`

```javascript
let permission = require('../common/permission.js');
if (!permission.ensureRun()) {
} else {
  console.log('sample 开始');
  let node = UiSelector().text('按钮').findOne();
  if (node) {
    node.click();
  }
  console.log('sample 结束');
}
```

找节点用 `UiSelector` + `findOne()`；点击前一般先 `filter` 屏内。在开发器里直接运行该 JS。不要生成 `pages/`。

### `img/xhs.svg`

必须生成这个文件，不能只在 JSON 里写路径：

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10" fill="#006A65"/></svg>
```

---

## B. 带一页界面

### 文件清单

```
deekeScript.json
img/xhs.svg
pages/home/page.json
pages/home/page.js
common/permission.js
tasks/sample.js
```

必须带上 `icon` 指向的文件（内容见方案 A）。一页不必配底栏；要底栏再读 [`tabBar.md`](../01-ui/capabilities/tabBar.md)，并生成底栏图标文件。

### `deekeScript.json`

```json
{
  "name": "Demo",
  "packageName": "cn.deeke.demo",
  "versionCode": "100",
  "versionName": "1.0.0",
  "icon": "img/xhs.svg",
  "homePage": "pages/home",
  "window": {
    "style": {
      "background": "#F5F5F5",
      "padding": 16
    },
    "title": {
      "fontSize": 18,
      "color": "#FFFFFF",
      "background": "#006A65"
    },
    "statusBar": {
      "background": "#006A65",
      "color": "light"
    }
  }
}
```

`homePage` 写目录，不必再放进 `pages`。不配 `bottomMenus` 则隐藏底栏。

### `pages/home/page.json`

```json
{
  "title": {
    "text": "首页",
    "fontSize": 18,
    "color": "#FFFFFF",
    "background": "#006A65"
  },
  "style": {
    "background": "#F5F5F5",
    "padding": 16
  },
  "body": [
    { "type": "title", "text": "{{hello}}" },
    { "type": "notice", "text": "点按钮运行 tasks/sample.js" },
    { "type": "button", "text": "运行示例", "style": { "background": "#006A65", "color": "#FFFFFF" }, "onTap": "onRun" }
  ]
}
```

### `pages/home/page.js`

每个页面目录都要有 `page.js`，即使几乎是空的也要 `Page({})`。

```javascript
let permission = require('../../common/permission.js');

Page({
  data: {
    hello: 'DeekeScript'
  },
  onRun: function () {
    permission.runScript('tasks/sample.js');
  }
});
```

### `tasks/sample.js`

与方案 A 相同。路径相对**项目根**。

## 注意

- 脚本不要写在 JSON `action` 里。见 [`run-task-from-ui.md`](./run-task-from-ui.md)。
- Pro 无 Hook：[`no-hook.md`](../02-script/api/no-hook.md)。
- 多页时在入口 `pages` 注册别名；自定义组件要注册且 JSON 写 `"component": true`。
