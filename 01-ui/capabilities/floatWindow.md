# 悬浮球（项目悬浮窗）

配置项目悬浮窗菜单、绑点击、改图标时读这篇。**生成代码时必须与 [`03-recipes/float-window.md`](../../03-recipes/float-window.md) 一起用**：JSON 菜单和 `FloatWindow.on` 要同一轮交付。

`floatWindow.menus` 与 `FloatWindow` **只作用于项目悬浮窗**（点「运行」进入项目后，或打包 App）。DeekeScript 开发器那颗球不读这份配置。

## 两种球（不要混）

| | DeekeScript 开发器 | 项目悬浮窗 |
|--|-------------------|------------|
| 出现 | 工程列表、编辑器等 | 点「运行」进入项目页面后 |
| 点球 | **连点两次**停止任务 | 展开扇形菜单（仅当配置了 `floatWindow.menus` 或 `FloatWindow.setMenus`） |
| 未配菜单时 | 连点两次停止 | **同样连点两次停止**（与开发器一致） |
| 任务运行中 | 悬浮球旋转 | 悬浮球旋转 |

未配置 `floatWindow.menus`（且未调用 `FloatWindow.setMenus`）时，不要生成空菜单占位；默认交互就是连点两次停止。

## AI 生成决策树

```
用户要悬浮球菜单？
├─ 否 → 不写 floatWindow（或不要 menus）
└─ 是 → 同一轮必须输出：
         ① deekeScript.json → floatWindow.menus
         ② 凡 onTap / 自定义 start / skip → tasks/*.js 里 FloatWindow.on
         ③ executeScript 项 → 写出 file 指向的 tasks 文件
         ④ stop / hide 纯内置项 → 只写 JSON 即可
```

**典型错误**：只写 `"onTap": "onSkip"` 却不写 `FloatWindow.on({ skip: function () { ... } })` → 点击无反应。

## menus 字段

写在 `deekeScript.json` 的 `floatWindow.menus`。最多展示 **5** 个（超出截断）。运行中若没有 `stop`，框架自动补停止项。

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | String | 建议 | `FloatWindow.on` / `update` 的键。不写时回退为 `action` 或 `onTap` 名 |
| icon | String | 建议 | 内置 `close` / `play` / `hide`，或工程内图片路径 |
| label | String | 建议 | 图标下方文案 |
| action | String | 见下 | **仅** 四个内置值；与 `onTap` 二选一为主 |
| file | String | 条件 | `action` 为 `executeScript` 时必填，如 `tasks/foo.js` |
| onTap | String | 条件 | 自定义点击：函数名；须在 JS 里 `FloatWindow.on` 绑定 |
| show | String | 否 | `always`（默认）/ `running` / `idle` |
| background | String | 否 | 圆形底色，如 `#FFFFFF` |

## action 定义（核心）

`action` **只能是以下四个内置字符串之一**，大小写按小写写：

| action | 框架行为 | 需要额外 JS |
|--------|----------|-------------|
| `stop` | 停止全部脚本，等同 `Engines.closeAll()` | **否** |
| `hide` | 隐藏悬浮球，等同 `FloatDialogs.setFloatWindowVisible(false)` | **否** |
| `start` | 启动当前工程绑定的主脚本（`getJsFile()`） | 若要从菜单启动指定 `tasks/xxx.js`，改用 `onTap` + `FloatWindow.on` |
| `executeScript` | 执行 `file` 字段指向的脚本（相对项目根） | 写出该 `tasks` 文件；**否**（不必再 on） |

### 禁止写进 action 的内容

| 错误写法 | 正确写法 |
|----------|----------|
| `"action": "tasks/main.js"` | `"action": "executeScript", "file": "tasks/main.js"` |
| `"action": "Engines.executeScript('tasks/x.js')"` | `onTap` + `FloatWindow.on` |
| `"action": "onSkip"` | `"onTap": "onSkip"` + `FloatWindow.on` |
| `"action": "skip"` | 无内置 skip；用 `onTap` 或 `id: "skip"` + `FloatWindow.on` |

### action 与 onTap 怎么选

| 场景 | 用 action | 用 onTap + FloatWindow.on |
|------|-----------|---------------------------|
| 停止 | `stop` | 不要替代 stop |
| 隐藏球 | `hide` | — |
| 跑某个固定脚本文件 | `executeScript` + `file` | — |
| 跳过、暂停一步、改菜单状态 | — | **必须** |
| 菜单里点开始且脚本路径固定 | 可 `onTap` + `Engines.executeScript` | **推荐** |

仅 `stop` / `hide` / `executeScript`+`file` 可以**只配 JSON**。其余自定义行为 **JSON + JS 必须同时生成**。

## show 显隐

| show | 显示时机 |
|------|----------|
| `always` | 始终 |
| `running` | 脚本运行中（停止、跳过常用） |
| `idle` | 未运行（开始按钮常用） |

## 完整 JSON 示例

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

对应 **`tasks/xxx.js` 必须同时存在**（见 [`float-window.md`](../../03-recipes/float-window.md)）。

## FloatWindow API（运行时）

d.ts 未声明；**page.js 与 tasks.js 均可调用**。显隐球用 [`FloatDialogs.setFloatWindowVisible`](../../02-script/api/FloatDialogs.md)。

| 方法 | 作用 |
|------|------|
| `FloatWindow.setMenus(menus)` | 运行时替换菜单；脚本结束后恢复 JSON |
| `FloatWindow.on(id, fn)` | 给菜单 id 绑点击 |
| `FloatWindow.on({ id: fn, ... })` | 一次绑多个 |
| `FloatWindow.update(id, patch)` | 改 label / icon / background / visible |
| `FloatWindow.collapse()` | 收起展开菜单 |

`onTap` 解析顺序：JS 里 `FloatWindow.on` 注册的回调 → JSON 的 `onTap` 同名全局函数 → `on(id)` 与 `id` 相同。

### 绑定示例（写在 tasks/*.js）

```javascript
let skipped = false;

FloatWindow.on({
  start: function () {
    Engines.executeScript('tasks/sample.js');
  },
  skip: function () {
    skipped = true;
    FloatWindow.update('skip', {
      label: '已跳过',
      background: '#E8F5E9'
    });
  }
});
```

### setMenus 示例

```javascript
FloatWindow.setMenus([
  { id: 'stop', icon: 'close', label: '停止', action: 'stop', show: 'running' },
  { id: 'skip', icon: 'img/skip.png', label: '跳过', onTap: 'onSkip', show: 'running' }
]);
```

传空数组 `[]` 表示运行时菜单为空，运行中仍会自动补 `stop`。

## 权限

未开悬浮窗权限时球不会出现。先 `Access.isFloatWindowsEnabled()`，再 `FloatDialogs.setFloatWindowVisible(true)`。

```javascript
if (!Access.isFloatWindowsEnabled()) {
  Dialogs.confirm('温馨提示', '未开启悬浮窗权限时悬浮球无法展示，是否前往设置？', function (ok) {
    if (ok) {
      Access.openFloatWindowsSetting();
    }
  });
} else {
  FloatDialogs.setFloatWindowVisible(true);
}
```

## 相关文档

- 一次交付配方：[`03-recipes/float-window.md`](../../03-recipes/float-window.md)
- 任务骨架（含 FloatWindow.on）：[`02-script/task-template.md`](../../02-script/task-template.md)
- API 卡片：[`02-script/api/FloatWindow.md`](../../02-script/api/FloatWindow.md)
- 入口 JSON 字段：[`entry-json.md`](../entry-json.md)
