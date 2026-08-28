# picker

底部滚轮选一项。一列选一项；`options` 带 `children` 时多列一起出，值和 [menu](./menu.md) 一样用 `/` 拼接。适合星期、上午下午这类固定文案。

**日期和时间不要用本组件**，请用 [date](./date.md) / [time](./time.md) / [datetime](./datetime.md)。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| label | String | 字段标题 |
| value | String | 当前选中项。多列时为路径，如 `"周一/上午"` |
| hint | String | 未选时的占位 |
| position | String | `bottom`（默认）/ `top` |
| options | Array | 选项，字符串或 `{ text, value, children }` |
| onChange | String | 确定后调用，`e.value` 为当前值 |

```json
{
  "type": "picker",
  "name": "slot",
  "label": "星期时段",
  "value": "周一/上午",
  "options": [
    { "text": "周一", "children": ["上午", "下午"] },
    { "text": "周二", "children": ["上午", "下午"] }
  ]
}
```

```json
{ "type": "picker", "name": "ampm", "label": "时段", "options": ["上午", "下午"] }
```

兼容：`"type": "picker", "mode": "date"` 等同 `type: date`，但新代码请直接写 `date` / `time` / `datetime`。
