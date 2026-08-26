# Files

文件读写、复制移动、目录与常用路径。**默认只能操作当前应用的私有目录**，不能任意操作系统路径。相册等媒体请用 MediaStore（本索引未收录）。

## 可用上下文

- **page.js** 与 **tasks.js** 都能用。外部存储相关操作可能需要文件/媒体权限，见 [`Access`](Access.md)。

## 方法

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| read | `read(path: string)` | 路径 | `string \| null` | 读全部文本；失败 null |
| write | `write(path: string, content: string)` | 路径、内容 | `boolean` | 写入；不存在则创建，存在则覆盖 |
| append | `append(path: string, content: string)` | 路径、内容 | `boolean` | 追加到末尾；不存在则创建 |
| delete | `delete(path: string)` | 文件或目录 | `boolean` | 删目录会递归 |
| exists | `exists(path: string)` | 路径 | `boolean` | 是否存在 |
| mkdirs | `mkdirs(path: string)` | 目录 | `boolean` | 创建含父目录；已存在也 true |
| list | `list(path: string)` | 目录 | `string[]` | 文件名（不含路径） |
| listFiles | `listFiles(path: string)` | 目录 | `string[]` | 完整路径 |
| copy | `copy(source, destination)` | 源、目标 | `boolean` | 复制；目标目录不存在会创建 |
| move | `move(source, destination)` | 源、目标 | `boolean` | 移动 |
| size | `size(path: string)` | 路径 | `number` | 字节数；不存在或为目录返回 -1 |
| isDirectory | `isDirectory(path: string)` | 路径 | `boolean` | |
| isFile | `isFile(path: string)` | 路径 | `boolean` | |
| getName | `getName(path: string)` | 路径 | `string` | 文件名（含扩展名） |
| getParent | `getParent(path: string)` | 路径 | `string` | 父目录 |
| getAbsolutePath | `getAbsolutePath(path: string)` | 路径 | `string` | 绝对路径 |
| rename | `rename(oldPath, newPath)` | 旧路径、新路径 | `boolean` | 重命名 |
| lastModified | `lastModified(path: string)` | 路径 | `number` | 最后修改毫秒；不存在 -1 |
| readUri | `readUri(uriString: string)` | content:// 或 file:// | `string \| null` | 从 URI 读文本 |
| readBytesFromUri | `readBytesFromUri(uriString: string)` | URI | `number[] \| null` | 从 URI 读字节 |
| getPathFromUri | `getPathFromUri(uriString: string)` | content URI | `string \| null` | 真实文件路径 |
| readBytes | `readBytes(path: string)` | 路径 | `number[] \| null` | 读字节 |
| writeBytes | `writeBytes(path: string, bytes: number[])` | 路径、字节数组 | `boolean` | 写字节 |
| copyFromUri | `copyFromUri(uriString, destination)` | 源 URI、目标路径 | `boolean` | |
| getExternalStoragePath | `getExternalStoragePath()` | 无 | `string` | 外部存储根，通常 `/sdcard` |
| getFilesPath | `getFilesPath()` | 无 | `string` | 应用私有文件目录 |
| getCachePath | `getCachePath()` | 无 | `string` | 应用缓存目录 |
| getExternalFilesPath | `getExternalFilesPath(type: string \| null)` | 如 `"Pictures"`；null 为根 | `string` | 应用外部私有目录 |
| getExternalFilesPath | `getExternalFilesPath()` | 无 | `string` | 外部私有根目录 |
| getDownloadPath | `getDownloadPath()` | 无 | `string` | Download |
| getPicturesPath | `getPicturesPath()` | 无 | `string` | Pictures |
| getDCIMPath | `getDCIMPath()` | 无 | `string` | DCIM |
| getMoviesPath | `getMoviesPath()` | 无 | `string` | Movies |
| getMusicPath | `getMusicPath()` | 无 | `string` | Music |
| getDocumentsPath | `getDocumentsPath()` | 无 | `string` | Documents |
| readAsset | `readAsset(fileName: string)` | assets 内文件名 | `string \| null` | 读 assets |
| isExternalStorageWritable | `isExternalStorageWritable()` | 无 | `boolean` | 外部存储可写 |
| isExternalStorageReadable | `isExternalStorageReadable()` | 无 | `boolean` | 外部存储可读 |
| getExtension | `getExtension(path: string)` | 路径 | `string` | 扩展名不含点；无则空串 |
| getNameWithoutExtension | `getNameWithoutExtension(path: string)` | 路径 | `string` | 不含扩展名的文件名 |

读项目内脚本/配置文件也可用 [`DeekeScript.readFile`](DeekeScript.md)（相对 JS 项目根）。

## 最小片段

```javascript
let filesPath = Files.getFilesPath();
let ok = Files.write(filesPath + '/test.txt', 'hello');
if (ok) {
  console.log(Files.read(filesPath + '/test.txt'));
}
```

## 注意

- 优先 `getFilesPath()` / `getCachePath()`，不要假设能写任意 `/sdcard` 路径。
- 索引见 [`INDEX.md`](INDEX.md)。
