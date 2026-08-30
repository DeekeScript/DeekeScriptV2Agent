# 页面方法速查

`Page({})` 内 `this.xxx`。自定义组件里调这些方法，走的是所在页面。跳转类与 JSON `action` 同名，见 [`action-types.md`](./action-types.md)。

| 方法 | 作用 |
|------|------|
| `this.setData({ key: value })` | 按字段更新。列表整表替换。点分路径：`{ 'user.name': '运营A' }` |
| `this.appendData('tasks', more)` | 向 `data.tasks` 末尾追加数组 |
| `this.navigate(page\|{ page, params })` | 打开另一页 |
| `this.redirect(page\|{ page, params })` | 关掉当前二级页再打开 |
| `this.switchTab(page\|{ page })` | 切底栏 |
| `this.back()` | 关闭当前二级页 |
| `this.toast(text\|{ text, duration })` | 短提示 |
| `this.openUrl(url)` | 系统浏览器 |
| `this.setTitle(text\|{ text, color, background })` | 改当前页标题栏 |
| `this.scrollTo(y\|{ y, animated, top })` | 滚页面。`y` 与 `onScroll.scrollY` 一样是 px |
| `this.showPopup(id\|showIf)` | 显示弹层 |
| `this.hidePopup(id\|showIf)` | 隐藏弹层 |
| `this.showLoading(text?)` | 整页加载遮罩（不是 JSON `loading` 组件） |
| `this.hideLoading()` | 关掉整页加载 |
| `this.stopPullDownRefresh()` | 结束下拉刷新转圈 |
| `this.setTabBar(items\|{ items, ... })` | 创建底栏。无参数则恢复入口 `bottomMenus` |
| `this.setTabBarItem({ page, badge, hidden, title, icon })` | 改某一项。`badge` 为 `0` 或 `''` 去掉 |
| `this.setTabBarStyle({ color, selectedColor, iconColor, selectedIconColor, background, borderColor, fontSize, hidden })` | 改整栏。只传要改的字段，`color` 不动图标 |
| `this.selectComponent(id)` | 取自定义组件实例 |

生命周期（未声明不调用）：`onLoad(params)` `onShow` `onReady` `onHide` `onUnload`。

滚动 / 手势：`onScroll(e)`（`e.scrollY` / `e.deltaY`）`onReachBottom` `onReachTop` `onPullDownRefresh` `onTap` `onDoubleTap` `onLongPress` `onSwipeUp` / `Down` / `Left` / `Right` / `onSwipe`。

```javascript
this.setData({ hello: '张三', loading: true });
this.appendData('tasks', [{ title: '下一条' }]);
this.showPopup('sheet');
this.showLoading('加载中');
this.setTabBarItem({ page: 'msg', badge: 9 });
Engines.executeScript('tasks/sample.js');
```

## 注意

- 表单输入写回 `this.data`，不必每次 `setData`。
- 因 `showIf` 新出现的节点会整页重绘。
- 列表触底转圈用 JSON `loading` + `showIf`，不要默认 `showLoading`。
