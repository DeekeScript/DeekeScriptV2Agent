# 评论 / 发帖输入配方

第三方 App 评论、发帖、私信输入的最小可运行模式。生成前必读 [`stale-node-after-click.md`](../02-script/pitfalls/stale-node-after-click.md)；页面态见 [`page-state.md`](../02-script/pitfalls/page-state.md)。

依赖：[`UiSelector.md`](../02-script/api/UiSelector.md)、[`UiObject.md`](../02-script/api/UiObject.md)、[`Gesture.md`](../02-script/api/Gesture.md)、[`KeyBoards.md`](../02-script/api/KeyBoards.md)、[`donts.md`](../04-cheatsheets/donts.md)。

## 输入优先级

1. `editable(true).focused(true)`（点击并弹键盘后）
2. `editable(true)` + 屏内 / 区域 `filter`
3. hint / `textContains`（「说点什么」「爱评论」等）
4. 最后才 `className('EditText')` / 全类名（短名常找不到）

写入顺序：优先 `setText`；不行再 `System.setClip` + `paste`；**不要默认 KeyBoards**。

## 完整片段（点击后重取）

```javascript
function inScreen(node) {
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
  return true;
}

function findPlaceholderInput() {
  var nodes = UiSelector().editable(true).filter(inScreen).find();
  var best = null;
  var bestTop = -1;
  var i = 0;
  while (i < nodes.length) {
    var top = nodes[i].bounds().top;
    if (top > bestTop) {
      bestTop = top;
      best = nodes[i];
    }
    i++;
  }
  return best;
}

function findActiveInput(oldTop) {
  var focused = UiSelector().editable(true).focused(true).filter(inScreen).findOne();
  if (focused) {
    return focused;
  }
  var nodes = UiSelector().editable(true).filter(inScreen).find();
  var i = 0;
  while (i < nodes.length) {
    var top = nodes[i].bounds().top;
    if (oldTop < 0 || Math.abs(top - oldTop) >= 40) {
      return nodes[i];
    }
    i++;
  }
  return nodes.length ? nodes[0] : null;
}

function clickSend() {
  var send = UiSelector().text('发送').filter(inScreen).findOne();
  if (!send) {
    send = UiSelector().descContains('发送').filter(inScreen).findOne();
  }
  if (!send) {
    return false;
  }
  if (send.isClickable() && send.click()) {
    return true;
  }
  var parent = send.parent();
  if (parent && parent.isClickable() && parent.click()) {
    return true;
  }
  FloatDialogs.setFloatWindowClickable(false);
  System.sleep(300);
  var b = send.bounds();
  var ok = Gesture.click(b.centerX(), b.centerY());
  FloatDialogs.setFloatWindowClickable(true);
  return ok;
}

function comment(text) {
  // 假设已打开评论半屏；打开半屏的按钮查找按各 App 另写
  var placeholder = findPlaceholderInput();
  if (!placeholder) {
    return false;
  }
  var oldTop = placeholder.bounds().top;
  placeholder.click();
  System.sleep(1000);

  // MUST：点击后重新获取
  var input = findActiveInput(oldTop);
  if (!input) {
    return false;
  }

  var written = false;
  try {
    written = !!input.setText(text);
  } catch (e1) {
    written = false;
  }
  if (!written) {
    System.setClip(text);
    System.sleep(150);
    try {
      written = !!input.paste();
    } catch (e2) {
      written = false;
    }
  }
  System.sleep(400);

  var check = UiSelector().editable(true).focused(true).filter(inScreen).findOne();
  if (!check || String(check.text() || '').indexOf(text) < 0) {
    // 节点可能再次刷新：再取一次重写
    input = findActiveInput(oldTop);
    if (input) {
      try {
        input.setText(text);
      } catch (e3) {
      }
      System.sleep(300);
    }
  }

  return clickSend();
}
```

## 片段验证顺序

1. 能打开评论半屏 / 找到占位框（打印 `bounds.top`）
2. click 后 `editable(true).focused(true)` 能找到，且 `top` 与占位不同（或已 focused）
3. `setText` 后重读 `text` 含目标文案
4. 「发送」点得动（`clickable` / parent / Gesture）
5. 回到目标页（`ensureFeed` 一类），再拼循环

## 注意

- **禁止**对 click 前的变量直接 `setText`。见 [`stale-node-after-click.md`](../02-script/pitfalls/stale-node-after-click.md)。
- bounds 校验用 `Device.width()` / `Device.height()`，不要混用 `/ai/status` 的 screenHeight（可能不一致）。
- 调试日志把关键断言合成一条，如 `console.log('result=' + JSON.stringify(ret))`，见 [`ai-device-debug.md`](../00-core/ai-device-debug.md)。
