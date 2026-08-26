# 页面跳转

写 JSON `action` 或 `this.navigate` / `switchTab` / `back` 时读这篇。`action` 与 `Page` 方法是同一套名字。`onTap` 与 `action` 同时存在时，先调用 JS 再执行 `action`。禁止在 `action` 里跑脚本；长任务用 `onTap` + `Engines.executeScript`。底栏切 Tab 必须用 `switchTab`，不要 `navigate`。

## 动作类型

| type / 方法 | 说明 | 主要字段 |
|-------------|------|----------|
| `navigate` | 打开另一页面 | `page`、`params` |
| `redirect` | 关掉当前二级页再打开 | `page`、`params` |
| `switchTab` | 切到底栏某一项 | `page` 或 `index` |
| `back` | 关闭当前二级页 | 无 |
| `toast` | 弹出提示 | `text`，可选 `duration` |
| `save` | 弹出提示（仅 JSON） | `toast`（可选，默认「已保存」） |
| `openUrl` | 用系统浏览器打开 | `url` |

`action` 中的字符串会做 `{{path}}` 替换。JS 里可写 `this.navigate('detail')`，字符串会当作 `page` / `text` / `url`。

## 对照

| JSON `action` | `this.xxx` |
|---------------|------------|
| `{ "type": "navigate", "page": "detail", "params": { "id": "1" } }` | `this.navigate({ page: 'detail', params: { id: 1 } })` |
| `{ "type": "redirect", "page": "detail" }` | `this.redirect('detail')` |
| `{ "type": "switchTab", "page": "home" }` | `this.switchTab('home')` |
| `{ "type": "back" }` | `this.back()` |
| `{ "type": "toast", "text": "已保存" }` | `this.toast('已保存')` |
| `{ "type": "save", "toast": "已保存" }` | 无同名方法；保存逻辑写在 `onTap`，提示用 `toast` 或 JSON `save` |
| `{ "type": "openUrl", "url": "https://deeke.cn" }` | `this.openUrl('https://deeke.cn')` |

## onTap 与 action 的顺序

两者同时存在：先跑 JS，再执行 `action`。常见组合：`onTap` 里 `Storage.put`，`action` 用 `save` 提示。

```json
{
  "type": "button",
  "text": "保存设置",
  "onTap": "onSave",
  "action": { "type": "save", "toast": "已保存" }
}
```

## navigate

`page`：目标页文件夹（如 `pages/detail`）或入口中注册的 id。`params` 带到目标页，模板用 `{{params.id}}`，`onLoad(params)` 也可读取。每次 `navigate` 打开新页面。底部 Tab 根页上的 `back` 不会退出应用。

```json
{
  "type": "button",
  "text": "打开详情",
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

## toast / openUrl

```javascript
this.toast('已保存');
this.toast({ text: '已保存', duration: 'long' });
this.openUrl('https://deeke.cn');
```

```json
{ "type": "button", "text": "官网", "action": { "type": "openUrl", "url": "https://deeke.cn" } }
```

```json
{ "type": "button", "text": "返回", "action": { "type": "back" } }
```

确认框用全局 `Dialogs`，不要再包一层 `showModal`。

## 禁止在 action 里跑脚本

```json
{ "type": "button", "text": "立即运行", "onTap": "onRun" }
```

```javascript
Page({
  onRun: function () {
    Engines.executeScript('tasks/sample.js');
  }
});
```
