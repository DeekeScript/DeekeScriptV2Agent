# slider

可拖动滑动条，用来让用户选一个数值（运行速度、点赞概率、间隔）。**不要写成 `progress` / `progressBar`**：那是只读进度条。

通用字段见 [通用字段](./_common.md)。只读进度见 [progress](./progress.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| label | String | 整行标题 |
| value | Number | 默认值；不写则用 `min` |
| min / max | Number | 默认 `0` / `100` |
| step | Number | 步进，默认 `1`。有 `marks` 时仍按步进，不会吸到档位 |
| unit | String | 显示在当前值后面，如 `ms`、`%` |
| showValue | Boolean | 是否显示当前值，默认 `true` |
| marks / dots | Array / Number / Boolean | 轨道刻度：`[0,25,50,75,100]`；数字 `5` 均分 5 点；`true` 配合 `markCount`。不限制停靠位置 |
| markCount | Number | `marks: true` 时均分点数，默认 5 |
| disabled / readonly | Boolean | 不可拖动 |
| onChange | String | 变化时调用，`e.value` 为数字。写在 list / grid 行内时还有 `e.item`、`e.index` |
| style.color | String | 左侧已走完轨道颜色。不写则跟 `window.theme.primary` |
| style.thumbColor | String | 滑块圆点颜色。不写则跟 `style.color` |
| style.trackColor | String | 未走完轨道颜色，默认 `#E3EBEA` |

```json
{
  "type": "slider",
  "name": "speed",
  "label": "运行速度",
  "value": 50,
  "min": 0,
  "max": 100,
  "unit": "%",
  "marks": [0, 25, 50, 75, 100]
}
```

```json
{ "type": "slider", "name": "delay", "label": "间隔", "value": 1500, "min": 500, "max": 3000, "step": 500, "unit": "ms" }
```

```json
{ "type": "slider", "name": "tone", "label": "蓝色滑条", "value": 60, "style": { "color": "#1565C0" } }
```

## 注意

- `type` 必须写 `slider`。`progress` / `progressBar` 不能拖。
- 保存到 Storage 用 `putInteger` / `getInteger`。
