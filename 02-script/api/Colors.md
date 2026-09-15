# Colors

基于 OpenCV 的颜色查找（`Mat`）。日常找色/截图优先用 [`Images`](Images.md)。

## 可用上下文

- **tasks.js** 为主（依赖图色能力）。

## 方法

| 方法 | 签名 | 返回值 | 说明 |
|------|------|--------|------|
| getMat | `getMat(file: string)` | `Mat` | 从项目存储目录读图 |
| getMatByAssetsFile | `getMatByAssetsFile(file: string)` | `Mat` | assets 示例目录 |
| getMatByAssetFile | `getMatByAssetFile(file: string)` | `Mat` | assets 路径 |
| find | `find(source: Mat, hexColor: string, rect?: Rect)` | `Point[]` | 按 `#RRGGBB` / `RRGGBB` 找色 |
| show | `show(image: Mat)` | `void` | 调试打像素日志 |

## 最小片段

```javascript
let mat = Colors.getMat('img/screen.png');
let points = Colors.find(mat, 'FF0000');
console.log(points.length);
```

## 注意

- 索引见 [`INDEX.md`](INDEX.md)。
