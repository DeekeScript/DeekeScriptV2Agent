# 自定义组件

把一组内置组件打包复用时读这篇。规格合并了文件结构、生命周期、与父页的事件/数据。JSON 必须 `"component": true`，脚本用 `Component({})`。生命周期不是页面的 `onLoad` / `onShow`。组件写在页面 `body` 或弹层 `body` 里，不进返回栈。成环引用会拒绝加载。

## 文件与注册

```
components/choose/component.json
components/choose/component.js
```

入口可注册别名；不写则按 `components/<id>` 找目录：

```json
{
  "components": [
    { "id": "choose", "file": "components/choose" }
  ]
}
```

## JSON 字段

必须有 `"component": true`。没有这个字段的 JSON 不能当组件加载。嵌入时只用 `body`，忽略 `title` / `statusBar` / `popups`。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| component | Boolean | 必填，`true` |
| id | String | 组件名。页面里 `"type": "choose"` |
| body | Array | 内部用内置组件拼起来，也可再嵌其它自定义组件（勿成环） |
| js | String | 默认同目录 `component.js` |

```json
{
  "component": true,
  "id": "choose",
  "body": [
    { "type": "input", "name": "keyword", "label": "关键词" },
    { "type": "button", "text": "确定", "onTap": "onOk" }
  ]
}
```

## 引用

页面或其它组件的 JSON 里，把 `type` 写成组件 id：

| 参数名 | 类型 | 说明 |
|--------|------|------|
| type / src | String | 组件 id，或 `{ "type": "component", "src": "components/choose" }` |
| id | String | 给 `selectComponent` 用。不写则用组件 id |
| params | Object | 传给 `created(props)`，字符串会做 `{{path}}` 替换。只在创建时传一次 |
| onXxx | String | 组件 `triggerEvent('xxx')` 时调用的父级方法 |
| showIf | String | 为假时 `detached`，再为真只走 `attached` |

```json
{
  "body": [
    {
      "type": "choose",
      "id": "inline",
      "params": { "keyword": "{{seed}}" },
      "onConfirm": "onPicked"
    }
  ]
}
```

弹层里同样写在 `body` 中，外壳（遮罩、标题）仍由 popup 负责。见 [popup](./capabilities/popup.md)。

## 生命周期

只有三个：`created` / `attached` / `detached`。未声明的不调用。

| 时机 | 方法 |
|------|------|
| 实例创建，带父节点 `params` | `created(props)` |
| 插入界面（节点 `showIf` 为真） | `attached` |
| 从界面拿掉（`showIf` 为假、父页卸载） | `detached` |

`created` 每个实例只一次。节点反复显示隐藏：第一次 `created` → `attached`，之后只走 `attached` / `detached`。

| 场景 | 行为 |
|------|------|
| 父页第一次打开 | 可见组件 `created` → `attached` |
| `showIf` 写成假 | 该组件 `detached` |
| 再写成真 | `attached`（不再 `created`） |
| 父页 `navigate` 到二级页 | 父页 `onHide`。可见组件保持 `attached` |
| 父页切到其它 Tab | 父页 `onHide`。组件保持 `attached`（页面未卸载） |
| 父页关闭 | 树上组件 `detached` |
| 弹层显示 / 隐藏 | 弹层 `body` 里的组件 `attached` / `detached` |

组件看不到父页变量，也不走 `onReady`。

```javascript
Component({
  data: {
    keyword: ''
  },
  created: function (props) {
    if (props && props.keyword) {
      this.setData({ keyword: props.keyword });
    }
  },
  attached: function () {},
  detached: function () {}
});
```

## 与父页交互

组件 `data` 和父页隔离。来回只有三条路：

1. 父 → 子：节点 `params`，进 `created(props)`。之后父页改自己的字段不会自动再灌进组件。
2. 子 → 父：`this.triggerEvent(name, detail)`，父节点写 `onXxx`（也认 `bindXxx` / `bind:xxx`）。
3. 父读写子：`this.selectComponent(id)` 得到 `{ data, setData, call }`。找不到返回 `null`，不要调用。

| 方法 | 说明 |
|------|------|
| `this.triggerEvent(name, detail)` | 父页收到 `{ type, detail }` |
| `this.selectComponent(id)` | 按节点 `id` 找。`id` 不写则用组件 id |
| `c.data` | 只读当前组件数据 |
| `c.setData(patch)` | 写入组件并重绘 |
| `c.call(name, arg)` | 调组件上的方法 |

`confirm` → 父节点 `onConfirm`；`change` → `onChange`。

```javascript
// components/choose/component.js
Component({
  data: {
    keyword: ''
  },
  onOk: function () {
    this.triggerEvent('confirm', { keyword: this.data.keyword });
  }
});
```

```javascript
// pages/include/page.js
Page({
  data: {
    picked: '未选',
    seed: '美食'
  },
  onPicked: function (e) {
    var d = e && e.detail ? e.detail : {};
    this.setData({ picked: d.keyword || '未选' });
  },
  onWrite: function () {
    var c = this.selectComponent('inline');
    if (!c) {
      return;
    }
    c.setData({ keyword: '探店' });
  },
  onRead: function () {
    var c = this.selectComponent('inline');
    if (!c) {
      return;
    }
    this.toast(c.data.keyword);
  },
  onCall: function () {
    var c = this.selectComponent('inline');
    if (c) {
      c.call('onOk');
    }
  }
});
```
