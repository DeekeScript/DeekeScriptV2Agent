# Images

截图、摄像头拍照、找图、找色、裁剪、缩放、文字识别。截图被运行时间悬浮窗挡住时，先 `System.setTimeWindowShow(false)`。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 可用，但截图/找图通常在 `tasks/*.js` |
| `tasks/*.js` | 是 |

## 前置权限

图色（`capture` 等）需要**屏幕截图（MediaProjection）**权限：

```javascript
if (!Access.isMediaProjectionEnable()) {
  Dialogs.confirm('提示', '请开启屏幕截图权限', function (result) {
    Access.openMediaProjectionSetting();
    System.exit();
  });
}
```

`takePhoto` **不需要** MediaProjection，但需要 [CAMERA 权限](./Access.md)（`Access.hasCameraPermission` / `requestCameraPermission`）；用后置摄像头静默拍 JPEG。

无障碍不是本模块前置；找图找不到节点时才用图色。HID 模式点滑也常配合本模块识别界面。

## 方法

图片：

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `capture()` | 无 | `string` | 屏幕截图，返回图片地址（需 MediaProjection） |
| `takePhoto()` | 无 | `string` | 后置摄像头静默拍照，默认写入 cache（需 [CAMERA](./Access.md)） |
| `takePhoto(path)` | `path {string}` 可选 | `string` | 保存到指定路径（绝对 / `project://` / 相对项目根） |
| `getMat(imageFile)` | 图片地址 | `Mat` | 矩阵对象 |
| `findOne(source, template, threshold)` | 两个 `Mat`，阈值如 `0.8` | `Point` | 从 source 找 template，找不到为 `null` |
| `find(source, template, threshold)` | 同上 | `Point[]` | 全部匹配位置 |
| `crop(imageFile, left, top, width, height)` | 地址与裁剪矩形 | `string` | 裁剪后图片地址 |
| `scale(imageFile, multiple)` | 缩放倍数 | `string` | 缩放后图片地址 |

文字：

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `getTextAndRegion(imageFile)` | 图片地址 | `TextAndRegion[]` | 每项 `text` + `rect` |
| `findTextPosition(imageFile, keyword)` | 关键字 | `Rect[]` | 所有匹配区域 |
| `findTextInRegion(imageFile, left, top, width, height)` | 矩形 | `string[]` | 区域内文字 |

颜色：

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `getColor(imageFile, pixelX, pixelY)` | 坐标 | `string` | 如 `rgba(255,255,255,1.0)` |
| `findColor(imageFile, color)` | rgba 字符串 | `Point[]` | 精确匹配 |
| `findColor(imageFile, startColor, endColor)` | 两个 rgba | `Point[]` | 颜色区间，适配不同机型色差 |

`Point`：`x` `y`。`Rect`：`left` `top` `right` `bottom`，以及 `width()` `height()` `centerX()` `centerY()`。

## 最小片段

```javascript
if (!Access.isMediaProjectionEnable()) {
  Access.openMediaProjectionSetting();
  System.exit();
}

try {
  let imageFile = Images.capture();
  let color = Images.getColor(imageFile, 100, 100);
  console.log(color);
} catch (e) {
  console.log('截图异常：' + e.message);
}

// 摄像头拍照（不走录屏权限）
try {
  let photo = Images.takePhoto();
  console.log('照片：' + photo);
} catch (e) {
  console.log('拍照失败：' + e.message);
}
```

## 注意

- 未开录屏权限不要调用 `capture()`。`takePhoto` 与截图无关，缺 [CAMERA](./Access.md) 会抛异常。
- 找图阈值常用 `0.8`。`findOne` 未找到返回 `null`，先判断再读 `point.x`。
- 区间找色：`startColor` 与 `endColor` 的 R/G/B/A 分别构成闭区间。
- 与 [`ScreenRecord`](./ScreenRecord.md) 同时用时：录屏中仍可 `capture()`，建议已开无障碍。
- 相关：[`Access.md`](./Access.md)、[`Hid.md`](./Hid.md)、[`MediaStore.md`](./MediaStore.md)、[`ScreenRecord.md`](./ScreenRecord.md)。
