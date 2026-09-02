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



## 关闭任务：底层逻辑（必读）

JS 里有两个**对外**停止入口，语义不同，不能混用。

| JS API | 关闭范围 | 须在什么上下文调用 |
|--------|----------|-------------------|
| `Engines.closeAll()` | **当前这段任务脚本**及其用 Engines 拉起的子脚本 | 必须在 **`tasks/*.js` 执行线程**内 |
| `FloatWindow.stopTask()` | **整项项目任务**（主脚本 + 全部子脚本） | 悬浮窗菜单回调、页面等均可；并恢复悬浮球 UI |

`Engines.closeAll()` 在悬浮窗菜单回调里**无效**（回调不在任务脚本线程）。菜单里停任务必须用 `FloatWindow.stopTask()`。

### 手动停止 vs 自动停止

| 场景 | 用什么 | 说明 |
|------|--------|------|
| **用户手动**点悬浮窗菜单「停止」 | `FloatWindow.stopTask()` | 写在 `FloatWindow.on` 里 |
| **用户手动**连点开发器球 / 未配菜单的项目球 | 框架内置 | 无需写 JS |
| **自动**结束（条件满足、循环跑完） | `Engines.closeAll()` | 写在 **`tasks/*.js`** 内 |
| **自动**结束但回调不在任务脚本线程 | `FloatWindow.stopTask()` | 与手动停同一套对外 API |

原则：**手动停 → `FloatWindow.stopTask()`**；**自动停 → 优先在 `tasks/*.js` 里 `Engines.closeAll()`**；非任务线程触发的整项结束 → `FloatWindow.stopTask()`。



```javascript

// 手动：悬浮窗菜单（tasks/*.js 或 common/floatMenu.js）

FloatWindow.on({

  stop: function () {

    FloatWindow.collapse();

    FloatWindow.stopTask();

    FloatDialogs.toast('任务已停止');

  }

});



// 自动：任务脚本内部

if (done || skipped) {

  Engines.closeAll();

}

```



Engines 侧说明见 [`02-script/api/Engines.md`](../../02-script/api/Engines.md#关闭任务底层逻辑)。



## AI 生成决策树



```

用户要悬浮球菜单？

├─ 否 → 不写 floatWindow（或不要 menus）

└─ 是 → 同一轮必须输出：

         ① deekeScript.json → floatWindow.menus（id / icon / label / show）

         ② tasks/*.js 或 common/*.js → FloatWindow.on 绑定每一项点击

         ③ 示例：stop → FloatWindow.stopTask()；hide → FloatDialogs.setFloatWindowVisible(false)

```



**典型错误**：只写 `"onTap": "onSkip"` 却不写 `FloatWindow.on({ skip: function () { ... } })` → 点击无反应。



**没有内置 action**：不要写 `"action": "stop"` / `"start"` / `"hide"` / `"executeScript"`，框架不会代执行。



## menus 字段



写在 `deekeScript.json` 的 `floatWindow.menus`。最多展示 **5** 个（超出截断）。



| 字段 | 类型 | 必填 | 说明 |

|------|------|------|------|

| id | String | 建议 | `FloatWindow.on` / `update` 的键。不写时回退为 `onTap` 名 |

| icon | String | 建议 | 内置 `close` / `play` / `hide`，或工程内图片路径 |

| label | String | 建议 | 图标下方文案 |

| onTap | String | 建议 | 点击函数名；**须**在 JS 里 `FloatWindow.on` 绑定 |

| show | String | 否 | `always`（默认）/ `running` / `idle` |

| background | String | 否 | 圆形底色，如 `#FFFFFF`、`#FFE8E6`（停止项常用） |



## 点击行为（用户自定义）



框架**只负责展开菜单、回调 JS**，不内置开始/停止/隐藏/跑脚本。在 `FloatWindow.on` 里写：



| 用户要什么 | 示例回调 |

|------------|----------|

| 停止任务 | `FloatWindow.stopTask()` |

| 隐藏悬浮球 | `FloatDialogs.setFloatWindowVisible(false)` |

| 启动任务 | `Engines.executeScript('tasks/xxx.js')` |

| 跳过 / 改菜单状态 | 设标志位 + `FloatWindow.update(...)` |



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



对应 **`tasks/*.js` 或 `common/floatMenu.js` 必须同时存在**（见 [`float-window.md`](../../03-recipes/float-window.md)）。



## FloatWindow API（运行时）



d.ts 未声明；**page.js 与 tasks.js 均可调用**。显隐球用 [`FloatDialogs.setFloatWindowVisible`](../../02-script/api/FloatDialogs.md)。



| 方法 | 作用 |

|------|------|

| `FloatWindow.setMenus(menus)` | 运行时替换菜单；脚本结束后恢复 JSON |

| `FloatWindow.on(id, fn)` | 给菜单 id 绑点击 |

| `FloatWindow.on({ id: fn, ... })` | 一次绑多个 |

| `FloatWindow.update(id, patch)` | 改 label / icon / background / visible |

| `FloatWindow.collapse()` | 收起展开菜单 |
| `FloatWindow.stopTask()` | **从悬浮窗停止当前项目任务**（菜单里点停止用这个，不要用 `Engines.closeAll()`） |



`onTap` 解析顺序：JS 里 `FloatWindow.on` 注册的回调 → JSON 的 `onTap` 同名全局函数 → `on(id)` 与 `id` 相同。



### 绑定示例（写在 tasks/*.js 或 common/floatMenu.js）



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

  {

    id: 'stop',

    icon: 'close',

    label: '停止',

    onTap: function () { FloatWindow.stopTask(); },

    show: 'running',

    background: '#FFE8E6'

  },

  { id: 'skip', icon: 'img/skip.png', label: '跳过', onTap: function () { skipped = true; }, show: 'running' }

]);

```



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


