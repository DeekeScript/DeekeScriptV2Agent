# tabs

页内选项卡，**和底部 TabBar 不是一回事**。底部菜单写在入口配置的 `bottomMenus`，不是 `body` 里的组件。

`name` 对应 `data` 中的键。`items`（或 `options`）为选项；选项里的 `children` 是该面板内容。`onChange` 的 `e.value` 为当前值。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name / id | String | 对应 `data` 中的键 |
| value | String | 默认选中项 |
| items / options | Array | `{ text, value, badge, children }`。`text` 也可用 `label` |
| onChange | String | 切换时调用的 `Page` 方法 |

```json
{
  "type": "tabs",
  "name": "tab",
  "value": "follow",
  "onChange": "onTab",
  "items": [
    {
      "text": "关注",
      "value": "follow",
      "children": [{ "type": "text", "text": "今日关注 12 人" }]
    },
    {
      "text": "点赞",
      "value": "like",
      "badge": "8",
      "children": [{ "type": "notice", "text": "已完成 36 次" }]
    }
  ]
}
```

## 注意

不要把 `tabs` 当成底部导航。底部 Tab 切的是整页，已经打开过的 Tab 会保留数据和滚动。
