# checkbox

不写 `options` 时是单个勾选，值为布尔；写了 `options` 时值为选中数组。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| label | String | 字段标题或单选项文案 |
| value | Boolean / Array | 单个为布尔；多选项为选中值数组 |
| options | Array | 多选项：字符串，或 `{ "label", "value" }` |
| onChange | String | 变化时调用。写在 list / grid 行内时还有 `e.item`、`e.index` |
| style.color | String | 勾选按钮颜色。不写则跟 `window.theme.primary`。不要写 `style.background` |

```json
{
  "type": "checkbox",
  "name": "agree",
  "label": "已阅读并同意协议"
}
```

```json
{
  "type": "text",
  "text": "同意：{{agree}}"
}
```

```javascript
Page({
  data: {
    agree: false,
    platforms: ['xhs']
  }
});
```

`name` 必须和 `data` 里的键一致。勾选后 `this.data.agree` 会变；旁边用 `{{agree}}` 展示时，引擎会刷新这段文案。不要把 `agree` 只写在 JSON `value` 里却不放进 `data`。

```json
{
  "type": "checkbox",
  "name": "platforms",
  "label": "平台",
  "options": [
    { "label": "小红书", "value": "xhs" },
    { "label": "抖音", "value": "dy" }
  ],
  "value": ["xhs"]
}
```

```json
{ "type": "checkbox", "name": "blue_agree", "label": "蓝色勾选", "value": true, "style": { "color": "#1565C0" } }
```
