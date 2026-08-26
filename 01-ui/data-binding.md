# 数据绑定

写 `{{path}}`、`showIf`、表单 `name`、list / grid 的 `bind` 时读这篇。模板从 `Page.data`（组件则从 `Component.data`）取值。路径不存在时替换为空字符串。表单输入会写回 `this.data`，不触发整页刷新；`showIf` 让新节点出现时会整页重绘。

## {{path}} 规则

| 写法 | 含义 |
|------|------|
| `{{hello}}` | `data` 中的字段 |
| `{{data.hello}}` | 同上 |
| `{{item.title}}` | 列表当前项 |
| `{{index}}` | 列表下标，从 0 开始 |
| `{{params.id}}` | 跳转参数（`navigate` 的 `params`，`onLoad(params)` 也能读） |
| `{{storage.task_name}}` | 本地 Storage |
| `{{item.tags.0}}` | 数组下标 |
| `{{item.user.name}}` | 嵌套字段 |

`text` / `title` / `label`、`action` 里的字符串、组件 `params` 都会做替换。

```json
{
  "body": [
    { "type": "text", "text": "当前账号：{{account}}" },
    { "type": "notice", "text": "{{storage.task_name}}" }
  ]
}
```

```javascript
Page({
  data: {
    account: '运营A'
  }
});
```

## showIf

| 参数名 | 类型 | 说明 |
|--------|------|------|
| showIf | String | 条件显示，值为作用域路径。为真时渲染该节点 |

路径相对当前作用域：页面根上写 `"showIf": "loading"` 对应 `data.loading`；列表项里写 `"showIf": "item.pinned"`。

```json
{ "type": "loading", "text": "加载中", "showIf": "loading" }
```

```json
{
  "type": "text",
  "text": "{{footer}}",
  "showIf": "noMore",
  "style": { "align": "center", "color": "#9AA8A6", "fontSize": 12 }
}
```

弹层同样用 `showIf` 控制显示，见 [popup](./capabilities/popup.md)。

## 表单 name 双向绑定

`name` 对应 `data` 中的键。初始值放 `Page({ data })`，用户输入写回 `this.data`。`name` 也会做 `{{path}}` 替换，所以 list 里可以写 `{{item.key}}`。未写 `name` 时可用 `id`。

| 组件 | 绑定 |
|------|------|
| input / textarea / search | 字符串 |
| switch | 布尔 |
| select / radio / tabs | 选中 `value` |
| checkbox | 按组件约定写入 `data` |
| progress | 数字 |
| range | `start.name` / `end.name` 两个键 |

保存后任务脚本用 `Storage` 读，不要在任务里访问 `Page.data`。

```json
{
  "body": [
    { "type": "input", "name": "task_name", "label": "任务名", "hint": "请输入" },
    { "type": "switch", "name": "notify", "label": "完成通知" },
    { "type": "button", "text": "保存", "onTap": "onSave", "action": { "type": "save" } }
  ]
}
```

```javascript
Page({
  data: {
    task_name: '早间养号',
    notify: true
  },
  onSave: function () {
    Storage.put('task_name', this.data.task_name);
    Storage.putBoolean('notify', this.data.notify);
  }
});
```

```javascript
// tasks/sample.js
var name = Storage.getString('task_name');
var notify = Storage.getBoolean('notify');
```

## list / grid 的 bind

| 参数名 | 类型 | 说明 |
|--------|------|------|
| bind | String | 数据路径，对应 `data` 中的数组，如 `"tasks"` 或 `"item.tags"` |
| id | String | 未写 `bind` 时当作 `bind` |
| item | Object / Array | 每一项的组件模板。数组则包一层 column |
| columns | Number | 仅 grid：列数 |
| direction | String | 仅 list：`column`（默认）或 `row` |
| empty | String | grid 数组为空时的提示。list 为空不渲染行，空提示用 `empty` 组件自己摆 |

循环内用 `{{item.xxx}}`、`{{index}}`。内层 list 的 `bind` 可写 `item.tags`；内层循环中 `{{item}}` 为当前内层项。同一页多个 `bind` 互不影响。`setData` 整表替换；追加用 `this.appendData('tasks', more)`。

```json
{
  "type": "list",
  "bind": "logs",
  "item": {
    "type": "card",
    "action": { "type": "navigate", "page": "detail", "params": { "id": "{{item.id}}" } },
    "children": [
      { "type": "text", "text": "{{item.title}}", "style": { "fontWeight": "bold" } },
      { "type": "notice", "text": "{{item.time}}" }
    ]
  }
}
```

```json
{
  "type": "grid",
  "bind": "apps",
  "columns": 3,
  "item": {
    "type": "card",
    "children": [
      { "type": "image", "src": "{{item.icon}}", "style": { "width": "50%" } },
      { "type": "text", "text": "{{item.name}}", "style": { "fontSize": 11, "align": "center" } }
    ]
  }
}
```

```javascript
Page({
  data: {
    logs: [
      { id: 1, title: '今日关注 12 人', time: '10:21' }
    ],
    apps: [
      { id: 'dy', name: '抖音', icon: 'img/dy.svg' }
    ]
  }
});
```

list 项里的 `onTap` 调用 `Page` 方法，`e` 含 `item`、`index`。
