# 保持 DeekeScript 存活（禁止连按返回）

`/ai`（8080 节点查看、`run`、`write`）跑在 **DeekeScript 进程**里。调试时从目标 App 点进系统设置后，Activity 栈往往是：

```text
DeekeScript → 目标 App → 系统设置（应用通知 / 无障碍 / 权限）
```

此时 `Gesture.back()` 是系统返回键，会按栈弹出。**连按两次就会把 DeekeScript 也关掉**：`status.floatService` 变 false、`scriptRunning` 卡住、`run` 返回 409。这不是「退回小红书失败」，而是把调试宿主杀掉了。

相关：[`page-state.md`](./page-state.md)、[`skip-on-item-failure.md`](./skip-on-item-failure.md)、[`Gesture.md`](../api/Gesture.md)、[`device.md`](../../00-core/device.md)、[`System.md`](../api/System.md#currentpackage)。

## 硬规则（MUST）

1. **调试期间禁止把 DeekeScript 退出后台。** 不要 `Gesture.home()`、不要滑掉最近任务里的 DeekeScript、不要对未知页面循环 `Gesture.back()`。
2. **`Gesture.back()` 只用于仍在目标 App 包名内的 overlay**（评论半屏、个人页、目标 App 自己的弹层）。每次最多 1 次，然后重新 `snapshot` / 找互斥节点，确认还在目标 App。
3. **窗口包名用节点，不用 `System.currentPackage()`。** `currentPackage()` 常仍是 DeekeScript 包名（见 System 篇）。前台窗口看 `/ai/snapshot` 根节点 `packageName`，或 `node.getPackageName()`。
4. **误入系统设置：不要 back。** 看到 `com.android.settings`、标题「应用通知 / 无障碍 / 应用信息」、`向上导航`，应 `App.launch(目标包名)` 拉回目标 App。一次 launch 回不去 → **停下来让用户打开 DeekeScript + 目标 App**，禁止再 back。
5. **目标 App 权限弹窗不要点「确认 / 允许 / 去开启 / 去设置」。** 这类按钮会跳进系统设置。只点「关闭 / 取消 / 暂不 / 以后再说 / 我知道了」，或忽略弹窗继续找目标页互斥节点。

## 反例（会把宿主退出）

```javascript
// 错误：从系统设置连按返回，栈上的 DeekeScript 会被一起关掉
var i = 0;
while (i < 6) {
  Gesture.back();
  System.sleep(700);
  i++;
}
App.launch('com.xingin.xhs');
```

```javascript
// 错误：把「确认」塞进关弹窗列表。小红书「打开通知…确认」会进系统设置
var labels = ['确认', '允许', '去开启'];
```

## 正例

```javascript
var TARGET = 'com.xingin.xhs';
var SETTINGS = 'com.android.settings';

module.exports = {
  windowPkg() {
    var n = UiSelector().findOne();
    return n ? String(n.getPackageName() || '') : '';
  },

  isTargetApp() {
    var pkg = this.windowPkg();
    return pkg.indexOf(TARGET) === 0;
  },

  isSystemSettings() {
    var pkg = this.windowPkg();
    if (pkg.indexOf(SETTINGS) === 0) {
      return true;
    }
    if (UiSelector().text('应用通知').findOne()) {
      return true;
    }
    if (UiSelector().text('无障碍').findOne() && UiSelector().desc('向上导航').findOne()) {
      return true;
    }
    return false;
  },

  recoverToTarget() {
    if (this.isTargetApp()) {
      return true;
    }
    if (this.isSystemSettings()) {
      console.log('in system settings, launch target instead of back');
      App.launch(TARGET);
      System.sleep(2500);
      return this.isTargetApp();
    }
    App.launch(TARGET);
    System.sleep(2500);
    return this.isTargetApp();
  },

  dismissAppDialogs() {
    var labels = ['我知道了', '以后再说', '取消', '关闭', '暂不', '不同意'];
    var i = 0;
    while (i < labels.length) {
      var btn = UiSelector().text(labels[i]).findOne();
      if (btn) {
        btn.click();
        System.sleep(600);
        return true;
      }
      i++;
    }
    return false;
  }
};
```

`ensureFeed` 一类恢复：**先**确认窗口仍是目标包名，再关 overlay；不在目标包名就 `App.launch`，不要 `while` 里 `Gesture.back()`。

## 已杀掉宿主时

`status` 出现 `floatService: false`、`websocketServer: false`，或 `run` 一直 409 / stop 说「没有脚本」但 `scriptRunning: true`：

1. **停止自动 back / launch / run。**
2. 请用户重新打开 DeekeScript（侧栏「节点查看」仍开着），再 `status`。
3. 用户恢复前不要假装还能调试。

## 自检

- [ ] 关弹窗列表没有「确认 / 允许 / 去开启 / 去设置」
- [ ] 没有 `while` + `Gesture.back()` 且中间不重新看 `packageName`
- [ ] 系统设置页用 `App.launch(目标)`，不用返回键清栈
- [ ] 宿主挂了会停下来问用户，而不是继续手势
