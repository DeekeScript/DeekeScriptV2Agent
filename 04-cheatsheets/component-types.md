# 组件 type 速查

全部内置 `type` 一行一条。自定义组件用入口里注册的 `id` 当 type（如 `choose`）。通用字段：`id` `hidden` `showIf` `action` `onTap`（同 `onClick`）`onDoubleTap` `onLongPress` `style`。

| type | 关键字段 | 何时用 |
|------|----------|--------|
| `text` | `text` | 正文 |
| `title` | `text` | 页内大标题（不是导航栏） |
| `notice` | `text` | 灰色说明、注释 |
| `tag` | `text`；`style.background` / `color` | 短状态标签 |
| `badge` | `text`（不写则红点） | 角标，常和 `row` 并排 |
| `image` | `src` / `url`；`fit`；`style.width` / `height` | 图片。宫格入口图 `"width": "50%"` |
| `webview` | `src` / `html`；**必须写 `style.height`** | 嵌 HTML。不和 Page 通信 |
| `empty` | `icon` `text` `showIf` | 空态。列表不会自动出现 |
| `button` | `text` `size` `onTap` `action` | 主操作。跑脚本用 `onTap` |
| `input` | `name` `label` `hint` `variant` `inputType` `password` | 单行。`name` 对应 `data` |
| `textarea` | `name` `minLines` `variant` | 多行 |
| `search` | `name` `hint` `onChange` | 搜索框 |
| `range` | `label` `start.name` `end.name` `separator` | 最小～最大两个输入 |
| `progress` | `name` `min` `max` `unit` | 可拖进度，别名 `slider` |
| `switch` | `name` `label` | 布尔开关 |
| `select` | `name` `options` | 下拉单选 |
| `checkbox` | `name` `options?` | 无 options 为布尔；有则为多选数组 |
| `radio` | `name` `options` | 一组单选 |
| `menu` | `name` `options`（含 `children`） | 多级（省市区），值用 `/` 拼接 |
| `date` | `name` `label` | 日期 |
| `time` | `name` `label` | 时间 |
| `datetime` | `name` `label` | 日期时间 |
| `picker` | `name` `options` | 选择器 |
| `divider` | 无 | 横线分隔 |
| `space` | `height` | 空白间距 dp |
| `row` | `children`；`style.gap` `valign` | 横向 |
| `column` | `children`；`style.align` `valign` | 纵向 |
| `card` | `children`；可选 `name` `value` `multiple` | 容器；带 name 则可选中 |
| `tabs` | `name` `options` / `children` | 选项卡 |
| `tabBar` | 少写在 body 里 | 底栏改用入口 `bottomMenus` 或 `this.setTabBar*` |
| `list` | `bind` `item`；可选 `direction: row` | 数组逐条渲染 |
| `grid` | `bind` `columns` `item` | 宫格 |
| `popup` | `showIf` `position` `body` | 弹层。也可写在页面根 `popups` |
| `loading` | `text` `showIf` | 列表底部转圈。整页遮罩用 `this.showLoading` |
| 自定义 id | `onXxx` 对应 `triggerEvent('xxx')` | 先注册。JSON 必须 `"component": true` |

详情与示例见官方组件文档；配方：[`workbench.md`](../03-recipes/workbench.md)、[`settings-form.md`](../03-recipes/settings-form.md)、[`list-load-more.md`](../03-recipes/list-load-more.md)、[`custom-picker.md`](../03-recipes/custom-picker.md)。
