# 单条失败必须跳过（禁止死磕同一条）

刷推荐流、列表、搜索结果时：以**一条内容**（视频 / 帖子 / 用户）为进度单位。进主页弹窗、读不到抖音号、半屏卡住等，**默认跳过本条、前进到下一条**。禁止对同一条反复进主页 / 反复恢复 / 不划走。

相关：[`page-state.md`](./page-state.md)、[`stale-node-after-click.md`](./stale-node-after-click.md)、[`task-template.md`](../task-template.md)、[`automation-loop.md`](../../00-core/automation-loop.md)、[`donts.md`](../../04-cheatsheets/donts.md)。

## 硬规则（MUST）

1. **进度单位是内容条目**：成功或失败，本轮结束都要让进度前进（`processed++` 且划走 / 点下一条）。  
2. **进主页 / 打开半屏 / 读资料：单次尝试 + 超时**。拿不到字段用占位（如抖音号 `'未知'`），**禁止**失败后再点一次头像重进。  
3. **目标 App 业务弹窗 ≠ Deeke `FloatDialogs`**：进页后先 dismiss 目标 App 弹窗（关闭 / 我知道了 / 取消 / 以后再说等），再读字段；Deeke 自己的悬浮弹窗用 `FloatDialogs.closeAll()`。  
4. **`continue` 若未划走当前内容**，必须另有 `skipCount`（或等价）上限；达到后**强制前进**。禁止「恢复成功就 `failRetry = 0`」导致围着同一条转。  
5. 兜底顺序：关弹窗 → 退回列表/推荐流 → **划走本条** → 处理下一条。不要在同一条上无限 `ensureFeed` + 重做。

## 反例（会死循环）

```javascript
// 错误：不在推荐页就 continue，且不消耗本条名额；一旦又回到同一视频会再次进主页
var failRetry = 0;
while (processed < maxCount && failRetry < 8) {
  if (!isFeed()) {
    failRetry++;
    ensureFeed();
    continue; // 未 processed++、未划走
  }
  failRetry = 0; // 短暂回到推荐流就清零 → 上限失效
  getAuthor();   // 点头像；弹窗失败后再来一轮
  // ...
  processed++;
  swipeNext();
}
```

典型路径：进主页 → 账号弹窗 → 读不到抖音号 → back 只关掉弹窗或停在主页 → `ensureFeed` 又回到**同一条** → 再进主页 → 死循环。

## 正例（单条一次，失败也前进）

```javascript
var processed = 0;
var skipCount = 0;

while (processed < maxCount) {
  if (!isFeed()) {
    dismissAppDialogs();
    ensureFeed();
    if (!isFeed()) {
      // 恢复失败：仍消耗名额，强制离开当前状态
      console.log('skip: not on feed');
      skipCount++;
      processed++;
      Gesture.back();
      System.sleep(500);
      // 仍不在流上再 ensure 一次；不要在这里 getAuthor
      ensureFeed();
      if (isFeed()) {
        swipeNext();
      }
      continue;
    }
  }

  // 进主页最多 1 次；弹窗则关；读不到也返回占位，绝不重进
  var author = getAuthorOnce();
  if (!author.ok) {
    console.log('author incomplete, continue with placeholder');
  }

  // 点赞 / 评论……（作者未知也可继续，或按产品配置跳过赞评）
  doLikeAndComment(author);

  processed++;
  if (processed < maxCount) {
    swipeNext();
  }
}
```

## `getAuthorOnce` 模式

```javascript
function dismissAppDialogs() {
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
  var close = UiSelector().desc('关闭').findOne();
  if (close) {
    close.click();
    System.sleep(600);
    return true;
  }
  return false;
}

function getAuthorOnce() {
  var nickname = readNicknameOnFeed() || '未知';
  var douyinId = '未知';
  var avatar = findAvatarOnFeed();
  if (!avatar) {
    return { ok: false, nickname: nickname, douyinId: douyinId };
  }

  avatar.click();
  System.sleep(2000);

  // 单次：先关业务弹窗，再读；不要失败后再次 click avatar
  dismissAppDialogs();
  System.sleep(400);
  var id = readDouyinIdOnProfile();
  if (id) {
    douyinId = id;
  }

  Gesture.back();
  System.sleep(800);
  dismissAppDialogs();

  // 尽量回到推荐流，但不在这里重进主页
  if (!isFeed()) {
    ensureFeed();
  }

  return {
    ok: douyinId !== '未知',
    nickname: nickname,
    douyinId: douyinId
  };
}
```

## 弹窗两类（勿混）

| 类型 | 例子 | 处理 |
|------|------|------|
| Deeke 悬浮弹窗 | `FloatDialogs.show` / `confirm` | 任务前 / 找节点前 `FloatDialogs.closeAll()` |
| 目标 App 业务弹窗 | 进主页引导、权限、青少年、店铺、直播间提示 | `dismissAppDialogs()` 点文案按钮或关闭；再 `Gesture.back()` |

## 自检

- [ ] 循环以「内容条」递增；失败路径也 `processed++` 并划走（或等价前进）  
- [ ] 进主页 / 半屏无「失败再进一次」分支  
- [ ] 有目标 App 弹窗 dismiss，且与 `FloatDialogs` 分开  
- [ ] 没有「`!isFeed` → continue 且清零 retry、不划走」结构  
- [ ] 读不到抖音号等字段用占位，任务能继续或明确 skip，而不是空转
