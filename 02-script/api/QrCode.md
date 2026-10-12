# QrCode

本地生成二维码图片（底座 ZXing），不依赖外网拉图。常用于支付扫码、分享链接。

## 可用上下文

- **page.js** 与 **tasks.js** 都能用。

## 方法

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| toFile | `toFile(content)` | 文本内容 | `string \| null` | 写到缓存目录，返回绝对路径 |
| toFile | `toFile(content, size)` | 内容、边长 px | `string \| null` | 指定尺寸 |
| toFile | `toFile(content, options)` | 内容、选项对象 | `string \| null` | 完整参数，见下表 |
| toBase64 | `toBase64(content)` / `(content, size)` / `(content, options)` | 同左 | `string \| null` | 纯 Base64，无 `data:` 前缀 |
| toDataUrl | `toDataUrl(content)` / `(content, size)` / `(content, options)` | 同左 | `string \| null` | `data:image/png;base64,...` |
| toBytes | `toBytes(content)` / `(content, options)` | 同左 | `byte[] \| null` | 原始图片字节 |

### options 字段

| 字段 | 类型 | 默认 | 说明 |
|------|------|------|------|
| size / width / height | number | `400` | 边长 px，范围约 64–2048 |
| margin / quietZone | number | `1` | 静区（模块数） |
| level / errorCorrection / ecc | string | `"M"` | 纠错：`L` / `M` / `Q` / `H` |
| foreground / color / dark | string | `"#000000"` | 前景色，支持 `#RGB` / `#RRGGBB` |
| background / light / bg | string | `"#FFFFFF"` | 背景色 |
| format / type | string | `"png"` | `png` / `jpg` / `jpeg` / `webp` |
| quality | number | `100` | JPEG/WebP 质量 0–100 |
| path / file / dest | string | 缓存自动名 | 自定义输出绝对路径 |
| fileUrl | boolean | `false` | `true` 时返回 `file://` + 路径 |
| charset / encoding | string | `"UTF-8"` | 内容编码 |

失败（空内容、编码失败、写盘失败）返回 `null`。

## 最小片段

```javascript
let path = QrCode.toFile('https://qr.alipay.com/baxxxx', {
  size: 400,
  margin: 1,
  level: 'M'
});
// page.json: { "type": "image", "src": "{{qrPath}}" }
```

```javascript
let dataUrl = QrCode.toDataUrl('hello', 240);
```

## 支付扫码示例

```javascript
let qrText = payParams.qrCode; // 支付宝当面付返回的字符串
let qrPath = QrCode.toFile(qrText, { size: 400, margin: 2, level: 'M' });
if (!qrPath) {
  this.toast('二维码生成失败');
  return;
}
this.setData({ qrOpen: true, qrImage: qrPath });
```

## 注意

- 不要对 `QrCode` 使用 `typeof`（Rhino 对 Java 对象可能报错）；直接调用，用返回值是否为空判断失败。
- `image` 的 `src` 可用绝对路径或 `file://` 路径；优先 `toFile`。
- 内容过长或纠错过高可能导致编码失败，可降 `level` 或缩短内容。
- 索引见 [`INDEX.md`](INDEX.md)。相关：[`Alipay`](Alipay.md)、[`Files`](Files.md)。
