# textarea

多行文本。外观和 [input](./input.md) 一样：默认下划线，`variant: "box"` 为圆角边框，`variant: "plain"` 为无边框纯背景。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键；**本页内必须唯一**。规则见 [`form-name.md`](../pitfalls/form-name.md) |
| label | String | 字段标题 |
| value | String | 默认值 |
| hint | String | 占位 |
| minLines | Number | 最少行数，默认 3 |
| variant | String | 同 Input：`line`（默认）/ `box` / `plain` |
| size | String | 同 Input，仅边框样式生效 |
| style.radius / borderWidth / borderColor / background / focusColor | — | 同 Input |

```json
{
  "type": "textarea",
  "name": "remark",
  "label": "备注",
  "hint": "请输入",
  "minLines": 3,
  "variant": "box"
}
```

```json
{ "type": "textarea", "name": "blue", "label": "蓝色聚焦", "hint": "focusColor", "variant": "box", "style": { "focusColor": "#1565C0" } }
```
