# Intent

构造与启动 Android Intent：打开 Activity、启动 Service、发/收广播。日常跳转可优先 `App.gotoIntent` / `App.launch` / `App.openUrl`；需要 extras、flags、组件名时用本模块。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 是 |
| `tasks/*.js` | 是 |

## options 字段

传给 `create` / `startActivity` / `startService` / `sendBroadcast` 的对象：

| 字段 | 类型 | 说明 |
|------|------|------|
| `action` | `string` | 如 `android.intent.action.VIEW` |
| `data` | `string` | URI |
| `type` | `string` | MIME；可与 `data` 同时设 |
| `packageName` / `package` | `string` | 目标包名 |
| `className` | `string` | 与包名一起设组件 |
| `categories` | `string` 或 `string[]` | category |
| `flags` | `number`、字符串名或数组 | 如 `ACTIVITY_NEW_TASK`、`CLEAR_TOP`；也可用数字 |
| `extras` | `object` | 键值 extras（布尔/数字/字符串/字符串数组） |

`startActivity` 未显式带 `ACTIVITY_NEW_TASK` 时会自动补上。也可直接传入已有 `android.content.Intent`。

## 方法

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `Intent.create(options)` | options 或已有 Intent | `android.content.Intent` | 只构造，不启动 |
| `Intent.startActivity(options\|Intent)` | 同上 | `void` | 启动 Activity（打开界面） |
| `Intent.startService(options)` | options | `void` | 启动 Service（见下方场景） |
| `Intent.sendBroadcast(options)` | options | `void` | 发广播 |
| `Intent.registerReceiver(action, callback)` | action 或 action[]、回调 | `void` | 注册接收广播 |
| `Intent.unregisterReceiver(action)` | action | `void` | 取消指定 action |
| `Intent.unregisterAllReceivers()` | 无 | `void` | 取消全部；脚本结束也会自动清 |
| `Intent.open()` | 无 | `void` | 打开**本应用**详情设置页 |
| `Intent.open(uri)` | `uri {string}` | `void` | `ACTION_VIEW` 打开 URI |

## 最小片段

```javascript
Intent.startActivity({
  action: 'android.intent.action.VIEW',
  data: 'https://doc.deeke.cn',
  flags: 'ACTIVITY_NEW_TASK'
});

let i = Intent.create({
  action: 'android.intent.action.SEND',
  type: 'text/plain',
  extras: { 'android.intent.extra.TEXT': 'hello' },
  flags: ['ACTIVITY_NEW_TASK']
});
App.startActivity(i);

Intent.open(); // 本应用详情
Intent.open('https://example.com');
```

## startService 场景与示例

启动 **Service**（后台组件），不打开界面。

适用：按包名 + 类名启动对方已知 Service，或带 `action`/`extras` 触发约定任务。常驻任务请用 [`Foreground.md`](Foreground.md)，不要用本方法在后台保活。

Android 8+ 后台 `startService` 常被限制，可能抛异常；优先显式组件（`packageName` + `className`）。

```javascript
Intent.startService({
  packageName: 'com.example.target',
  className: 'com.example.target.DemoService',
  action: 'com.example.action.DO_WORK',
  extras: { taskId: '123', silent: true }
});

// 包内 action（对方需有 intent-filter）
Intent.startService({
  packageName: 'com.example.target',
  action: 'com.example.action.SYNC'
});
```

## sendBroadcast / registerReceiver

`sendBroadcast` 只负责发送；要用脚本接收，先 [`registerReceiver`](#registerreceiver)。

系统隐式广播在新 Android 上大多收不到，尽量带 `packageName`（或再加 `className`）。

```javascript
Intent.registerReceiver('com.example.action.REFRESH', function (intent) {
  console.log(intent.action, intent.extras);
});

Intent.sendBroadcast({
  action: 'com.example.action.REFRESH',
  extras: { reason: 'manual', count: 1 }
});

setInterval(function () {
  console.log('等待广播中');
}, 10000);
```

```javascript
// 发给其它 App
Intent.sendBroadcast({
  packageName: 'com.example.target',
  action: 'com.example.action.REFRESH',
  extras: { reason: 'manual' }
});

// 显式 Receiver（最稳）
Intent.sendBroadcast({
  packageName: 'com.example.target',
  className: 'com.example.target.CmdReceiver',
  action: 'com.example.action.CMD',
  extras: { cmd: 'ping' }
});
```

### registerReceiver

| 项 | 说明 |
|----|------|
| 参数 | `action {string\|string[]}`，`callback(intent)` |
| 回调字段 | `action`、`data`、`type`、`extras`、`packageName` |
| 清理 | 同 action 再注册会替换；脚本结束自动 `unregisterAllReceivers` |

```javascript
Intent.registerReceiver(['com.example.A', 'com.example.B'], function (intent) {
  console.log(intent.action);
});
// Intent.unregisterReceiver('com.example.A');
// Intent.unregisterAllReceivers();
```

同进程自定义事件也可用 [`Events.emit`](Events.md)，不必走系统广播。

## 相关替代

- [`App.gotoIntent(uri)`](App.md) — 按 URI 跳转
- [`App.launch(packageName)`](App.md) — 按包名打开应用
- [`App.openUrl(url, packageName?)`](App.md) — 打开链接
- [`Foreground.md`](Foreground.md) — 前台服务保活
- [`Events.md`](Events.md) — 同进程事件总线
- 界面外链用 JSON `action: { "type": "openUrl", "url": "..." }` 或 `this.openUrl(url)`，见 [`ui.md`](../../04-cheatsheets/ui.md#json-action)

## 注意

- 不要编造未在本卡列出的字段。
- `startService` / `sendBroadcast` 都要知道目标组件或约定好的 action；猜系统广播名通常无效。
- 索引见 [`INDEX.md`](INDEX.md)。
