# button

主操作按钮。`size` 缺省为**大**。可写 `onTap` 或 `action`（先调 JS 再执行动作）。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| text / title / label | String | 按钮文案 |
| size | String | `sm` / `小` 紧凑；`md` / `中` 卡片内操作；`lg` / `大` 主操作（默认） |
| onTap | String | 轻触一次时调用的 `Page` 方法 |
| action | Object | 点击动作，见 [通用字段](./_common.md) 的 `action` |
| style.background | String | 背景色，默认主题绿。可写 `{{count1Bg}}`，用 `this.setData` 切换选中态 |
| style.color | String | 文字颜色，同样支持 `{{path}}` |
| style.weight | Number | 在 row 里撑开 |

```json
{
  "type": "button",
  "text": "保存",
  "size": "md",
  "onTap": "onSave",
  "action": { "type": "toast", "text": "已保存" }
}
```

## 注意

- `onTap` 与 `onClick` 是同一事件。同时写 `onTap` 和 `action` 时：**先执行 JS，再执行 action**。
- `size` 中英文别名：`sm`=`小`，`md`=`中`，`lg`=`大`。不写即为大按钮。
