# 配置页表单

一页：`input` / `textarea` / `range` / `switch` / `slider`，保存到 `Storage`。输入会写回 `this.data`，点保存才持久化。任务脚本用同一 key 去 `Storage.get`。可调节数值必须用 `slider`，不要用只读的 `progress`。

相关：[`Storage.md`](../02-script/api/Storage.md)、[`run-task-from-ui.md`](./run-task-from-ui.md)。

## `pages/settings/page.json`

```json
{
  "title": {
    "text": "设置",
    "fontSize": 18,
    "color": "#FFFFFF",
    "background": "#006A65"
  },
  "style": {
    "background": "#F5F5F5",
    "padding": 10
  },
  "body": [
    {
      "type": "card",
      "children": [
        { "type": "input", "name": "task_name", "label": "任务名", "hint": "请输入", "variant": "box" },
        { "type": "textarea", "name": "keyword", "label": "关键词", "hint": "每行一个", "minLines": 3, "variant": "box" },
        {
          "type": "range",
          "label": "关注数量",
          "separator": "~",
          "inputType": "number",
          "variant": "box",
          "start": { "name": "follow_min", "hint": "最小" },
          "end": { "name": "follow_max", "hint": "最大" }
        },
        { "type": "switch", "name": "notify", "label": "完成通知" },
        {
          "type": "slider",
          "name": "like_rate",
          "label": "点赞概率",
          "min": 0,
          "max": 100,
          "unit": "%"
        }
      ]
    },
    { "type": "space", "height": 8 },
    { "type": "button", "text": "保存", "onTap": "onSave", "action": { "type": "save", "toast": "已保存" }, "style": { "background": "#006A65", "color": "#FFFFFF" } }
  ]
}
```

`action.save` 只弹提示，真正写入在 `onTap`。不要在 `action` 里跑任务。

## `pages/settings/page.js`

键名加项目前缀，避免和系统 `deekeScript:important` 冲突。

```javascript
Page({
  data: {
    task_name: '早间养号',
    keyword: '',
    follow_min: '10',
    follow_max: '80',
    notify: true,
    like_rate: 20
  },
  onLoad() {
    let task_name = Storage.get('demo.task_name');
    if (task_name) {
      this.setData({ task_name: task_name });
    }
    let keyword = Storage.get('demo.keyword');
    if (keyword) {
      this.setData({ keyword: keyword });
    }
    if (Storage.contains('demo.follow_min')) {
      this.setData({ follow_min: Storage.get('demo.follow_min') });
    }
    if (Storage.contains('demo.follow_max')) {
      this.setData({ follow_max: Storage.get('demo.follow_max') });
    }
    if (Storage.contains('demo.notify')) {
      this.setData({ notify: Storage.getBoolean('demo.notify') });
    }
    if (Storage.contains('demo.like_rate')) {
      this.setData({ like_rate: Storage.getInteger('demo.like_rate') });
    }
  },
  onSave() {
    Storage.put('demo.task_name', this.data.task_name);
    Storage.put('demo.keyword', this.data.keyword);
    Storage.put('demo.follow_min', this.data.follow_min);
    Storage.put('demo.follow_max', this.data.follow_max);
    Storage.putBoolean('demo.notify', this.data.notify);
    Storage.putInteger('demo.like_rate', this.data.like_rate);
  }
});
```

入口 `pages` 注册 `"id": "settings", "file": "pages/settings"`。底栏指向 `pages/settings`。

## 任务里读取

```javascript
let name = Storage.get('demo.task_name');
let notify = Storage.getBoolean('demo.notify');
let rate = Storage.getInteger('demo.like_rate');
```

## 注意

- `name` 必须和 `data` 键一致。
- `range` 左右是两个 `name`，不要写成一个字段。
- 布尔用 `putBoolean` / `getBoolean`，整数滑动值用 `putInteger` / `getInteger`。
- 点赞概率 / 运行速度用 `"type": "slider"`，不要 `"type": "progress"`。
