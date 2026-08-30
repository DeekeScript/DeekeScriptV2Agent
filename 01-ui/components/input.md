# input

单行输入。`name` 对应 `data` 中的键，`value` 为默认值。`name` 也会做 `{{path}}` 替换，所以 list 里可以写 `{{item.key}}`。

默认是底部一条横线。需要网页式圆角边框时写 `variant: "box"`，或直接在 `style` 里写 `radius` / `borderColor` / `borderWidth`。无边框、只有背景写 `variant: "plain"`。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| name | String | 对应 `data` 中的键 |
| label | String | 字段标题 |
| value | String | 默认值 |
| hint | String | 占位 |
| password | Boolean | 等价于 `inputType: password` |
| passwordToggle | Boolean | 密码框自动在右侧显示眼睛：闭眼为密文，睁眼为明文 |
| inputType | String | `text`（默认）/ `password` / `number`（小数）/ `digit`（整数）/ `email` / `phone` / `url` |
| variant | String | `line` / `下划线`（默认）；`box` / `边框` 为圆角边框；`plain` / `无边框` 为无描边纯背景 |
| size | String | 仅边框样式生效。`sm` / `小`、`md`（默认）、`lg` / `大` |
| style.radius | Number | 边框圆角 dp；写出后自动切到边框样式。`sm` 默认 4，`md` 默认 6，`lg` 默认 8 |
| style.borderWidth | Number | 描边宽度 dp，默认 1 |
| style.borderColor | String | 描边颜色，默认 `#DAE5E3` |
| style.focusColor | String | 聚焦时描边 / 下划线 / 光标颜色。不写则跟 `window.theme.primary` |
| style.cursorColor | String | 光标颜色。不写则跟 `focusColor` |
| style.hintColor | String | 占位文字颜色 |
| style.background | String | 输入区背景，默认 `#FFFFFF` |
| icon / prefixIcon | String | 左侧图标，项目内图片或 `http(s)` |
| iconSize | Number | 左侧图标边长 dp，默认 18。也可写在 `style.iconSize` |
| onChange | String | 值变化时调用，`e.value` 是新值 |
| onFocus / onBlur | String | 获得 / 失去焦点 |

```json
{
  "type": "input",
  "name": "password",
  "hint": "密码",
  "variant": "box",
  "password": true,
  "passwordToggle": true,
  "icon": "img/user.svg"
}
```

```json
{ "type": "input", "name": "focus_blue", "label": "蓝色聚焦", "hint": "focusColor", "variant": "box", "style": { "focusColor": "#1565C0" } }
```

## 别名

- `variant`：`line` / `下划线`；`box` / `边框` / `outline` / `outlined` / `border` / `filled` / `框`；`plain` / `无边框` / `纯背景` / `fill` / `soft`
- `inputType` 中文：`密码`、`数字`、`整数`、`邮箱`、`手机`、`网址`
- `passwordToggle`：`togglePassword`、`明文`、`可见`
- `icon`：`prefixIcon`、`startIcon`、`prefix`、`前图标`

## 注意

密码框加上 `passwordToggle: true` 后，引擎在右侧画眼睛，工程里不用放图，也不用自己配右侧图标。
