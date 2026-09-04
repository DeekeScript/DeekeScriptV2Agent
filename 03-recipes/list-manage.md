# 列表管理（启停 + 删除）

评论话术、关键词、开关项等「可启用列表」的标准布局。生成前读 [`switch.md`](../01-ui/components/switch.md)、[`button.md`](../01-ui/components/button.md)、[`donts.md`](../04-cheatsheets/donts.md)。

## 控件选型（必遵）

| 需求 | 用 | 不用 |
|------|----|------|
| 启用 / 停用 | `switch` | 「启用」「停用」大按钮 |
| 删除 / 编辑一次动作 | `button`，**`size": "sm"`** | 默认大按钮并排撑满 |
| 页内唯一主操作（添加、开始任务） | 一个默认大实心 `button` | 满页多个大实心按钮 |

## 布局

```text
顶部：textarea / input + 主按钮「添加」（可大）
列表行：文案（weight:1）| switch | 删除(sm)
空态：empty + showIf
```

## `pages/comments/page.json` 片段

```json
{
  "body": [
    {
      "type": "card",
      "style": { "padding": 12, "gap": 8 },
      "children": [
        {
          "type": "textarea",
          "name": "newComment",
          "label": "新增评论",
          "hint": "每条一行语义完整的话术",
          "minLines": 2,
          "variant": "box"
        },
        {
          "type": "button",
          "text": "添加",
          "onTap": "onAdd",
          "style": { "background": "#006A65", "color": "#FFFFFF" }
        }
      ]
    },
    {
      "type": "list",
      "bind": "comments",
      "item": {
        "type": "card",
        "style": { "padding": 10 },
        "children": [
          {
            "type": "row",
            "style": { "gap": 8, "valign": "center" },
            "children": [
              {
                "type": "text",
                "text": "{{item.content}}",
                "style": { "weight": 1, "fontWeight": "bold" }
              },
              {
                "type": "switch",
                "value": "{{item.enabled}}",
                "onChange": "onToggle"
              },
              {
                "type": "button",
                "text": "删除",
                "size": "sm",
                "onTap": "onDelete",
                "style": { "background": "#FFE8EC", "color": "#C62828" }
              }
            ]
          }
        ]
      }
    },
    { "type": "empty", "text": "暂无评论", "showIf": "empty" }
  ]
}
```

列表里 `switch` 的 `onChange` / 删除的 `onTap` 都会带 `e.item` / `e.index`（见 [`events.md`](../01-ui/events.md)）。`name` 规则见 [`form-name.md`](../01-ui/pitfalls/form-name.md)。

## `page.js` 片段

```javascript
Page({
  data: {
    newComment: '',
    comments: [],
    empty: true
  },
  refresh() {
    var list = Storage.getObj('demo.comments') || [];
    this.setData({
      comments: list,
      empty: list.length === 0
    });
  },
  onLoad() {
    this.refresh();
  },
  onAdd() {
    var text = (this.data.newComment || '').trim();
    if (!text) {
      this.toast('请输入内容');
      return;
    }
    var list = Storage.getObj('demo.comments') || [];
    list.unshift({ id: 'c_' + Date.now(), content: text, enabled: true });
    Storage.putObj('demo.comments', list);
    this.setData({ newComment: '' });
    this.refresh();
  },
  onToggle(e) {
    if (!e || !e.item) {
      return;
    }
    var list = Storage.getObj('demo.comments') || [];
    var i = 0;
    while (i < list.length) {
      if (list[i].id === e.item.id) {
        list[i].enabled = !!(e.value !== undefined ? e.value : !list[i].enabled);
        break;
      }
      i++;
    }
    Storage.putObj('demo.comments', list);
    this.refresh();
  },
  onDelete(e) {
    if (!e || !e.item) {
      return;
    }
    var that = this;
    Dialogs.confirm('删除', '确定删除？', function (ok) {
      if (!ok) {
        return;
      }
      var list = Storage.getObj('demo.comments') || [];
      var next = [];
      var i = 0;
      while (i < list.length) {
        if (list[i].id !== e.item.id) {
          next.push(list[i]);
        }
        i++;
      }
      Storage.putObj('demo.comments', next);
      that.refresh();
    });
  }
});
```

## 自检

- [ ] 启停是 `switch`，不是「启用/停用」按钮  
- [ ] 本页 `name` 唯一（见 [`form-name.md`](../01-ui/pitfalls/form-name.md)）  
- [ ] 删除等次要操作为 `size: "sm"`  
- [ ] 一页最多一个大实心主按钮（添加 / 开始任务）
