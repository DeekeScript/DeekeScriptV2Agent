# webview

在页面里嵌一块 HTML。远程地址写 `http(s)`，项目内文件写相对路径（如 `html/help.html`），也可以直接写 `html`。

**必须写出 `style.height`。** 不写时引擎默认 240dp。不能按内容自动撑高。`"match"` / `"100%"` 铺满父级，块内自己滚动。

不是独立浏览器，**不与 `Page` 通信**。整页打开外链仍用 `action: { "type": "openUrl" }`。

通用字段见 [通用字段](./_common.md)。

| 参数名 | 类型 | 说明 |
|--------|------|------|
| src / url | String | 远程 `http(s)`，或项目内 HTML 路径。支持 `{{path}}` |
| html | String | 内联 HTML，优先于 `src`。支持 `{{path}}` |
| javascript | Boolean | 是否允许页内 JS，默认 `true`。不提供与 `Page` 的桥，也禁止读本地文件 |
| style.height | Number / String | 高度 dp，或 `match` / `"100%"`。不写默认 240 |
| style.radius | Number | 圆角 |

```json
{
  "type": "webview",
  "src": "https://script.deeke.cn",
  "style": { "height": 360, "radius": 8 }
}
```

```json
{
  "type": "webview",
  "html": "<h3>说明</h3><p>{{intro}}</p>",
  "javascript": false,
  "style": { "height": 200 }
}
```

## 注意

- 加载顺序：`html` 有值就用内联；否则看 `src` / `url`。
- `javascript` 默认 `true`，但没有 JS bridge，页内脚本调不到 `Page` 方法。
- 不要指望用 WebView 和页面 `setData` 互传数据。
