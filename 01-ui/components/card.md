# card

白底圆角容器，可整体绑定 `action`。写上 `name` 和 `value` 后变成**可选中卡片**：同一 `name` 对应 `data` 里的字段，选中后底色变成浅绿并带边框。

卡片本身不改选中态，要点了之后在 `page.js` 里 `setData`，其它卡片才会跟着变。`multiple: true` 时值为数组，可多选。

通用字段见 [通用字段](./_common.md)。事件见 [页面 JS](../page-js.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| children | Array | 卡片内容 |
| name | String | 对应 `data` 中的键，用来判断哪张卡是选中态 |
| value | String | 该卡片代表的选项值 |
| multiple | Boolean | `true` 为多选，值为数组；默认多选一 |
| selectedBackground | String | 选中底色，默认 `#E6F2F0` |
| onTap | String | 轻触时调用的 `Page` 方法，`e.value` 是该卡片的 `value` |
| action | Object | 整卡点击动作 |

```json
{
  "type": "card",
  "name": "plan",
  "value": "month",
  "onTap": "onSelectPlan",
  "style": { "weight": 1 },
  "children": [{ "type": "text", "text": "月卡" }]
}
```

```javascript
Page({
  data: {
    plan: 'year',
    apps: ['xhs']
  },
  onSelectPlan(e) {
    this.setData({ plan: e.value });
  },
  onToggleApp(e) {
    var apps = this.data.apps ? this.data.apps.slice() : [];
    var i = apps.indexOf(e.value);
    if (i >= 0) {
      apps.splice(i, 1);
    } else {
      apps.push(e.value);
    }
    this.setData({ apps: apps });
  }
});
```

## 注意

多选卡片把 `multiple` 设为 `true`，`data` 里对应字段是数组，在 `onTap` 里自行增删再 `setData`。
