# 悬浮球

配置项目悬浮窗菜单、绑点击、改图标、查权限时读这篇。屏幕上有两种球，不要混用：`floatWindow.menus` 和 `FloatWindow` **只作用于项目悬浮窗**。在开发器里执行脚本、或还没点「运行」时，改菜单不会改变开发器那颗球。`menus` 最多 5 个，超过只展示前 5 个。

## 项目球 vs 开发器球

| | DeekeScript 开发器 | 项目里（点「运行」之后，以及打包 App） |
|--|------------------|----------------------------------------|
| 出现时机 | 工程列表、编辑器等开发界面 | 进入项目自己的页面 |
| 作用 | 保持屏幕常亮；任务运行时旋转；**连点两次停止任务** | 同样这三件事，另外可以用菜单定制 |
| 点球 | 第一次变成关闭图标，3 秒内再点才停止 | 展开功能图标，不再用连点两次 |

点项目球后，图标绕球呈扇形展开。球可拖动，松手后吸附左或右：贴右朝左展开，贴左朝右展开；靠顶/靠底收到有空间的一侧；空间不够则球内侧竖排。

运行中若配置里没有「停止」，框架会自动补一个（`Engines.closeAll()`）。显示/隐藏这颗球用 `FloatDialogs`。

## menus 字段

写在 `deekeScript.json` 的 `floatWindow.menus`。

| 参数 | 类型 | 说明 |
|------|------|------|
| id | String | 给 `FloatWindow.on` / `update` 用 |
| icon | String | 内置名 `close` / `play` / `hide`，或工程内图片、SVG |
| label | String | 图标下方短文案 |
| action | String | 内置动作：`stop`、`hide`、`start`、`executeScript` |
| file | String | `action` 为 `executeScript` 时要执行的脚本路径 |
| onTap | String | 点击时调用的 JS 函数名，也可再用 `FloatWindow.on` 绑定 |
| show | String | `always`（默认）、`running`（脚本运行中）、`idle`（未运行） |
| background | String | 圆形底色，如 `#FFFFFF` |

```json
{
  "floatWindow": {
    "menus": [
      { "id": "start", "icon": "play", "label": "开始", "action": "start", "show": "idle" },
      { "id": "stop", "icon": "close", "label": "停止", "action": "stop", "show": "running" },
      { "id": "hide", "icon": "hide", "label": "隐藏", "action": "hide" },
      { "id": "skip", "icon": "img/skip.png", "label": "跳过", "onTap": "onSkip", "show": "running" }
    ]
  }
}
```

## 内置 action

| action | 作用 |
|--------|------|
| stop | 停止全部脚本，等同 `Engines.closeAll()` |
| hide | 隐藏悬浮球，等同 `FloatDialogs.setFloatWindowVisible(false)` |
| start | 开始执行当前任务脚本 |
| executeScript | 执行 `file` 指向的脚本（非主任务） |

`stop` 由框架执行，不要用自定义 `onTap` 替换它。启动、跳过、切换图标用 `FloatWindow.on` 或 JSON 的 `onTap`。开始任务请自己配 `action: "start"`，或在 JS 里调 `Engines.executeScript`。

## FloatWindow.setMenus(menus)

运行时替换菜单。脚本结束后恢复成 JSON 配置。

```javascript
FloatWindow.setMenus([
  { id: 'start', icon: 'play', label: '开始', action: 'start', show: 'idle' },
  { id: 'stop', icon: 'close', label: '停止', action: 'stop', show: 'running' },
  { id: 'skip', icon: 'img/skip.png', label: '跳过', onTap: 'onSkip' }
]);
```

## FloatWindow.on(id, fn)

给某个 id 绑定点击。也可传入对象一次绑多个。JSON 里的 `onTap: "onSkip"` 会找同名函数，或找 `on('onSkip')` / `on('skip')` 绑过的回调。

```javascript
FloatWindow.on('skip', function () {
  FloatWindow.update('skip', { label: '已跳过', background: '#E8F5E9' });
});

FloatWindow.on({
  start: function () {
    Engines.executeScript('tasks/sample.js');
  },
  skip: function () {}
});
```

## FloatWindow.update(id, patch)

改某一个图标的文案、图片、底色。菜单正展开时会立刻刷新。

```javascript
FloatWindow.update('skip', { label: '已跳过', icon: 'img/skip-done.png', background: '#E8F5E9' });
FloatWindow.update('skip', { visible: false });
```

## FloatWindow.collapse()

收起已展开的菜单。

```javascript
FloatWindow.collapse();
```

## 权限

Android 未授予「显示在其他应用上层」时，悬浮球服务创建不了，球不会出现。是否去授权由 JS 决定，不要依赖系统自动弹窗。无权限时不要调用 `setFloatWindowVisible`。授权后请先回到页面，再显示悬浮球。

| API | 作用 |
|-----|------|
| `Access.isFloatWindowsEnabled()` | 是否已授予悬浮窗权限 |
| `Access.openFloatWindowsSetting()` | 打开系统悬浮窗设置 |
| `FloatDialogs.setFloatWindowVisible(true/false)` | 显示 / 隐藏这颗球 |

```javascript
if (!Access.isFloatWindowsEnabled()) {
  Dialogs.confirm('温馨提示', '未开启悬浮窗权限时悬浮球无法展示，是否前往系统设置授权？', function (ok) {
    if (ok) {
      Access.openFloatWindowsSetting();
    }
  });
} else {
  FloatDialogs.setFloatWindowVisible(true);
}
```
