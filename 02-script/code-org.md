# 自动化代码组织

编写面向具体 App 的自动化时读这篇。目标：模块化、可复用，按**操作对象**沉淀能力，不要为跑通当前需求在各 `tasks/*.js` 里复制粘贴。

极短的一次性脚本可先写在单个 `tasks/*.js`；一旦出现第二处同类操作，或用户要多功能工作台，必须按本篇拆分。

依赖：[`require.md`](require.md)、[`project-layout.md`](../00-core/project-layout.md)、[`task-template.md`](task-template.md)。

## 1. 按操作对象划分模块

按功能所操作的**对象/主体**分模块，不要只按「点击、点赞、评论」等动作横切。

对象随 App 与业务而定，例如：视频、文章、商品、用户、直播间、帖子、消息。

```text
common/dy/          （示例：某 App 前缀，可自定）
  video.js          // 视频：打开 / 点赞 / 评论 / 收藏
  user.js           // 用户：打开主页 / 关注 / 取信息
  article.js        // 文章：打开 / 点赞 / 评论 / 收藏
  page.js           // 通用：等待页面、判断当前页、滑动
```

每个对象文件用 `module.exports` 导出**对象**（Rhino，不要 `class` / `import`）。方法用**简写**，不要写成 `key: function () {}`：

```javascript
// common/dy/video.js
module.exports = {
  open() {
    // ...
  },
  like() {
    // ...
  },
  comment(text) {
    // ...
  },
  collect() {
    // ...
  }
};
```

```javascript
// tasks/watch.js
let video = require('../common/dy/video.js');

video.open();
video.like();
video.comment('不错');
```

`comment(text)` 实现必须遵守点击后重取输入框，见 [`comment-input.md`](../03-recipes/comment-input.md)、[`pitfalls/stale-node-after-click.md`](./pitfalls/stale-node-after-click.md)。不要写成「同一 `input` 变量 click 完直接 setText」。

### 写法约定（必守）

优先用对象组织能力，少堆顶层 `function`；对象方法一律简写：

```javascript
// 推荐
let video = {
  count: 0,
  open() {},
  like() {},
  comment(text) {}
};
video.open();

// 不推荐：对象方法写成 function 属性
let video = {
  open: function () {},
  like: function () {}
};

// 不推荐：业务能力散落成一堆顶层 function
function openVideo() {}
function likeVideo() {}
```

API 回调（如 `setTimeout`、`Dialogs.confirm`、`.then`）仍可传 `function` 或箭头；与「业务能力用对象方法」不矛盾。`Page({})` / `FloatWindow.on({})` 等同理：用 `onLoad() {}`、`stop() {}`，不要 `onLoad: function () {}`，也不要用会绑错 `this` 的 `onLoad: () => {}`。

## 2. 优先封装通用能力

多处会用到的逻辑放进对象模块或 `common/` 通用文件，例如：

- 查找元素、点击、滑动、输入
- 等待页面、判断当前页
- 打开某类对象、取信息、对对象做操作

避免在多个业务 `tasks/*.js` 里各写一套相同的 `UiSelector` / 手势。

## 3. 业务任务用组合实现

`tasks/*.js` 负责流程：权限 → 读配置 → 有界循环 → 调用对象能力。底层查找与点击尽量不散落在任务里。

```javascript
let permission = require('../common/permission.js');
let article = require('../common/dy/article.js');

if (!permission.ensureRun()) {
} else {
  let i = 0;
  while (i < 10) {
    article.open();
    article.like();
    article.comment('看过了');
    System.sleep(1500);
    i++;
  }
  Engines.closeAll();
}
```

刷推荐流、进主页取号时：循环须遵守 [`pitfalls/skip-on-item-failure.md`](./pitfalls/skip-on-item-failure.md)（单条失败 skip，禁止对同一条反复进主页）。

## 4. 新增功能前先查复用

落盘新代码前自问：

| 问题 | 做法 |
|------|------|
| 是否已有类似方法？ | 直接 `require` 调用 |
| 差一小步？ | 给现有对象加方法，不要复制整段 |
| 多处都要？ | 抽到对象模块或 `common/` |
| 归属哪个对象？ | 按操作主体归类，不要堆进一个巨型 `utils.js` |

**核心：** 不只让当前功能跑通，每次开发尽量沉淀为以后可复用的自动化能力。
