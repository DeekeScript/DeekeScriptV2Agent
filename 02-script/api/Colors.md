# Colors

基于 OpenCV 的颜色查找（`Mat`）。日常找色/截图优先用 [`Images`](Images.md)。

## 可用上下文

- **tasks.js** 为主（依赖图色能力）。

## 方法

### getMat(file)

```javascript
let mat = Colors.getMat('img/screen.png');
```

### getMatByAssetsFile(file) / getMatByAssetFile(file)

```javascript
let mat1 = Colors.getMatByAssetsFile('demo.png');
let mat2 = Colors.getMatByAssetFile('project/assets/img/a.png');
```

### find(source, hexColor, rect?, tolerance?)

`#RRGGBB` / `RRGGBB`；自动处理 BGR/RGBA。

```javascript
let mat = Colors.getMat('img/screen.png');
let points = Colors.find(mat, '#FF0000');
let points2 = Colors.find(mat, 'FF0000', null, 5);
console.log(points.length, points2.length);
```

### show(image)

调试输出像素日志。

```javascript
Colors.show(Colors.getMat('img/screen.png'));
```

## 注意

- 需要容差/区域/多点特征时，优先 `Images.findColor*` / `findMultiColors`。
- 索引见 [`INDEX.md`](INDEX.md)。
