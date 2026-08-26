# 下拉刷新

给整页加下拉刷新时读这篇。它不是 body 里的组件：在 `page.json` 根上打开 `enablePullDownRefresh`，引擎负责转圈并调用 `onPullDownRefresh`。列表怎么请求、怎么 `setData` 写在这个事件里。不会再走 `onLoad`。拉完数据后调用 `this.stopPullDownRefresh()`。

## 打开下拉

写在 `page.json` 根上，和 `title` / `body` 同级。未写或 `false` 时，下拉不会转圈，也不会回调。

| 参数 | 类型 | 说明 |
|------|------|------|
| enablePullDownRefresh | Boolean | 是否打开整页下拉。不是组件 |

```json
{
  "enablePullDownRefresh": true,
  "title": {
    "text": "下拉刷新",
    "fontSize": 18,
    "color": "#FFFFFF",
    "background": "#006A65"
  },
  "style": {
    "background": "#F5F5F5",
    "padding": 12
  },
  "body": [
    { "type": "list", "bind": "logs", "item": { "type": "notice", "text": "{{item.title}}" } }
  ]
}
```

## 页面事件

| 时机 | 方法 |
|------|------|
| 用户在顶部下拉并松开 | `onPullDownRefresh()` |
| 停转圈 | `this.stopPullDownRefresh()` |

| 要点 | 说明 |
|------|------|
| 第一次进页 | 仍走 `onLoad`，自己拉第一份数据 |
| 用户下拉 | 只走 `onPullDownRefresh`，不要重入 `onLoad` |
| 转圈何时停 | 拉完数据后 `this.stopPullDownRefresh()`。没写这个事件时，引擎会自己停 |

```javascript
Page({
  data: {
    logs: [],
    times: 0
  },
  onLoad: function () {
    this.loadLogs(false);
  },
  onPullDownRefresh: function () {
    this.loadLogs(true);
    this.stopPullDownRefresh();
  },
  loadLogs: function (fromPull) {
    var n = this.data.times || 0;
    if (fromPull) {
      n = n + 1;
    }
    this.setData({
      times: n,
      logs: [{ title: fromPull ? '刚刚刷新' : '进入页面' }]
    });
  }
});
```

其它滚动、点击见 [page.js](../page-js.md)。
