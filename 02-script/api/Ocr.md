# Ocr（Images 文字识别）

对截图或指定区域做 OCR。API 挂在 `Images` 上。截图/找图见 [`Images.md`](./Images.md)。

匹配模式 `mode`：`contains`（默认）/ `exact` / `regex`。`TextAndRegion`：`text` `rect` `confidence`。

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
let hits = Images.findText(screen, '关注');
let exact = Images.findTextExact(screen, '下一步');
let reg = Images.findTextMatches(screen, '￥\\d+');
```

### findTextFirst / findTextCenter

```javascript
let first = Images.findTextFirst(screen, '搜索');
let p = Images.findTextCenter(screen, '登录');
if (p) Hid.tap(p.x, p.y);
```

### findTextPosition(file, kw, mode?)

```javascript
let rects = Images.findTextPosition(screen, '百度一下');
```

### findTextInRegion

```javascript
// 旧：区域内字符串
let arr = Images.findTextInRegion(screen, 0, 0, 1080, 1920);
// 新：区域内按关键字，带坐标
let hits = Images.findTextInRegion(screen, '关注', 0, 200, 1080, 800);
```

### waitText / waitTextGone

```javascript
Images.waitText('加载完成', 10000);
Images.waitTextGone('加载中', 8000);
```

## 注意

- 区域 OCR 先裁切再识别，比全屏更快。
- 相关：[`Images.md`](./Images.md)、[`Hid.md`](./Hid.md)。
