# range

一行两个输入框，用于最小值～最大值。左右各自 `name`。外观继承外层的 `variant` / `size` / `style`，也可以写在 `start` / `end` 上。

通用字段见 [通用字段](./_common.md)。外观字段同 [input](./input.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| label | String | 整行标题 |
| separator / sep | String | 间隔符，默认 `-` |
| start / from | Object / String | 左侧输入。对象含 `name`、`hint`、`value`、`inputType`；也可只写字段名 |
| end / to | Object / String | 右侧输入，同上 |
| name / hint / value | Array | 简写：`["最小键","最大键"]` |
| inputType | String | 写在外层时左右共用；也可写在 start / end 上 |
| variant | String | 同 Input，左右共用 |
| size | String | 同 Input，左右共用 |
| style.focusColor | String | 聚焦时描边 / 下划线 / 光标颜色。不写则跟 `window.theme.primary`。写在 range 上会传到左右两侧 |

```json
{
  "type": "range",
  "label": "关注数量",
  "separator": "~",
  "inputType": "number",
  "start": { "name": "follow_min", "hint": "最小", "value": "10" },
  "end": { "name": "follow_max", "hint": "最大", "value": "80" }
}
```

```json
{ "type": "range", "label": "蓝色聚焦", "separator": "~", "variant": "box", "style": { "focusColor": "#1565C0" }, "start": { "name": "blue_min", "hint": "从" }, "end": { "name": "blue_max", "hint": "到" } }
```
