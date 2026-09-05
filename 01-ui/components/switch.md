# switch

布尔开关：左侧文案，右侧滑动开关，不是勾选框。

**启停 / 开关键闭状态用 `switch`，不要用「启用」「停用」按钮切换。** 列表行内同样用 `switch`；删除等一次性动作才用小按钮。完整列表配方见 [`list-manage.md`](../../03-recipes/list-manage.md)。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键。页面根表单必填。列表行内可省略，用 `e.item` / `e.index` 定位 |
| label | String | 开关说明（表单整行时常用；列表行内可省略，文案放旁边 `text`） |
| value | Boolean / String | 页面根表单的默认值。列表未写 `value` 时默认读 `item.enabled`。整段 `{{item.enabled}}` 会保留布尔，不要再靠字符串插值判断开/关 |
| onChange | String | 切换时调用。`e.value` 为布尔。写在 list / grid 行内时还有 `e.item`、`e.index`；写了 `name` 时有 `e.name` |
| style.color | String | 打开后轨道和滑块颜色。不写则跟 `window.theme.primary`。**不要写 `style.background`**，否则会给整行刷底 |
| style.trackColor | String | 关闭时轨道颜色 |

```json
{
  "type": "switch",
  "name": "auto_start",
  "label": "自动开始",
  "value": false
}
```

```json
{ "type": "switch", "name": "blue", "label": "蓝色开关", "value": true, "style": { "color": "#1565C0" } }
```

## 列表行内（启停 + 小删除）

```json
{
  "type": "row",
  "style": { "gap": 8, "valign": "center" },
  "children": [
    { "type": "text", "text": "{{item.content}}", "style": { "weight": 1 } },
    { "type": "switch", "onChange": "onToggle" },
    {
      "type": "button",
      "text": "删除",
      "size": "sm",
      "onTap": "onDelete",
      "style": { "background": "#FFE8EC", "color": "#C62828" }
    }
  ]
}
```

```javascript
onToggle(e) {
  var list = Storage.getObj('demo.comments') || [];
  var i = e && e.index != null ? parseInt(e.index, 10) : -1;
  if (isNaN(i) || i < 0 || i >= list.length) {
    return;
  }
  list[i].enabled = e && e.value === true;
  Storage.putObj('demo.comments', list);
  this.refresh();
},
onDelete(e) {
  var item = e && e.item ? e.item : null;
  var index = e && e.index !== undefined ? parseInt(e.index, 10) : -1;
  var rows = this.data.comments || [];
  if (!item && index >= 0 && rows[index]) {
    item = rows[index];
  }
  if (!item) {
    return;
  }
  // 删除 …
}
```

列表里如果仍写静态 `"name": "enabled"`，引擎会自动变成 `enabled#0`、`enabled#1`，各行互不抢同一份草稿。更省事的是列表开关不写 `name`，只用 `e.item` / `e.index`。

## 注意

- 布尔态用 `switch` / `checkbox`，不要做成两个互相切换的大 `button`。
- 列表次要 `button` 必须 `"size": "sm"`，见 [`button.md`](./button.md)。
- 页面根表单的 `name` 页内必须唯一，Storage 键加前缀。见 [`form-name.md`](../pitfalls/form-name.md)。
