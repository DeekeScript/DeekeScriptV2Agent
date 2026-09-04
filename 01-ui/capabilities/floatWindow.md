# 悬浮球（项目悬浮窗）

配置项目悬浮窗菜单时**只读这篇**：JSON `menus` 与 `FloatWindow.on` **同一轮**交付。

**用户没提自定义菜单时：不要写 `floatWindow`。** 默认连点两次停止（第一次变关闭图标，3 秒内再点）。硬规则见 [`constraints.md`](../../00-core/constraints.md) MUST 10–11。

`floatWindow.menus` / `FloatWindow` 只作用于**项目悬浮窗**（点「运行」进项目后，或打包 App）。开发器那颗球不读这份配置。

## 停任务（权威）

| JS API | 关闭范围 | 上下文 |
|--------|----------|--------|
| `Engines.closeAll()` | 当前任务脚本 + 其子脚本 | **仅** `tasks/*.js` 执行线程 |
| `FloatWindow.stopTask()` | 整项项目任务 + 恢复球 UI | 菜单回调 / 页面等 |

菜单 / 页面里 `Engines.closeAll()` **无效**。手动停 → `stopTask`；自动停 → 任务内 `closeAll`。

```javascript
FloatWindow.on({
  stop: function () {
    FloatWindow.collapse();
    FloatWindow.stopTask();
  }
});

// tasks/*.js 内自动结束
if (done) {
  Engines.closeAll();
}
```

## 生成决策

```
用户要悬浮球菜单？
├─ 否 → 不写 floatWindow
└─ 是 → 同一轮输出：
       ① deekeScript.json → floatWindow.menus（每项 onTap）
       ② FloatWindow.on 绑定全部菜单项
       ③ 停止 → FloatWindow.stopTask()；页面按钮同理（禁止 Engines.closeAll）
```

典型错误：只写 `"onTap": "onSkip"` 却不写 `FloatWindow.on({ skip: ... })` → 点击无反应。

## menus 字段

写在 `deekeScript.json` 的 `floatWindow.menus`，最多 **5** 个。

| 字段 | 类型 | 说明 |
|------|------|------|
| id | String | `FloatWindow.on` / `update` 的键 |
| icon | String | 内置 `close` / `play` / `hide`，或工程内图片路径 |
| label | String | 图标下方文案 |
| onTap | String | 点击函数名；须在 JS 里 `FloatWindow.on` 绑定 |
| show | String | `always`（默认）/ `running` / `idle` |
| background | String | 圆形底色，如 `#FFE8E6` |

| 用户要什么 | 回调 |
|------------|------|
| 停止 | `FloatWindow.stopTask()` |
| 隐藏 | `FloatDialogs.setFloatWindowVisible(false)` |
| 启动 | `Engines.executeScript('tasks/xxx.js')` |
| 跳过 | 设标志 + `FloatWindow.update(...)` |

## 完整 JSON 示例

```json
{
  "floatWindow": {
    "menus": [
      { "id": "start", "icon": "play", "label": "开始", "onTap": "onStart", "show": "idle" },
      { "id": "stop", "icon": "close", "label": "停止", "onTap": "onStop", "show": "running", "background": "#FFE8E6" },
      { "id": "hide", "icon": "hide", "label": "隐藏", "onTap": "onHide" },
      { "id": "skip", "icon": "img/skip.png", "label": "跳过", "onTap": "onSkip", "show": "running" }
    ]
  }
}
```

对应 JS 必须同时存在（见下方完整任务示例）。

## FloatWindow API

`page.js` 与 `tasks.js` 均可调用。显隐球用 [`FloatDialogs.setFloatWindowVisible`](../../02-script/api/FloatDialogs.md)。

| 方法 | 作用 |
|------|------|
| `FloatWindow.setMenus(menus)` | 运行时替换菜单；脚本结束后恢复 JSON |
| `FloatWindow.on(id, fn)` / `on({...})` | 绑点击 |
| `FloatWindow.update(id, patch)` | 改 label / icon / background / visible |
| `FloatWindow.collapse()` | 收起菜单 |
| `FloatWindow.stopTask()` | 从悬浮窗停整项任务 |

```javascript
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
    FloatWindow.update('skip', { label: '已跳过', background: '#E8F5E9' });
  }
});
```

## 权限

未开悬浮窗权限时球不会出现。先 `Access.isFloatWindowsEnabled()`。

```javascript
if (!Access.isFloatWindowsEnabled()) {
  Dialogs.confirm('提示', '未开启悬浮窗权限，是否前往设置？', function (ok) {
    if (ok) {
      Access.openFloatWindowsSetting();
    }
  });
} else {
  FloatDialogs.setFloatWindowVisible(true);
}
```

## 完整任务示例（与 menus 同一轮）

```javascript
let permission = require('../common/permission.js');
let skipped = false;

let task = {
  run() {
    if (!permission.ensureRun()) {
      return;
    }
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
        FloatWindow.update('skip', { label: '已跳过', background: '#E8F5E9' });
      }
    });
    var i = 0;
    while (i < 20 && !skipped) {
      var btn = UiSelector().text('发送').findOne();
      if (btn) {
        btn.click();
      }
      System.sleep(1000);
      i++;
    }
  }
};
task.run();
```

`FloatWindow.on` 写在 `tasks/*.js` 开头或 `common/floatMenu.js`，不要只写在 `page.js`。页面「运行」仍用 `permission.runScript`。页面 JSON `action` 与悬浮球 menus 无关。

| 用户要什么 | 是否写 `floatWindow.menus` |
|----------|---------------------------|
| 未提及，或只要能停 | **不写**（连点两次，3 秒内） |
| 展开：开始 / 停止 / 隐藏 / 跳过 | **必须** menus + `FloatWindow.on` |

## 相关

- 任务骨架：[`task-template.md`](../../02-script/task-template.md)
- API 卡：[`FloatWindow.md`](../../02-script/api/FloatWindow.md)
- 入口字段：[`entry-json.md`](../entry-json.md)
