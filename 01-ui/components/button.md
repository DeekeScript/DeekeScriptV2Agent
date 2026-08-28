# button

主操作按钮。`size` 缺省为**大**（48dp）。可写 `onTap` 或 `action`（先调 JS 再执行动作）。`loading` 显示转圈；默认有按压涟漪。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| text / title / label | String | 按钮文案 |
| size | String | `sm` / `小` 高 32dp；`md` / `中` 高 40dp；`lg` / `大` 高 48dp（默认） |
| onTap | String | 轻触一次时调用的 `Page` 方法 |
| action | Object | 点击动作，见 [通用字段](./_common.md) 的 `action` |
| style.background | String | 背景色，默认主题绿。可写 `{{count1Bg}}`，用 `this.setData` 切换选中态 |
| style.color | String | 文字颜色，同样支持 `{{path}}` |
| variant | String | `outline` / `描边`：白底、描边和文字同色 |
| style.borderColor / borderWidth | String / Number | 描边色和宽度。outline 时默认跟 `style.color` |
| style.weight | Number | 在 row 里撑开 |
| loading | Boolean / String | 显示转圈并禁止点击。可写 `true` 或 `{{saving}}`。别名 `busy`、`加载中` |
| loadingText | String | 加载时替换按钮文案，不写则保留原文字 |
| ripple | Boolean | 按压涟漪，默认 `true` |

```json
{ "type": "button", "text": "保存", "loading": "{{saving}}", "loadingText": "保存中", "onTap": "onSave" }
```

## 注意

- `onTap` 与 `onClick` 是同一事件。同时写 `onTap` 和 `action` 时：**先执行 JS，再执行 action**。
- `size` 中英文别名：`sm`=`小`，`md`=`中`，`lg`=`大`。不写即为大按钮。
