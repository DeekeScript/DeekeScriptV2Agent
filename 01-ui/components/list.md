# list

按 `bind` 指向的数组逐条渲染。`item` 为模板。循环内使用 `{{item.xxx}}`、`{{index}}`。`"direction": "row"` 横排。

数组为空时不渲染行，**不会自动出现 Empty**。空提示请用 [empty](./empty.md) 自己摆，并用 `showIf` 控制。

通用字段见 [通用字段](./_common.md)。触底逻辑见 [页面 JS](../page-js.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| bind | String | 数据路径，对应 `data` 中的数组，如 `"tasks"` 或 `"item.tags"` |
| id | String | 未写 `bind` 时当作 `bind` |
| item | Object / Array | 每一项的组件模板。数组则包一层 column |
| onScroll / onReachBottom / onReachTop | String | 该列表的滚动事件。整页到底用 `Page.onReachBottom` |
| children | Array | 未写 `item` 时作为模板 |
| direction | String | `column`（默认）或 `row` |
| style.gap | Number | 行间距 dp，默认 8 |

| 模板 | 含义 |
|------|------|
| `{{item.title}}` | 当前项字段 |
| `{{item.id}}` | 当前项 id |
| `{{index}}` | 下标，从 0 开始 |

```json
{
  "type": "list",
  "bind": "tasks",
  "item": {
    "type": "card",
    "children": [
      { "type": "text", "text": "{{item.title}}" },
      { "type": "notice", "text": "{{index}}" }
    ]
  }
}
```

```javascript
Page({
  data: {
    tasks: [],
    loading: false,
    noMore: false,
    footer: ''
  },
  onReachBottom: function () {
    if (this.data.loading || this.data.noMore) {
      return;
    }
    this.setData({ loading: true });
    var that = this;
    setTimeout(function () {
      that.setData({ loading: false, noMore: true, footer: '—— 我是有底线的 ——' });
    }, 2000);
  }
});
```

## 注意

- 行内 `onTap` / `onChange`（含嵌套 `switch`、input、checkbox、小按钮）：`e` 含 `item`、`index`。列表表单用 `e.value` 写回对应行，不必给每行编假 `name`。见 [`switch.md`](./switch.md)、[`list-manage.md`](../../03-recipes/list-manage.md)。
- 内层 list 的 `bind` 可写 `item.tags`；内层循环中 `{{item}}` 为当前内层项。
- 触底后由 JS 打开 [loading](./loading.md)；没有更多数据时关掉转圈，并用 `setData` 写下底线文案。
