# 页面 page.js

写 `Page({})`、生命周期、点击、改标题/弹层/加载圈、从页面拉起脚本时读这篇。`page.js` 只在打开该页时加载，不要对它点「仅当前文件执行」。未声明的方法不会调用。`this` 为传入对象。滚动/点击细节与方法全集都在本页；下拉刷新见 [refresh](./capabilities/refresh.md)。

## 生命周期顺序

只有五个：`onLoad` / `onShow` / `onReady` / `onHide` / `onUnload`。

| 时机 | 方法 |
|------|------|
| 页面第一次打开，带跳转参数 | `onLoad(params)` |
| 页面显示（含再次显示、从二级页返回） | `onShow` |
| 第一次显示完成，只一次 | `onReady` |
| 页面被盖住或切到其它 Tab | `onHide` |
| 页面关闭（二级页返回、退出项目） | `onUnload` |

首次进入：`onLoad(params)` → `onShow` → `onReady`。离开时 `onHide`。关掉页面才 `onUnload`。从二级页返回或切回已打开的 Tab，只走 `onShow`，不重新 `onLoad`。

| 场景 | 行为 |
|------|------|
| 底部 Tab 切换 | 当前页 `onHide`，实例保留。第一次进目标 Tab：`onLoad` → `onShow` → `onReady`。再切回来只 `onShow`，数据和滚动还在。首页 `onLoad` 的 `params` 为 `{}` |
| `navigate` 打开二级页 | 当前页 `onHide`。新页 `onLoad(params)` → `onShow` → `onReady` |
| 返回 | 二级页 `onUnload`，底层页 `onShow`，不重新 `onLoad` |
| 嵌套自定义组件 | 组件走 `created` / `attached` / `detached`，不是页面生命周期 |

```javascript
Page({
  data: {
    logs: []
  },
  onLoad: function (params) {
    console.log('onLoad', JSON.stringify(params || {}));
  },
  onShow: function () {
    console.log('onShow');
  },
  onReady: function () {
    console.log('onReady');
  },
  onHide: function () {
    console.log('onHide');
  },
  onUnload: function () {
    console.log('onUnload');
  }
});
```

## 页面事件

点按已经拆开。组件上写了对应 JSON 时，空白处的页面事件不会再收到。

| 时机 | 方法 |
|------|------|
| 页面滚动 | `onScroll(e)`，`e.scrollY` / `e.deltaY`（较频繁，适合打日志） |
| 整页滚到底 | `onReachBottom(e)` |
| 整页滚到顶 | `onReachTop(e)` |
| 整页下拉刷新 | `onPullDownRefresh()` |
| 点空白 | `onTap` |
| 双击空白 | `onDoubleTap` |
| 长按空白 | `onLongPress` |
| 滑动 | `onSwipeUp` / `onSwipeDown` / `onSwipeLeft` / `onSwipeRight` / `onSwipe` |

组件上：按钮/卡片写 `onTap`（也认 `onClick`）；list / grid 可写 `onScroll` / `onReachBottom` / `onReachTop`；表单写 `onChange`。同时写了轻触和双击时，轻触会略慢。

```javascript
Page({
  onTap: function () {},
  onDoubleTap: function () {},
  onLongPress: function () {},
  onSwipeUp: function () {},
  onSwipe: function (e) {}
});
```

## 数据：setData / appendData

`data` 为页面数据。模板 `{{hello}}` 与 `"bind": "tasks"` 均从此取值。表单输入写回 `this.data`，不触发整页刷新。因 `showIf` 新出现的节点会整页重绘。

| 写法 | 说明 |
|------|------|
| `data: { hello: '你好', tasks: [] }` | 初始值 |
| `this.setData({ hello: '张三', tasks: items })` | 一次写入多份；列表整表替换 |
| `this.setData({ 'user.name': '运营A' })` | 点分路径 |
| `this.data.hello = '张三'` | 改单个字段并刷新 |
| `this.appendData('tasks', more)` | 向 `data.tasks` 末尾追加 |

未写 `bind` 时，list / grid 的 `id` 当作 `bind`。表单 `name`（或 `id`）与 `data` 的键同名。

## 页面方法全集

字符串参数会同时当作 `page` / `text` / `url` / `id`。自定义组件里调用这些方法，走的是所在页面。

| 方法 | 作用 |
|------|------|
| `this.navigate(page\|{ page, params })` | 打开另一页 |
| `this.redirect(page\|{ page, params })` | 关掉当前二级页再打开 |
| `this.switchTab(page\|{ page })` | 切底栏。已打开过的 Tab 保留数据和滚动，只再走 `onShow` |
| `this.back()` | 关闭当前二级页 |
| `this.toast(text\|{ text, duration })` | 短提示 |
| `this.openUrl(url)` | 系统浏览器打开 |
| `this.setTitle(text\|{ text, color, background })` | 改当前页标题栏 |
| `this.scrollTo(y\|{ y, animated, top })` | 滚页面，`y` 与 `onScroll.scrollY` 一样是 px |
| `this.showPopup(id\|showIf)` / `this.hidePopup(...)` | 按弹层 `id` 或 `showIf` 显示隐藏 |
| `this.showLoading(text)` / `this.hideLoading()` | 盖一层加载，`text` 可选。不必在 JSON 里放 loading 节点 |
| `this.stopPullDownRefresh()` | 结束下拉刷新转圈 |
| `this.setTabBar(items\|{ items, ... })` | 创建底栏。无参数则恢复入口 `bottomMenus` |
| `this.setTabBarItem({ page, ... })` | 改某一项的角标、隐藏、文字、图标 |
| `this.setTabBarStyle({ ... })` | 改整栏文字色、图标色、背景、隐藏 |
| `this.selectComponent(id)` | 按节点 `id` 找子组件，找不到返回 `null` |

```javascript
this.setTitle('已改标题');
this.setTitle({ text: '已改标题', color: '#FFFFFF', background: '#006A65' });
this.scrollTo(400);
this.scrollTo({ y: 0, animated: false });
this.scrollTo({ top: true });
this.showPopup('sheet');
this.hidePopup('open');
this.showLoading('加载中');
this.hideLoading();
this.stopPullDownRefresh();
```

`showPopup` 会去页面 `popups`（以及 body 里的 `type: popup`）里找 `id` 或 `showIf`，再把对应字段写成 `true`。找不到就把参数当成数据路径。也可以 `this.setData({ open: true })`。

加载圈画在当前页最上层，和 JSON 里的 `loading` 组件不是同一个。列表触底转圈仍用 `setData` + `showIf`。

```javascript
Page({
  data: {
    loading: false,
    noMore: false,
    footer: ''
  },
  onReachBottom: function () {
    if (this.data.loading || this.data.noMore) {
      return;
    }
    this.setData({ loading: true });
    System.sleep(2000);
    this.setData({ loading: false, noMore: true, footer: '—— 我是有底线的 ——' });
  }
});
```

底栏三项方法的字段见 [tabBar](./capabilities/tabBar.md)。跳转与 `action` 对照见 [navigate](./navigate.md)。

## 从页面执行脚本

不要写在 JSON 的 `action` 里。路径相对项目根目录。

```json
{ "type": "button", "text": "运行示例", "onTap": "onRunSample" }
```

```javascript
Page({
  onRunSample: function () {
    Engines.executeScript('tasks/sample.js');
  },
  onRun: function (e) {
    Engines.executeScript(e.item.jsFile);
  }
});
```

需要先过无障碍和悬浮窗时，用 `common/permission.js` 的 `runScript` / `ensureRun`。不要生成 `permission.hint(...)`。
