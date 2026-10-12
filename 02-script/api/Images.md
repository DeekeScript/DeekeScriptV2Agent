# Images

截图、摄像头拍照、找图、裁剪、缩放。文字识别见 [`Ocr.md`](./Ocr.md)；日常取色/找色见下方「颜色」；OpenCV `Mat` 找色见 [`Colors.md`](./Colors.md)。截图被运行时间悬浮窗挡住时，先 `System.setTimeWindowShow(false)`。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 可用，但截图/找图通常在 `tasks/*.js` |
| `tasks/*.js` | 是 |

## 前置权限

图色（`capture` 等）需要**屏幕截图（MediaProjection）**权限：

```javascript
if (!Access.isMediaProjectionEnable()) {
  Access.openMediaProjectionSetting();
  System.exit();
}
```

`takePhoto` **不需要** MediaProjection，但需要 [CAMERA 权限](./Access.md)。

## 图片 / 找图

`ImageMatch`：`x` `y` `centerX` `centerY` `score` `width` `height`。点击用中心点。

### capture()

```javascript
let screen = Images.capture();
```

### takePhoto() / takePhoto(path)

```javascript
let photo = Images.takePhoto();
let photo2 = Images.takePhoto(Files.getCachePath() + '/shot.jpg');
```

### getMat(imageFile)

```javascript
let mat = Images.getMat(Images.capture());
```

### findOne(source, template, threshold?)

```javascript
let p = Images.findOne(Images.capture(), '/sdcard/tpl.png', 0.8);
if (p) console.log(p.x, p.y);
```

### findOneMatch(source, template, threshold?)

```javascript
let m = Images.findOneMatch(Images.capture(), '/sdcard/tpl.png', 0.8);
if (m) console.log(m.centerX, m.centerY, m.score);
```

### findOneInRegion(src, tpl, threshold, left, top, w, h)

```javascript
let m = Images.findOneInRegion(Images.capture(), '/sdcard/tpl.png', 0.8, 0, 0, 1080, 800);
```

### find(source, template, threshold)

```javascript
let points = Images.find(Images.capture(), '/sdcard/icon.png', 0.8);
```

### findMatches(src, tpl, threshold)

```javascript
let matches = Images.findMatches(Images.capture(), '/sdcard/icon.png', 0.8);
```

### crop / scale

```javascript
let cropped = Images.crop(Images.capture(), 0, 0, 200, 200);
let scaled = Images.scale(cropped, 0.5);
```

## 颜色

颜色格式：`rgba(...)` / `rgb(...)` / `#RRGGBB`。下列均在 `Images` 上。

### getColor / getColorHex

```javascript
Images.getColor(screen, 100, 100);
Images.getColorHex(screen, 100, 100);
```

### findColor

```javascript
Images.findColor(screen, '#FFFFFF');
Images.findColor(screen, '#FFFFFF', 8);
Images.findColor(screen, 'rgba(252,253,254,0.9)', 'rgba(255,255,255,1.0)');
```

### findColorInRegion / findColorFirst / findColorCenter

```javascript
Images.findColorInRegion(screen, '#3480F8', 10, 0, 0, 1080, 400);
let p = Images.findColorFirst(screen, '#FF0000', 5);
let c = Images.findColorCenter(screen, '#3480F8', 10);
```

### findMultiColors

```javascript
let p = Images.findMultiColors(screen, '#FF0000', [[10, 0, '#00FF00'], [0, 10, '#0000FF']], 5);
```

## 注意

- 未开录屏权限不要 `capture()`。
- 找图阈值常用 `0.8`。未找到为 `null`。
- 相关：[`Ocr.md`](./Ocr.md)、[`Access.md`](./Access.md)、[`Hid.md`](./Hid.md)、[`Colors.md`](./Colors.md)。
