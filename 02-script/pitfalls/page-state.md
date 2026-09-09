# 页面态误判

用「某个通用 id / 文案存在」判断当前是否在目标页，容易误判。评论列表、个人页、半屏面板里常复用与推荐流相同的 `title`、昵称、`赞` 等节点。

相关：[`stale-node-after-click.md`](./stale-node-after-click.md)、[`skip-on-item-failure.md`](./skip-on-item-failure.md)、[`keep-host-alive.md`](./keep-host-alive.md)、[`device.md`](../../00-core/device.md)、[`UiSelector.md`](../api/UiSelector.md)。

## 硬规则

1. 页面判断用**互斥特征**，不要用列表里也会出现的通用 id（如多处都有的 `title`）。
2. 同一文案多节点时：先 `filter` 屏内，再按区域收窄（右侧操作栏、底部输入区、顶栏）。
3. 卡在半屏 / 评论面板时：先确认窗口仍是**目标 App 包名**（`node.getPackageName()` / snapshot，不要用 `System.currentPackage()`），再点「关闭」。仍在目标 App 内才允许 **一次** `Gesture.back()`。不要假定一次 back 就回到推荐流，更不要 `while` 连按返回——会把栈上的 DeekeScript 退出。见 [`keep-host-alive.md`](./keep-host-alive.md)。
4. 操作循环里检测失败必须递增 `retryCount` 或 `processed`，禁止无上限 `continue`。
5. 进主页遇业务弹窗、读不到抖音号：关弹窗后返回流，**跳过本条前进**，不要再次点头像。见 [`skip-on-item-failure.md`](./skip-on-item-failure.md)。
6. 窗口已是系统设置（`com.android.settings`、标题「应用通知」等）：`App.launch(目标包名)`，禁止 back。

## 推荐流示例（互斥特征）

```javascript
function rightSide(node) {
  if (!node) {
    return false;
  }
  var b = node.bounds();
  if (!b || b.width() <= 0 || b.height() <= 0) {
    return false;
  }
  if (b.left < 0 || b.top < 0 || b.top >= Device.height()) {
    return false;
  }
  return b.left > Device.width() * 0.65;
}

// 用右侧「未点赞 / 已点赞」判断在视频推荐流；不要只用 id/title
function isFeed() {
  if (UiSelector().descContains('未点赞').filter(rightSide).findOne()) {
    return true;
  }
  if (UiSelector().descContains('已点赞').filter(rightSide).findOne()) {
    return true;
  }
  return !!UiSelector().descContains('点赞').descContains('按钮').filter(rightSide).findOne();
}
```

## 关 overlay 再继续

```javascript
function closeOverlays() {
  var closeBtn = UiSelector().desc('关闭').filter(function (n) {
    if (!n) {
      return false;
    }
    var b = n.bounds();
    return b && b.top >= 0 && b.height() > 0 && b.top < Device.height();
  }).findOne();
  if (!closeBtn) {
    closeBtn = UiSelector().descContains('返回').findOne();
  }
  if (closeBtn) {
    closeBtn.click();
    System.sleep(900);
    return true;
  }
  return false;
}

function windowPkg() {
  var n = UiSelector().findOne();
  return n ? String(n.getPackageName() || '') : '';
}

function ensureFeed(targetPkg) {
  var i = 0;
  while (i < 5 && !isFeed()) {
    var pkg = windowPkg();
    if (pkg.indexOf('com.android.settings') === 0) {
      App.launch(targetPkg);
      System.sleep(2000);
      i++;
      continue;
    }
    if (pkg && pkg.indexOf(targetPkg) !== 0) {
      App.launch(targetPkg);
      System.sleep(2000);
      i++;
      continue;
    }
    if (!closeOverlays()) {
      Gesture.back();
      System.sleep(900);
    }
    i++;
  }
  return isFeed();
}
```

## 自检

- [ ] `isXxxPage` 不依赖评论区 / 列表里也会出现的节点
- [ ] 「赞」类文案区分视频点赞 vs 评论点赞（区域 + desc 完整特征）
- [ ] 半屏残留有关闭 / **单次** back 恢复路径；不在目标包名时用 `App.launch`，不用连按返回
- [ ] 进主页失败不会再次进入同一主页（见 [`skip-on-item-failure.md`](./skip-on-item-failure.md)）
