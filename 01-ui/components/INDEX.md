# 内置组件

生成 UI 时**先读完** [通用字段](./_common.md)，再只打开用到的组件文件。`background` / `color` / 宽高都在 `style` 里，不是组件根字段。事件写法见 [页面 JS](../page-js.md)。

底部 TabBar **不是** `body` 里的 `type`，写在入口 `bottomMenus`，见 [tabBar](../capabilities/tabBar.md)。

overlay（`popup` / `actionSheet` / `dialog` / `modal` / `popover` / `toast` / `mask` / `imageViewer`）写在 `body` 或页面根 `popups` 里都盖在最上层，不占正文布局。

## 展示

| type | 一句话 | 链接 |
|------|--------|------|
| text | 普通正文 | [text](./text.md) |
| title | 页内大标题，不是顶栏 | [title](./title.md) |
| notice | 灰色说明小字 | [notice](./notice.md) |
| tag | 短标签 | [tag](./tag.md) |
| badge | 红色角标；不写文案则红点 | [badge](./badge.md) |
| image | 图片 | [image](./image.md) |
| avatar | 圆形/方形头像 | [avatar](./avatar.md) |
| ellipsis | 多行省略，可展开 | [ellipsis](./ellipsis.md) |
| webview | 内嵌 HTML；必须写 `style.height` | [webview](./webview.md) |
| empty | 空状态占位；列表空不会自动出现 | [empty](./empty.md) |
| swiper | 走马灯 banner | [swiper](./swiper.md) |
| imageViewer | 全屏看图 overlay | [imageViewer](./imageViewer.md) |
| noticeBar | 顶部滚动通告 | [noticeBar](./noticeBar.md) |
| loading | 行内转圈；整页用 `this.showLoading` | [loading](./loading.md) |
| skeleton | 骨架屏占位 | [skeleton](./skeleton.md) |
| progress / progressBar | **只读**进度条，不能拖 | [progress](./progress.md) |
| progressCircle | **只读**圆环进度 | [progressCircle](./progressCircle.md) |
| collapse | 折叠面板 | [collapse](./collapse.md) |

## 表单

| type | 一句话 | 链接 |
|------|--------|------|
| button | 主操作；列表次要用 size sm | [button](./button.md) |
| input | 单行输入 | [input](./input.md) |
| textarea | 多行输入 | [textarea](./textarea.md) |
| search / searchBar | 圆角搜索框 | [search](./search.md) |
| range | 最小值～最大值双输入 | [range](./range.md) |
| stepper | 加减数字 | [stepper](./stepper.md) |
| slider | **可拖**滑动条（运行速度、概率） | [slider](./slider.md) |
| switch | 布尔开关；列表启停用它 | [switch](./switch.md) |
| select | 单选下拉 | [select](./select.md) |
| checkbox | 单勾选为布尔，带 options 为数组 | [checkbox](./checkbox.md) |
| radio | 一组里只能选一项 | [radio](./radio.md) |
| rate | 星星评分 | [rate](./rate.md) |
| imageUploader | 相册多图，值为路径数组 | [imageUploader](./imageUploader.md) |
| menu | 多级选择，每级一列同时显示 | [menu](./menu.md) |
| cascader | 级联，同 menu | [cascader](./cascader.md) |
| selector | 一排筛选胶囊 | [selector](./selector.md) |
| date | 日期滚轮，值 `yyyy-MM-dd` | [date](./date.md) |
| time | 时分滚轮，值 `HH:mm` | [time](./time.md) |
| datetime | 先日期后时分，值 `yyyy-MM-dd HH:mm` | [datetime](./datetime.md) |
| picker | 用 `options` 的滚轮；日期时间请用 date/time/datetime | [picker](./picker.md) |

## 导航

| type | 一句话 | 链接 |
|------|--------|------|
| tabs | 页内选项卡，不是底部 TabBar | [tabs](./tabs.md) |
| segmented | 一行互斥分段，无面板 | [segmented](./segmented.md) |
| navBar | 页内导航栏；系统顶栏用页面 `title` | [navBar](./navBar.md) |
| sideBar | 左侧分类轨 | [sideBar](./sideBar.md) |
| indexBar | 通讯录字母轨 | [indexBar](./indexBar.md) |
| steps | 步骤条 | [steps](./steps.md) |
| pageIndicator | 分页圆点/短条 | [pageIndicator](./pageIndicator.md) |

## 反馈 overlay

| type | 一句话 | 链接 |
|------|--------|------|
| popup | 盖在当前页上的弹层 | [popup](./popup.md) |
| actionSheet | 底部动作列表 | [actionSheet](./actionSheet.md) |
| dialog | 居中确认框 | [dialog](./dialog.md) |
| modal | 居中内容容器 | [modal](./modal.md) |
| popover | 贴着组件的气泡 | [popover](./popover.md) |
| toast | 轻提示；优先 `this.toast` / `action.toast` | [toast](./toast.md) |
| mask / overlay | 独立背景蒙层 | [mask](./mask.md) |

## 布局

| type | 一句话 | 链接 |
|------|--------|------|
| divider | 横向分割线 | [divider](./divider.md) |
| space | 空白间距 | [space](./space.md) |
| row | 横向排列子项 | [row](./row.md) |
| column | 纵向排列子项 | [column](./column.md) |
| card | 白底圆角容器；可写成可选中卡片 | [card](./card.md) |
| list | 按数组循环渲染 | [list](./list.md) |
| grid | 按列数排宫格 | [grid](./grid.md) |
