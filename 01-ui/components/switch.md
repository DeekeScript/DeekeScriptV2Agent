# switch

布尔开关：左侧文案，右侧滑动开关，不是勾选框。

**启停 / 开关键闭状态用 `switch`，不要用「启用」「停用」按钮切换。** 列表行内同样用 `switch`；删除等一次性动作才用小按钮。完整列表配方见 [`list-manage.md`](../../03-recipes/list-manage.md)。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键；列表项里可写字段名，配合 `value` / 绑定 |
| label | String | 开关说明（表单整行时常用；列表行内可省略，文案放旁边 `text`） |
| value | Boolean / String | 默认值；列表里可写 `"{{item.enabled}}"` |
| onChange | String | 切换时调用，`e.value` 为布尔；列表行里另有 `e.item` / `e.index` |
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
    {
      "type": "switch",
      "name": "enabled",
      "value": "{{item.enabled}}",
      "onChange": "onToggle"
    },
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
  // e.item：当前行；e.value：开关新值
  if (!e || !e.item) {
    return;
  }
  // 更新 Storage / setData …
},
onDelete(e) {
  if (!e || !e.item) {
    return;
  }
  // 删除 …
}
```

## 注意

- 布尔态用 `switch` / `checkbox`，不要做成两个互相切换的大 `button`。
- 列表次要 `button` 必须 `"size": "sm"`，见 [`button.md`](./button.md)。
