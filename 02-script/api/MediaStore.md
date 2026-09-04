# MediaStore

系统媒体库：图片、视频、音频、下载、文档。自动兼容不同 Android 版本。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 是 |
| `tasks/*.js` | 是 |

## 前置权限

必须先有媒体读取权限：

```javascript
if (!Access.hasMediaReadPermission()) {
  if (Access.isMediaPermissionPermanentlyDenied()) {
    Access.openPermissionSettings();
    System.exit();
  } else {
    Access.requestMediaPermissions();
    System.exit();
  }
}
```

Android 13+ 请求 `READ_MEDIA_IMAGES` / `READ_MEDIA_VIDEO`；10–12 请求 `READ_EXTERNAL_STORAGE`；9- 还含写权限。

## 方法

图片：

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `getImages()` | 无 | `Array` | 相册全部图片。项含 `id` `name` `path` `uri` `size` `date` |
| `getImagesByPath(path)` | 相对目录，如 `"Pictures/WeiXin"`、`"DCIM/Camera"` | `Array` | 按目录取图（d.ts 未列出） |
| `saveImage(sourcePath)` | 源路径 | `string\|null` | 保存到相册，返回 `content://` |
| `saveImage(sourcePath, displayName, relativePath)` | 名称、相对目录可选 | `string\|null` | 指定名称和目录 |
| `saveContentImageToGallery(contentUriString, displayName?, relativePath?)` | content URI | `string\|null` | 不复制文件直接入库（d.ts 未列出） |
| `deleteImage(uriString)` | `content://` | `boolean` | 删图 |

视频 / 音频：

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `getVideos()` | 无 | `Array` | 项含 `duration` 等 |
| `saveVideo(sourcePath, displayName?, relativePath?)` | 源路径 | `string\|null` | 保存视频 |
| `deleteVideo(uriString)` | `content://` | `boolean` | 删视频 |
| `getAudios()` | 无 | `Array` | 项含 `artist` `album` |
| `saveAudio(sourcePath, displayName?)` | 源路径 | `string\|null` | 保存音频 |

下载 / 文档 / 通用：

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `saveToDownloads(sourcePath, displayName?)` | 源路径 | `string\|null` | Android 10+ 返回 content URI；9- 返回 file URI |
| `getDownloads()` | 无 | `Array` | 下载目录文件 |
| `saveToDocuments(sourcePath, displayName?)` | 源路径 | `string\|null` | 保存到文档目录 |
| `getDocuments()` | 无 | `Array` | 文档列表 |
| `readFromUri(uriString)` | `content://` | `number[]\|null` | 读字节数组 |
| `queryMediaInfo(uriString)` | `content://` | 对象 | `name` `size` `mimeType` |

## 最小片段

```javascript
if (!Access.hasMediaReadPermission()) {
  Access.requestMediaPermissions();
  System.exit();
}

let imageFile = Images.capture();
let uri = MediaStore.saveImage(imageFile, 'screenshot.jpg');
console.log(uri);
```

## 注意

- 先申请媒体权限，再读写相册。
- `Images.capture()` 另外需要录屏/截图权限，见 [`Images.md`](./Images.md)。
- 相关权限 API：[`Access.md`](./Access.md)。
