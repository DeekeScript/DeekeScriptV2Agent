# Ocr（Images 文字识别）

对截图或指定区域做 OCR。API 挂在 `Images` 上。截图/找图见 [`Images.md`](./Images.md)。

`TextAndRegion`：`text` `rect` `confidence`。

`findText` / `findTextFirst` / `findTextCenter` / `findTextPosition` / `findTextRegionsInRegion` / `waitText` / `waitTextGone` 的 **`mode` 同一套**：匹配 OCR **整行**，可省略，默认 `contains`。

| `mode` | 含义 | 关键字怎么写 |
|--------|------|----------------|
| `"contains"`（默认） | 行文本包含关键字 | `"登录"` |
| `"exact"` | 整行完全相等 | `"确定"` |
| `"regex"` | Java 正则，行内 `find` | `"\\d{4,}"`；非法正则当不匹配 |

## 上下文

| 环境 | 可用 |
|------|------|
| `tasks/*.js` | 是（需 MediaProjection） |

## 方法

### getTextAndRegion(file)

```javascript
let lines = Images.getTextAndRegion(Images.capture());
console.log(lines[0].text, lines[0].confidence);
```

### getTextAndRegionInRegion(file, l, t, w, h)

```javascript
let lines = Images.getTextAndRegionInRegion(Images.capture(), 0, 0, 1080, 600);
```

### getText(file) / getTextInRegion(...)

```javascript
let all = Images.getText(Images.capture());
let part = Images.getTextInRegion(Images.capture(), 0, 100, 1080, 400);
```

### ocr() / ocr(l, t, w, h)

```javascript
let lines = Images.ocr();
let regionLines = Images.ocr(0, 0, 1080, 500);
```

### hasText / hasTextExact / hasTextMatches

```javascript
Images.hasText(screen, '登录');
Images.hasTextExact(screen, '确定');
Images.hasTextMatches(screen, '\\d{4,}');
```

### findText / findTextExact / findTextMatches

```javascript
let hits = Images.findText(screen, '关注'); // 默认 contains
let regHits = Images.findText(screen, '\\d+', 'regex');
let exact = Images.findTextExact(screen, '下一步');
let reg = Images.findTextMatches(screen, '￥\\d+');
```

### findTextFirst / findTextCenter

```javascript
let first = Images.findTextFirst(screen, '搜索');
let exactFirst = Images.findTextFirst(screen, '确定', 'exact');
let p = Images.findTextCenter(screen, '登录');
if (p) Hid.tap(p.x, p.y);
```

### findTextPosition(file, keyword, mode?)

返回匹配行的 `Rect[]`。第三参数 `mode`：`contains`（默认）/ `exact` / `regex`。

```javascript
let rects = Images.findTextPosition(screen, '百度一下');
Images.findTextPosition(screen, '确定', 'exact');
Images.findTextPosition(screen, '\\d{4,}', 'regex');
```

### findTextInRegion(file, l, t, w, h)

区域内文字 `string[]`（只有文字，没有坐标）。按关键字找坐标用 `findTextRegionsInRegion`。

```javascript
let arr = Images.findTextInRegion(screen, 0, 0, 1080, 1920);
```

### findTextRegionsInRegion(file, keyword, l, t, w, h)

区域内按关键字查找，返回 `TextAndRegion[]`。`mode` 默认 `contains`。

```javascript
let hits = Images.findTextRegionsInRegion(screen, '关注', 0, 200, 1080, 800);
if (hits.length > 0) {
    console.log(hits[0].text, hits[0].rect.centerX(), hits[0].rect.centerY());
}
```

### findTextRegionsInRegion(file, keyword, mode, l, t, w, h)

带匹配模式的区域查找。`mode`：`contains` / `exact` / `regex`。

```javascript
let hits = Images.findTextRegionsInRegion(screen, '^下一.?$', 'regex', 0, 0, 1080, 400);
```

### waitText / waitTextGone

```javascript
Images.waitText('加载完成', 10000);
Images.waitTextGone('加载中', 8000);
```

## 注意

- 区域 OCR 先裁切再识别，比全屏更快。
- 相关：[`Images.md`](./Images.md)、[`Hid.md`](./Hid.md)。
