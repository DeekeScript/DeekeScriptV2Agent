# 悬浮球完整配方（JSON + 事件一次交付）

**用户没提悬浮窗菜单 / 跳过 / 自定义停止 → 不要写 `floatWindow`。** 未配 menus 时连点两次即可停。

仅当用户明确要菜单时用本配方。停任务规则见 [`floatWindow.md`](../01-ui/capabilities/floatWindow.md#停任务权威)。

停止必须写代码：`"onTap": "onStop"` + `FloatWindow.on({ stop: function () { FloatWindow.stopTask(); } })`。带 `onTap` 的项必须与 `FloatWindow.on` **同一轮**交付，缺 JS 就点不动。

## 何时需要配 floatWindow

| 用户需求 | 是否写 `floatWindow.menus` |
|----------|---------------------------|
| 未提及悬浮窗，或只要能停任务 | **不写**（默认连点两次即可） |
| 只要连点两次停止（默认） | **不写**（或不用 `FloatWindow.setMenus`） |
| 展开菜单：开始 / 停止 / 隐藏 / 跳过 等 | **必须写** `menus` + `FloatWindow.on` |
| 任务里要「跳过当前步骤」 | `menus` + `tasks/*.js` 里标志位与 `FloatWindow.on` |

## 一次交付清单（仅在需要配 menus 时）

- [ ] `deekeScript.json` → `floatWindow.menus`（每项 `id`、`icon`、`label`、`show` 写全）
- [ ] **`FloatWindow.on({ ... })`** 与 menus **同一轮**出现在 `tasks/*.js` 或 `common/floatMenu.js`
- [ ] 停止示例：`FloatWindow.stopTask()`；隐藏：`FloatDialogs.setFloatWindowVisible(false)`
- [ ] 任务脚本里 `FloatWindow.on` 与 `while` 循环共用同一套标志（如 `skipped`）

**禁止**：只生成 `menus` 不写 `FloatWindow.on`。**也禁止**：用户没要求菜单时主动生成 stop 菜单。

## 标准四键菜单（复制改 id 即可）

### 1. `deekeScript.json`

```json
{
  "floatWindow": {
    "menus": [
      {
        "id": "start",
        "icon": "play",
        "label": "开始",
        "onTap": "onStart",
        "show": "idle"
      },
      {
        "id": "stop",
        "icon": "close",
        "label": "停止",
        "onTap": "onStop",
        "show": "running",
        "background": "#FFE8E6"
      },
      {
        "id": "hide",
        "icon": "hide",
        "label": "隐藏",
        "onTap": "onHide"
      },
      {
        "id": "skip",
        "icon": "img/skip.png",
        "label": "跳过",
        "onTap": "onSkip",
        "show": "running"
      }
    ]
  }
}
```

### 2. `tasks/sample.js`（与菜单同一轮给出）

```javascript
let permission = require('../common/permission.js');

if (!permission.ensureRun()) {
} else {
  let skipped = false;

  FloatWindow.on({
    start: function () {
      Engines.executeScript('tasks/sample.js');
    },
    stop: function () {
      FloatWindow.stopTask();
    },
    hide: function () {
      FloatDialogs.setFloatWindowVisible(false);
    },
    skip: function () {
      skipped = true;
      FloatWindow.update('skip', {
        label: '已跳过',
        background: '#E8F5E9'
      });
    }
  });

  let i = 0;
  while (i < 20 && !skipped) {
    let btn = UiSelector().text('发送').findOne();
    if (btn) {
      btn.click();
    }
    System.sleep(1000);
    i++;
  }
}
```

### 3. 从页面按钮启动（与悬浮球「开始」二选一或并存）

`pages/home/page.js`：

```javascript
let permission = require('../../common/permission.js');

Page({
  onRun() {
    permission.runScript('tasks/sample.js');
  }
});
```

## 常见菜单项怎么写

| 用户要什么 | JSON | JS（FloatWindow.on） |
|------------|------|----------------------|
| 停止任务 | `id: "stop"`, `onTap: "onStop"`, `show: "running"` | `stop: function () { FloatWindow.stopTask(); }` |
| 隐藏悬浮球 | `id: "hide"`, `onTap: "onHide"` | `hide: function () { FloatDialogs.setFloatWindowVisible(false); }` |
| 运行脚本 | `id: "start"`, `show: "idle"` | `start: function () { Engines.executeScript('tasks/foo.js'); }` |
| 跳过 | `id: "skip"`, `onTap: "onSkip"`, `show: "running"` | 设 `skipped = true` + `FloatWindow.update` |

## show 与运行时显隐

| show | 何时显示 |
|------|----------|
| `always` | 一直显示（默认） |
| `idle` | 没有脚本在跑 |
| `running` | 脚本运行中 |

## 绑定写在哪

| 绑定内容 | 推荐文件 |
|----------|----------|
| `FloatWindow.on`（开始/停止/跳过/隐藏） | **`tasks/*.js` 开头** 或 `common/floatMenu.js` |
| 页面点「运行」 | `page.js` 的 `permission.runScript` |

**自定义菜单行为跟任务走，写在 `tasks/*.js`。** 不要只写在 `page.js` 而任务在 `tasks/`。

## 与页面 `action` 的区别

页面 `page.json` 的 `action` 是 navigate / toast / save 等界面动作，与悬浮球 menus 无关。悬浮球菜单用 `onTap` + `FloatWindow.on`。
