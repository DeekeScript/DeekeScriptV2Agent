# 界面速查

生成 UI 时打开本篇即可。组件细节再开 [`01-ui/components/INDEX.md`](../01-ui/components/INDEX.md) 里对应单篇。`action` 权威：[`page-json.md`](../01-ui/page-json.md#json-action)。页面方法细节：[`page-js.md`](../01-ui/page-js.md)。事件：[`events.md`](../01-ui/events.md)。

通用字段：`id` `hidden` `showIf` `action` `onTap`（同 `onClick`）`onDoubleTap` `onLongPress` `style`。

**`slider` ≠ `progress`。** 可拖数值用 `slider`；只读进度用 `progress` / `progressBar`。

## 组件 type

| type | 关键字段 | 何时用 |
|------|----------|--------|
| `text` | `text` | 正文 |
| `title` | `text` | 页内大标题（不是导航栏） |
| `notice` | `text` | 灰色说明 |
| `noticeBar` | `text` `scroll` | 顶部通告条 |
| `tag` | `text`；`style.background` / `color` | 短状态标签 |
| `badge` | `text`（不写则红点） | 角标 |
| `image` | `src` / `url`；`fit`；`style.width` / `height` | 宫格入口图 `"width": "50%"` |
| `avatar` | `src` `text` `size` `shape` | 头像 |
| `ellipsis` | `text` `rows` `expand` | 多行省略 |
| `webview` | `src` / `html`；**必须写 `style.height`** | 不和 Page 通信 |
| `empty` | `icon` `text` `showIf` | 空态。列表不会自动出现 |
| `swiper` | `bind` `item` `height` `autoplay` | 走马灯 |
| `imageViewer` | `showIf` `urls` `index` | 全屏看图 |
| `skeleton` | `rows` `avatar` `showIf` | 骨架屏 |
| `button` | `text` `size` `onTap` `action` `loading` | 列表次要必须 `sm` |
| `input` | `name` `label` `hint` `variant` `inputType` `password` | 单行 |
| `textarea` | `name` `minLines` `variant` | 多行 |
| `search` / `searchBar` | `name` `hint` `onChange` `onSearch` | 搜索框 |
| `range` | `label` `start.name` `end.name` `separator` | 两个输入 |
| `stepper` | `name` `min` `max` `step` | 加减数字 |
| `slider` | `name` `min` `max` `unit` `marks` | **可拖**数值 |
| `progress` / `progressBar` | `name` `value` `unit` | **只读**，不能拖 |
| `progressCircle` | `name` `value` `size` | **只读**圆环 |
| `switch` | `name` `label` | 布尔开关。列表 `onChange` 有 `e.value` / `e.item` / `e.index` |
| `select` | `name` `options` | 下拉单选。列表同样带 `e.item` / `e.index` |
| `checkbox` | `name` `options?` | 无 options 为布尔。列表同样带 `e.item` / `e.index` |
| `radio` | `name` `options` | 一组单选 |
| `rate` | `name` `count` `allowHalf` | 星星 |
| `imageUploader` | `name` `max` | 相册多图 |
| `menu` / `cascader` | `name` `options`（含 `children`） | 多级，值用 `/` 拼接 |
| `selector` | `name` `options` `multiple` | 筛选胶囊 |
| `date` | `name` `label` | `yyyy-MM-dd` |
| `time` | `name` `label` | `HH:mm` |
| `datetime` | `name` `label` | 日期时间 |
| `picker` | `name` `options` | 固定文案滚轮；日期时间不要用 picker |
| `segmented` | `name` `options` | 一行互斥分段 |
| `tabs` | `name` `options` / `children` | 选项卡 |
| `navBar` | `title` `leftText` `onLeft` `onRight` | 页内导航栏。系统顶栏用页面 `title` |
| `sideBar` | `name` `items` | 左侧分类轨 |
| `indexBar` | `bind` `item` `indexKey` | 通讯录字母轨 |
| `steps` | `name` `value` `items` | 步骤条，下标从 0 |
| `pageIndicator` | `name` `count` `value` | 分页圆点 |
| `tabBar` | 少写在 body 里 | 改用入口 `bottomMenus` |
| `divider` | 无 | 横线 |
| `space` | `height` | 空白 dp |
| `row` | `children`；`style.gap` `valign` | 横向 |
| `column` | `children`；`style.align` `valign` | 纵向 |
| `card` | `children`；可选 `name` `value` `multiple` | 容器 |
| `list` | `bind` `item`；可选 `direction: row` | 数组逐条 |
| `grid` | `bind` `columns` `item` | 宫格 |
| `collapse` | `name` `items` `accordion` | 折叠 |
| `popup` | `showIf` `position` `body` | 也可写在根 `popups` |
| `actionSheet` | `showIf` `items` | 底部动作列表 |
| `dialog` | `showIf` `title` `text` | 居中确认 |
| `modal` | `showIf` `body` | 居中内容 |
| `popover` | `showIf` `for` `text` | 气泡 |
| `toast` | `text` 或 `this.toast` | 轻提示 |
| `mask` / `overlay` | `showIf` `opacity` | 蒙层 |
| `loading` | `text` `showIf` `mode` | 列表底部转圈。整页用 `this.showLoading` |
| 自定义 id | `onXxx` 对应 `triggerEvent('xxx')` | JSON 必须 `"component": true` |

## JSON action

与 `onTap` 同时存在时**先 JS 再 action**。

| type | JSON 要点 | JS |
|------|-----------|-----|
| `navigate` | `page`、`params` | `this.navigate(...)` |
| `redirect` | `page`、`params` | `this.redirect(...)` |
| `switchTab` | `page` 或 `index` | `this.switchTab(...)` |
| `back` | 无 | `this.back()` |
| `toast` | `text`，可选 `duration` | `this.toast(...)` |
| `save` | 仅 JSON；`toast` 可选 | 无同名方法；写入在 `onTap` |
| `openUrl` | `url` | `this.openUrl(...)` |

## 页面 `this` 方法

自定义组件里调这些方法，走的是所在页面。

| 方法 | 作用 |
|------|------|
| `this.setData({ key: value })` | 按字段更新。点分路径：`{ 'user.name': '运营A' }` |
| `this.appendData('tasks', more)` | 向数组末尾追加 |
| `this.navigate` / `redirect` / `switchTab` / `back` | 页面栈 |
| `this.toast` / `openUrl` / `setTitle` / `scrollTo` | 提示、外链、标题、滚动（`y` 为 px） |
| `this.showPopup` / `hidePopup` | 弹层 |
| `this.showLoading` / `hideLoading` | 整页遮罩（不是 JSON `loading`） |
| `this.stopPullDownRefresh` | 结束下拉刷新 |
| `this.setTabBar` / `setTabBarItem` / `setTabBarStyle` | 底栏。无参 `setTabBar` 恢复入口 |
| `this.selectComponent(id)` | 自定义组件实例 |

生命周期（未声明不调用）：`onLoad(params)` `onShow` `onReady` `onHide` `onUnload`。

滚动 / 手势：`onScroll`（`e.scrollY`）`onReachBottom` `onReachTop` `onPullDownRefresh` `onTap` `onDoubleTap` `onLongPress` `onSwipe*`。

表单输入写回 `this.data`，不必每次 `setData`。`showIf` 新出现的节点会整页重绘。列表触底转圈用 JSON `loading` + `showIf`。
