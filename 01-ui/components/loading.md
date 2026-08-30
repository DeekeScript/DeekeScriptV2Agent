# loading

转圈，可选文字。不要一进页就显示，用 `showIf` 交给 JS：列表滚到底时在 `onReachBottom` 里打开，请求结束后关掉。

整页遮罩（不必在 JSON 里放节点）用 `this.showLoading` / `this.hideLoading`，见 [页面 JS](../page-js.md)。

通用字段见 [通用字段](./_common.md)。列表触底见 [list](./list.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| text / title / label | String | 可选说明，支持 `{{path}}` |
| mode | String | `row` 横向转圈（默认）；`column` 转圈在上；`dots` 三点跳动 |
| size | Number | 转圈边长，默认 18；`column` 时默认 28 |
| showIf | String | 为真时显示。不要默认常显 |
| style.color | String | 转圈 / 三点颜色。不写则跟 `window.theme.primary` |

```json
{ "type": "loading", "text": "加载中", "showIf": "loading" }
```

```json
{ "type": "loading", "text": "蓝色加载", "style": { "color": "#1565C0" } }
```

```json
{ "type": "loading", "mode": "dots", "text": "请稍候" }
```

```javascript
Page({
  data: {
    loading: false
  },
  onLoadMore() {
    this.setData({ loading: true });
    System.sleep(1000);
    this.setData({ loading: false });
  },
  onMask() {
    this.showLoading('加载中');
    var that = this;
    setTimeout(function () {
      that.hideLoading();
    }, 1500);
  }
});
```

## 注意

- JSON 里的 `loading` 是行内转圈，靠 `showIf` 控制。
- 整页遮罩不要写组件，直接调 `this.showLoading` / `this.hideLoading`。
