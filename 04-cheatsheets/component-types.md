# 组件 type 速查

全部内置 `type` 一行一条。自定义组件用入口里注册的 `id` 当 type（如 `choose`）。通用字段：`id` `hidden` `showIf` `action` `onTap`（同 `onClick`）`onDoubleTap` `onLongPress` `style`。

**`slider` ≠ `progress`。** 运行速度、点赞概率用 `slider`；上传/任务进度用 `progress` / `progressBar`。

| type | 关键字段 | 何时用 |
|------|----------|--------|
| `text` | `text` | 正文 |
| `title` | `text` | 页内大标题（不是导航栏） |
| `notice` | `text` | 灰色说明、注释 |
| `noticeBar` | `text` `scroll` | 顶部通告条 |
| `tag` | `text`；`style.background` / `color` | 短状态标签 |
| `badge` | `text`（不写则红点） | 角标，常和 `row` 并排 |
| `image` | `src` / `url`；`fit`；`style.width` / `height` | 图片。宫格入口图 `"width": "50%"` |
| `avatar` | `src` `text` `size` `shape` | 头像 |
| `ellipsis` | `text` `rows` `expand` | 多行省略 |
| `webview` | `src` / `html`；**必须写 `style.height`** | 嵌 HTML。不和 Page 通信 |
| `empty` | `icon` `text` `showIf` | 空态。列表不会自动出现 |
| `swiper` | `bind` `item` `height` `autoplay` | 走马灯 |
| `imageViewer` | `showIf` `urls` `index` | 全屏看图 overlay |
| `skeleton` | `rows` `avatar` `showIf` | 骨架屏 |
| `button` | `text` `size` `onTap` `action` `loading` | 主操作。跑脚本用 `onTap` |
| `input` | `name` `label` `hint` `variant` `inputType` `password` | 单行。`name` 对应 `data` |
| `textarea` | `name` `minLines` `variant` | 多行 |
| `search` / `searchBar` | `name` `hint` `onChange` `onSearch` | 搜索框 |
| `range` | `label` `start.name` `end.name` `separator` | 最小～最大两个输入 |
| `stepper` | `name` `min` `max` `step` | 加减数字 |
| `slider` | `name` `min` `max` `unit` `marks` | **可拖**数值。运行速度、概率 |
| `progress` / `progressBar` | `name` `value` `unit` | **只读**进度，不能拖 |
| `progressCircle` | `name` `value` `size` | **只读**圆环 |
| `switch` | `name` `label` | 布尔开关 |
| `select` | `name` `options` | 下拉单选 |
| `checkbox` | `name` `options?` | 无 options 为布尔；有则为多选数组 |
| `radio` | `name` `options` | 一组单选 |
| `rate` | `name` `count` `allowHalf` | 星星评分 |
| `imageUploader` | `name` `max` | 相册多图，值为路径数组 |
| `menu` / `cascader` | `name` `options`（含 `children`） | 多级（省市区），值用 `/` 拼接 |
| `selector` | `name` `options` `multiple` | 筛选胶囊 |
| `date` | `name` `label` | 日期 `yyyy-MM-dd` |
| `time` | `name` `label` | 时间 `HH:mm` |
| `datetime` | `name` `label` | 日期时间 |
| `picker` | `name` `options` | 固定文案滚轮；日期时间不要用 picker |
| `segmented` | `name` `options` | 一行互斥分段 |
| `tabs` | `name` `options` / `children` | 选项卡（带面板） |
| `navBar` | `title` `leftText` `onLeft` `onRight` | 页内导航栏。系统顶栏用页面 `title` |
| `sideBar` | `name` `items` | 左侧分类轨 |
| `indexBar` | `bind` `item` `indexKey` | 通讯录字母轨 |
| `steps` | `name` `value` `items` | 步骤条，下标从 0 |
| `pageIndicator` | `name` `count` `value` | 分页圆点 |
| `tabBar` | 少写在 body 里 | 底栏改用入口 `bottomMenus` 或 `this.setTabBar*` |
| `divider` | 无 | 横线分隔 |
| `space` | `height` | 空白间距 dp |
| `row` | `children`；`style.gap` `valign` | 横向 |
| `column` | `children`；`style.align` `valign` | 纵向 |
| `card` | `children`；可选 `name` `value` `multiple` | 容器；带 name 则可选中 |
| `list` | `bind` `item`；可选 `direction: row` | 数组逐条渲染 |
| `grid` | `bind` `columns` `item` | 宫格 |
| `collapse` | `name` `items` `accordion` | 折叠面板 |
| `popup` | `showIf` `position` `body` | 弹层。也可写在页面根 `popups` |
| `actionSheet` | `showIf` `items` | 底部动作列表 |
| `dialog` | `showIf` `title` `text` | 居中确认 |
| `modal` | `showIf` `body` | 居中内容容器 |
| `popover` | `showIf` `for` `text` | 贴着组件的气泡 |
| `toast` | `text` 或 `this.toast` | 轻提示 |
| `mask` / `overlay` | `showIf` `opacity` | 独立蒙层 |
| `loading` | `text` `showIf` `mode` | 列表底部转圈。整页遮罩用 `this.showLoading` |
| 自定义 id | `onXxx` 对应 `triggerEvent('xxx')` | 先注册。JSON 必须 `"component": true` |

详情：[`01-ui/components/INDEX.md`](../01-ui/components/INDEX.md)。配方：[`workbench.md`](../03-recipes/workbench.md)、[`settings-form.md`](../03-recipes/settings-form.md)、[`list-load-more.md`](../03-recipes/list-load-more.md)、[`custom-picker.md`](../03-recipes/custom-picker.md)。
