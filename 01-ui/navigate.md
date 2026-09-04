# 页面跳转

写 `this.navigate` / `redirect` / `switchTab` / `back`，或需要理解页面栈时读这篇。JSON `action` 的完整类型与示例见 [`page-json.md`](./page-json.md#json-action)。组件 `onTap` 见 [`events.md`](./events.md)。

底栏切 Tab 必须用 `switchTab`，不要 `navigate`。

## navigate

`page`：目标页文件夹（如 `pages/detail`）或入口中注册的 id。`params` 带到目标页，模板用 `{{params.id}}`，`onLoad(params)` 也可读取。每次 `navigate` 打开新页面。底部 Tab 根页上的 `back` 不会退出应用。

```json
{
  "type": "button",
  "text": "打开详情",
  "style": { "background": "#006A65", "color": "#FFFFFF" },
  "action": {
    "type": "navigate",
    "page": "detail",
    "params": {
      "id": "{{item.id}}",
      "from": "stats"
    }
  }
}
```

```javascript
Page({
  openDetail: function () {
    this.navigate({ page: 'detail', params: { id: 1 } });
  }
});
```

## redirect / switchTab / back

```javascript
this.redirect({ page: 'detail', params: { id: 2 } });
this.switchTab('home');
this.switchTab({ page: 'pages/home' });
this.back();
```

| 方法 | 行为 |
|------|------|
| `redirect` | 先打开目标页，再关掉当前二级页。从底栏根页调用时等同 `navigate`，不会退出应用 |
| `switchTab` | 只切 `bottomMenus` 里的项。切走的 Tab 只 `onHide`，数据和滚动保留；再点回来只 `onShow`。当前若在二级页，会先关掉二级页 |
| `back` | 只关闭二级页 |

## 相关

- 全部 `action` type：[`page-json.md`](./page-json.md#json-action)
- 按钮事件与跑脚本：[`events.md`](./events.md)
