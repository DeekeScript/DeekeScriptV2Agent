# 从 0 搭最小工程

两种骨架：**只跑脚本（无 UI）**，和 **带一页界面**。项目根必须有 `deekeScript.json`，否则 VS Code 插件无法同步。

生成前对照 [`donts.md`](../04-cheatsheets/donts.md)。不要写 `hooks`，不要漏 `page.js`。

## A. 无 UI（只有入口 + 任务）

### 文件清单

```
deekeScript.json
img/xhs.svg
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

### `tasks/sample.js`

```javascript
if (!Access.isAccessibilityServiceEnabled()) {
  Access.openAccessibilityServiceSetting();
} else if (!Access.isFloatWindowsEnabled()) {
  Access.openFloatWindowsSetting();
} else {
  console.log('sample 开始');
  let node = UiSelector().text('按钮').findOnce();
  if (node) {
    node.click();
  }
  console.log('sample 结束');
}
```

在开发器里直接运行该 JS。不要生成 `pages/`。

---

## B. 带一页界面

### 文件清单

```
deekeScript.json
img/xhs.svg
pages/home/page.json
pages/home/page.js
tasks/sample.js
```

必须带上 `icon` 指向的文件。底栏再用到的 `img/home.png` 等按需添加。

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
  },
  "bottomMenus": [
    {
      "title": "{NAME}",
      "icon": "img/home.png",
      "page": "pages/home"
    }
  ]
}
```

`homePage` 写目录，不必再放进 `pages`。只有一页也可以配一项 `bottomMenus`；不配则隐藏底栏。

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
    { "type": "button", "text": "运行示例", "onTap": "onRun" }
  ]
}
```

### `pages/home/page.js`

每个页面目录都要有 `page.js`，即使几乎是空的也要 `Page({})`。

```javascript
Page({
  data: {
    hello: 'DeekeScript'
  },
  onRun() {
    if (!Access.isAccessibilityServiceEnabled()) {
      Access.openAccessibilityServiceSetting();
      return;
    }
    if (!Access.isFloatWindowsEnabled()) {
      Access.openFloatWindowsSetting();
      return;
    }
    Engines.executeScript('tasks/sample.js');
  }
});
```

### `tasks/sample.js`

与方案 A 相同。路径相对**项目根**。

## 注意

- 脚本不要写在 JSON `action` 里。见 [`run-task-from-ui.md`](./run-task-from-ui.md)。
- V2 无 Hook：[`no-hook.md`](../02-script/api/no-hook.md)。
- 多页时在入口 `pages` 注册别名；自定义组件要注册且 JSON 写 `"component": true`。
