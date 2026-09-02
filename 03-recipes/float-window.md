# 悬浮球完整配方（JSON + 事件一次交付）

用户要「悬浮球 / 悬浮窗菜单 / 跳过 / 停止」时，**不要只写 `deekeScript.json` 里的 `menus`**。菜单项点击要么走内置 `action`，要么必须在 JS 里用 `FloatWindow.on` 绑定——**缺一半就点不动或点了没反应**。

先读 [`01-ui/capabilities/floatWindow.md`](../01-ui/capabilities/floatWindow.md) 的 action 表与决策树。

## 何时需要配 floatWindow

| 用户需求 | 是否写 `floatWindow.menus` |
|----------|---------------------------|
| 只要连点两次停止（默认） | **不写**（或 `menus: []` 且不用 `FloatWindow.setMenus`） |
| 展开菜单：开始 / 停止 / 隐藏 / 跳过 等 | **必须写** `menus` + 对应 JS 绑定 |
| 任务里要「跳过当前步骤」 | `menus` 里加 `onTap` 项 + `tasks/*.js` 里 `FloatWindow.on` |

## 一次交付清单（AI 必做）

生成悬浮球时，同一轮输出里必须包含：

- [ ] `deekeScript.json` → `floatWindow.menus`（每项 `id`、`icon`、`label`、`show` 写全）
- [ ] 每个 **`onTap` 菜单项** 或 **`action: "start"` 且需自定义启动脚本** 的项 → `tasks/*.js`（或 `page.js`）里的 `FloatWindow.on({ ... })`
- [ ] 任务脚本里 `FloatWindow.on` 与 `while` 循环共用同一套标志（如 `skipped`）
- [ ] 若菜单用 `action: "executeScript"` → 同轮写出 `file` 指向的 `tasks/xxx.js` 文件
- [ ] 需要「停止」→ JSON 里 `action: "stop"`（不要自己写 `onTap` 代替）

**禁止**：只生成 `menus` 数组，不生成 `FloatWindow.on`（除非该项纯内置 `stop` / `hide` / `executeScript+file`）。

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
        "action": "start",
        "show": "idle"
      },
      {
        "id": "stop",
        "icon": "close",
        "label": "停止",
        "action": "stop",
        "show": "running"
      },
      {
        "id": "hide",
        "icon": "hide",
        "label": "隐藏",
        "action": "hide",
        "show": "always"
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

说明：

- `stop` / `hide`：只写 `action`，**不需要** `FloatWindow.on`
- `start`：框架会尝试启动当前工程主脚本；若要从菜单启动指定 `tasks/xxx.js`，改用下面「启动任务」写法
- `skip`：只有 `onTap` 名，**必须**在任务脚本里 `FloatWindow.on`

### 2. `tasks/sample.js`（与菜单同一轮给出）

```javascript
let permission = require('common/permission.js');

if (!permission.ensureRun()) {
} else {
  let skipped = false;

  FloatWindow.on({
    start: function () {
      // 若页面已启动过任务，这里可留空；或统一从这里启动：
      // Engines.executeScript('tasks/sample.js');
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
let permission = require('common/permission.js');

Page({
  onRun() {
    permission.runScript('tasks/sample.js');
  }
});
```

页面启动后，任务脚本里的 `FloatWindow.on` 会在任务运行时注册；`show: "running"` 的项（停止、跳过）在脚本跑起来后出现。

## 常见菜单项怎么定义 action

| 用户要什么 | JSON 写法 | 还要不要 JS |
|------------|-----------|-------------|
| 停止任务 | `"action": "stop"` | 否 |
| 隐藏悬浮球 | `"action": "hide"` | 否 |
| 运行某个脚本文件 | `"action": "executeScript", "file": "tasks/foo.js"` | 写出 `tasks/foo.js` |
| 从菜单启动主任务 | `"action": "start"` 或 `"onTap": "onStart"` + `FloatWindow.on` 里 `Engines.executeScript('tasks/xxx.js')` | 自定义启动时 **要** |
| 跳过 / 暂停一步 / 改菜单文案 | 不要写 `action`，写 `"onTap": "onSkip"` 或 `"id": "skip"` | **必须** `FloatWindow.on` + 任务里标志位 |

## action 合法值（仅此四个）

```
stop | hide | start | executeScript
```

不要把 `tasks/xxx.js`、函数名、`Engines.executeScript(...)` 写进 `action`。

## show 与运行时显隐

| show | 何时显示 |
|------|----------|
| `always` | 一直显示（默认） |
| `idle` | 没有脚本在跑 |
| `running` | 脚本运行中 |

运行中若没有 `stop` 项，框架会自动补一个「停止」。仍建议自己写 `stop`，避免文案/图标不一致。

## 绑定写在哪

| 绑定内容 | 推荐文件 |
|----------|----------|
| `FloatWindow.on`（跳过、自定义开始） | **`tasks/*.js` 开头**（与循环同文件） |
| 页面点「运行」 | `page.js` 的 `permission.runScript` |
| 仅 `stop` / `hide` / `executeScript+file` | 只改 JSON 即可 |

`FloatWindow.on` 不要只写在 `page.js` 而任务逻辑在 `tasks/`——页面运行时绑定的回调，任务线程里可能拿不到或时机不对。**自定义菜单行为跟任务走，写在 `tasks/*.js`。**

## 与页面 `action` 的区别

| | 页面 `page.json` 的 `action` | 悬浮球 `floatWindow.menus` 的 `action` |
|--|------------------------------|----------------------------------------|
| 合法值 | `navigate` / `switchTab` / `toast` / `save` / … | **仅** `stop` / `hide` / `start` / `executeScript` |
| 执行脚本 | **禁止** | 用 `executeScript` + `file`，或 `onTap` + `FloatWindow.on` |

两套 `action` 完全不同，不要混用。
