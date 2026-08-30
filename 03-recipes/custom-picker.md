# 自定义选择组件

组件目录：`component.json` + `component.js`，JSON 必须 `"component": true`。入口 `components` 注册后，页面用 `"type": "choose"`。组件用 `this.triggerEvent('confirm', payload)`，父页写 `onConfirm`。

## 文件清单

```
deekeScript.json          （components 注册）
components/choose/component.json
components/choose/component.js
pages/home/page.json
pages/home/page.js
```

## 入口注册

```json
{
  "homePage": "pages/home",
  "components": [
    { "id": "choose", "file": "components/choose" }
  ]
}
```

不写 `components` 时引擎按 `components/<id>` 目录加载，但显式注册更稳。

## `components/choose/component.json`

```json
{
  "component": true,
  "id": "choose",
  "body": [
    { "type": "notice", "text": "点快捷标签，或自己输入后再确定。" },
    {
      "type": "row",
      "style": { "gap": 8 },
      "children": [
        { "type": "tag", "text": "美食", "onTap": "pickFood" },
        { "type": "tag", "text": "探店", "onTap": "pickShop" }
      ]
    },
    { "type": "input", "name": "keyword", "label": "关键词", "hint": "例如：美食" },
    { "type": "button", "text": "确定选用", "onTap": "onOk" }
  ]
}
```

漏写 `"component": true` 时不能当组件加载。

## `components/choose/component.js`

```javascript
Component({
  data: {
    keyword: ''
  },
  created(props) {
    if (props && props.keyword) {
      this.setData({ keyword: props.keyword });
    }
  },
  pickFood() {
    this.setData({ keyword: '美食' });
  },
  pickShop() {
    this.setData({ keyword: '探店' });
  },
  onOk() {
    this.triggerEvent('confirm', { keyword: this.data.keyword });
  }
});
```

`triggerEvent('confirm')` 对应父页 `onConfirm`（首字母大写）。payload 在父页 `e.detail`。

## 父页 `pages/home/page.json`

```json
{
  "title": { "text": "选用", "color": "#FFFFFF", "background": "#006A65" },
  "style": { "background": "#F5F5F5", "padding": 12 },
  "body": [
    { "type": "choose", "id": "inline", "onConfirm": "onPicked" },
    { "type": "title", "text": "{{picked}}" },
    { "type": "button", "text": "弹窗选择", "onTap": "onOpen" }
  ],
  "popups": [
    {
      "title": "选关键词",
      "position": "bottom",
      "showIf": "open",
      "body": [
        { "type": "choose", "id": "picker", "onConfirm": "onPicked" }
      ]
    }
  ]
}
```

## 父页 `pages/home/page.js`

```javascript
Page({
  data: {
    open: false,
    picked: '未选'
  },
  onOpen() {
    this.setData({ open: true });
  },
  onPicked(e) {
    var keyword = '';
    if (e && e.detail) {
      keyword = e.detail.keyword;
    }
    this.setData({ open: false, picked: keyword || '未选' });
  }
});
```

## 注意

- 组件 JSON 不是 `page.json`，不要写页面 `title` / `popups` 当组件根字段（嵌入只用 `body`）。
- 父页用 `this.selectComponent('inline')` 取实例（需要组件 `id`）。
- 不要箭头函数、不要 `?.`。
- 相关：[`donts.md`](../04-cheatsheets/donts.md)。
