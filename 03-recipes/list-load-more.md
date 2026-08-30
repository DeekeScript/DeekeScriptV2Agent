# 列表触底加载

`list` + `bind` + 页面 `onReachBottom` + `loading` 的 `showIf` + `appendData`。数组为空不会自动 Empty，自己摆。

相关：[`component-types.md`](../04-cheatsheets/component-types.md)、[`page-methods.md`](../04-cheatsheets/page-methods.md)。

## `pages/list/page.json`

```json
{
  "title": {
    "text": "记录",
    "fontSize": 18,
    "color": "#FFFFFF",
    "background": "#006A65"
  },
  "style": {
    "background": "#F5F5F5",
    "padding": 12
  },
  "body": [
    {
      "type": "list",
      "bind": "tasks",
      "item": {
        "type": "card",
        "children": [
          { "type": "text", "text": "{{item.title}}", "style": { "fontWeight": "bold" } },
          { "type": "notice", "text": "{{item.time}}" }
        ]
      }
    },
    { "type": "empty", "text": "暂无记录", "showIf": "empty" },
    { "type": "loading", "text": "加载中", "showIf": "loading" },
    {
      "type": "text",
      "text": "{{footer}}",
      "showIf": "noMore",
      "style": { "align": "center", "color": "#9AA8A6", "fontSize": 12 }
    }
  ]
}
```

## `pages/list/page.js`

```javascript
Page({
  data: {
    tasks: [],
    page: 1,
    loading: false,
    noMore: false,
    empty: false,
    footer: ''
  },
  onLoad() {
    this.setData({
      tasks: [
        { title: '今日关注 12 人', time: '10:21' },
        { title: '今日点赞 36 次', time: '11:08' }
      ],
      empty: false
    });
  },
  onReachBottom() {
    if (this.data.loading || this.data.noMore) {
      return;
    }
    this.setData({ loading: true });
    var that = this;
    setTimeout(function () {
      let next = that.data.page + 1;
      if (next >= 3) {
        that.setData({
          loading: false,
          noMore: true,
          footer: '—— 我是有底线的 ——'
        });
        return;
      }
      that.appendData('tasks', [
        { title: '第 ' + next + ' 页记录 A', time: '12:00' },
        { title: '第 ' + next + ' 页记录 B', time: '12:01' }
      ]);
      that.setData({ loading: false, page: next });
    }, 500);
  }
});
```

整页滚到底走 `Page.onReachBottom`。只让某个 list 触底时，把 `onReachBottom` 写在该 list 节点上。

追加用 `this.appendData('tasks', more)`，不要每次把整表 `setData` 拷一遍（首屏替换仍用 `setData`）。

## 注意

- 先判 `loading` / `noMore`，防止重复请求。
- `this.showLoading()` 是整页遮罩，和 JSON 里的 `loading` 组件不是同一个。列表触底用 `showIf`。
- `empty` 要自己 `setData({ empty: list.length === 0 })`。
- 页面里不要 `System.sleep`（会卡住界面），短等待用 `setTimeout`。任务脚本里等待才用 `System.sleep`。
- 真实接口用 `Http.get` 再 `JSON.parse`，不要 `async/await`。
