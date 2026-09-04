# 组件与按钮事件

写组件 JSON 上的 `onTap` / `onChange` 等，并在 `page.js` 里实现对应方法时读这篇。页面空白滚动/滑动与生命周期见 [`page-js.md`](./page-js.md)。轻触后的框架动作见 [`page-json.md`](./page-json.md#json-action)。

## 通用事件字段

所有内置组件（含 `button`）可写，见 [`_common.md`](./components/_common.md)：

| JSON 字段 | 时机 | Page 方法 |
|-----------|------|-----------|
| `onTap` / `onClick` | 轻触一次 | 同名方法，如 `"onTap": "onSave"` → `onSave: function () {}` |
| `onDoubleTap` | 连续轻触两次 | 同名方法 |
| `onLongPress` | 按住不放 | 同名方法 |
| `onChange` | 表单值变化 | `e.value` 为新值 |
| `onFocus` / `onBlur` | 输入框焦点 | 同名方法 |
| `onScroll` / `onReachBottom` / `onReachTop` | list / grid 滚动 | 同名方法 |

组件上写了对应事件时，页面空白处的同名页面事件不会再收到。同时写了轻触和双击时，轻触会略慢。

未在 `Page({})` 里声明的方法名不会被调用。

## 与 action 的关系

| 写法 | 用途 |
|------|------|
| 只写 `action` | 跳转、提示、开外链等框架动作 |
| 只写 `onTap` | 自定义逻辑：存 Storage、拉起任务、改 `setData` |
| 两者都写 | **先** `onTap` JS，**再** `action` |

```json
{
  "type": "button",
  "text": "保存设置",
  "onTap": "onSave",
  "action": { "type": "save", "toast": "已保存" },
  "style": { "background": "#006A65", "color": "#FFFFFF" }
}
```

```javascript
Page({
  onSave: function () {
    Storage.put('settings', this.data);
  }
});
```

## 按钮跑脚本

按钮写 `onTap`，在 `page.js` 里启动任务：

```json
{ "type": "button", "text": "立即运行", "onTap": "onRun", "style": { "background": "#006A65", "color": "#FFFFFF" } }
```

```javascript
let permission = require('../../common/permission.js');

Page({
  onRun: function () {
    permission.runScript('tasks/sample.js');
    // 或：Engines.executeScript('tasks/sample.js');
  }
});
```

`Engines.executeScript` 路径相对**项目根**。完整写法见 [`ui-and-task.md`](../02-script/ui-and-task.md)。

**禁止**：在 `onTap` 里写长时间无障碍循环；业务放 `tasks/*.js`。

## 列表项事件

list / grid 行上的 `onTap`，回调可带 `e.item` / `e.index`：

```javascript
Page({
  onItemTap: function (e) {
    this.navigate({ page: 'detail', params: { id: e.item.id } });
  }
});
```

也可用行上的 `action` + `{{item.id}}`，见 [`page-json.md`](./page-json.md#json-action)、[`data-binding.md`](./data-binding.md)。

## 相关

- 按钮样式：[`button.md`](./components/button.md)
- 页面方法全集：[`page-js.md`](./page-js.md)、速查 [`ui.md`](../04-cheatsheets/ui.md#页面-this-方法)
