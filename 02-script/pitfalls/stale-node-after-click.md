# 点击后节点失效（MUST）

评论框、搜索框、半屏面板、键盘弹起后，**点击前拿到的节点常常作废**。占位输入框与聚焦后的真实输入框往往不是同一个节点（bounds / 是否 focused / 能否 `setText` 都可能不同）。

相关：[`comment-input.md`](../../03-recipes/comment-input.md)、[`UiObject.md`](../api/UiObject.md)、[`constraints.md`](../../00-core/constraints.md) MUST NOT 12。

## 硬规则

1. **禁止** `find → click → 同一变量 setText/paste`。
2. 点击会改变界面（弹键盘、开半屏、切页）后，必须 **重新 `UiSelector` 查找** 再操作。
3. 输入后用 **再 find 一次读 `text()`** 校验是否写进；`setText` 返回 `true` 不等于业务成功。
4. 「发送」等按钮可能 `isClickable() === false`：先点父节点，再不行用 [`Gesture.click`](../api/Gesture.md) 点中心。

## 正确流程

```text
占位框 find（可记 bounds.top）
  → click
  → System.sleep（等键盘 / 半屏）
  → 重新 find（优先 editable(true).focused(true)；排除旧 top）
  → setText / 剪贴板 paste
  → 再 find，校验 text 含目标文案
  → 再 find「发送」并点击（或 parent / Gesture）
```

## 最小片段

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

// 1) 底部占位框
var placeholder = UiSelector().editable(true).filter(inScreen).findOne();
if (!placeholder) {
  // 失败处理
} else {
  var oldTop = placeholder.bounds().top;
  placeholder.click();
  System.sleep(1000);

  // 2) 点击后必须重取：优先已聚焦；并尽量排除旧占位 top
  var input = UiSelector().editable(true).focused(true).filter(inScreen).findOne();
  if (!input) {
    var edits = UiSelector().editable(true).filter(inScreen).find();
    var i = 0;
    while (i < edits.length) {
      var top = edits[i].bounds().top;
      if (Math.abs(top - oldTop) >= 40) {
        input = edits[i];
        break;
      }
      i++;
    }
  }

  if (input) {
    input.setText('评论内容');
    System.sleep(400);
    // 3) 校验：再找一次读 text
    var check = UiSelector().editable(true).focused(true).filter(inScreen).findOne();
    console.log('written=' + (check ? check.text() : 'null'));
  }
}
```

## 典型场景

| 场景 | 表现 |
|------|------|
| 抖音 / 小红书评论 | 底部 hint 占位框 → 点击后上方出现新 EditText（常 `focused=true`） |
| 搜索页 | 点搜索框后键盘弹起，输入节点重建 |
| 半屏面板 | 关闭/展开后原节点 bounds 失效或不可点 |

## 自检

- [ ] 没有把 click 前的 `input` 变量直接拿去 `setText`
- [ ] 写完后有重读 `text` 或等价校验
- [ ] 「发送」找不到 / 不可点时有 parent / Gesture 兜底
