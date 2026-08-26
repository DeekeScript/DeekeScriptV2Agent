# 内置组件

生成 UI 时只打开用到的组件文件。通用字段和 Style 见 [通用字段](./_common.md)。事件写法见 [页面 JS](../page-js.md)。

底部 TabBar 不是 `body` 里的 `type`，不要当组件生成。

| type | 分类 | 一句话 | 链接 |
|------|------|--------|------|
| text | 展示 | 普通正文 | [text](./text.md) |
| title | 展示 | 页内大标题，不是顶栏 | [title](./title.md) |
| notice | 展示 | 灰色说明小字 | [notice](./notice.md) |
| tag | 展示 | 短标签 | [tag](./tag.md) |
| badge | 展示 | 红色角标；不写文案则红点 | [badge](./badge.md) |
| image | 展示 | 图片 | [image](./image.md) |
| webview | 展示 | 内嵌 HTML；必须写 `style.height` | [webview](./webview.md) |
| empty | 展示 | 空状态占位；列表空不会自动出现 | [empty](./empty.md) |
| button | 表单 | 主操作按钮 | [button](./button.md) |
| input | 表单 | 单行输入 | [input](./input.md) |
| textarea | 表单 | 多行输入 | [textarea](./textarea.md) |
| search | 表单 | 圆角搜索框 | [search](./search.md) |
| range | 表单 | 最小值～最大值双输入 | [range](./range.md) |
| progress | 表单 | 可拖动进度条，别名 `slider` | [progress](./progress.md) |
| switch | 表单 | 布尔开关 | [switch](./switch.md) |
| select | 表单 | 单选下拉 | [select](./select.md) |
| checkbox | 表单 | 单勾选为布尔，带 options 为数组 | [checkbox](./checkbox.md) |
| radio | 表单 | 一组里只能选一项 | [radio](./radio.md) |
| menu | 表单 | 多级选择，每级一列同时显示 | [menu](./menu.md) |
| date | 表单 | 日期滚轮，值 `yyyy-MM-dd` | [date](./date.md) |
| time | 表单 | 时分滚轮，值 `HH:mm` | [time](./time.md) |
| datetime | 表单 | 先日期后时分，值 `yyyy-MM-dd HH:mm` | [datetime](./datetime.md) |
| picker | 表单 | 用 `mode` 等同 date / time / datetime | [picker](./picker.md) |
| divider | 布局 | 横向分割线 | [divider](./divider.md) |
| space | 布局 | 空白间距 | [space](./space.md) |
| row | 布局 | 横向排列子项 | [row](./row.md) |
| column | 布局 | 纵向排列子项 | [column](./column.md) |
| card | 布局 | 白底圆角容器；可写成可选中卡片 | [card](./card.md) |
| tabs | 结构 | 页内选项卡，不是底部 TabBar | [tabs](./tabs.md) |
| list | 结构 | 按数组循环渲染 | [list](./list.md) |
| grid | 结构 | 按列数排宫格 | [grid](./grid.md) |
| popup | 结构 | 盖在当前页上的弹层 | [popup](./popup.md) |
| loading | 结构 | 转圈；整页遮罩用 `this.showLoading` | [loading](./loading.md) |
