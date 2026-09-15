# Env

返回 `java.io.File` 目录句柄。日常拼路径字符串请优先用 [`Files`](Files.md) 的 `getFilesPath` / `getCachePath` 等。

## 可用上下文

- **page.js** 与 **tasks.js** 都能用。

## 方法

| 方法 | 签名 | 返回值 | 说明 |
|------|------|--------|------|
| getFilesDir | `getFilesDir()` | `File` | 应用私有 files |
| getCacheDir | `getCacheDir()` | `File` | 应用缓存 |
| getDataDir | `getDataDir()` | `File` | 应用 data |
| getExternalFilesDir | `getExternalFilesDir(dir: string \| null)` | `File` | 外部私有目录 |
| getExternalCacheDir | `getExternalCacheDir()` | `File` | 外部缓存 |
| getExternalMediaDirs | `getExternalMediaDirs()` | `File[]` | 外部媒体目录列表 |
| getDownloadDir | `getDownloadDir()` | `File` | 系统 Download |
| getDcimDir | `getDcimDir()` | `File` | 系统 DCIM |

## 最小片段

```javascript
let dir = Env.getFilesDir();
console.log(dir.getAbsolutePath());
```

## 注意

- 返回的是 Java `File`，可用 `.getAbsolutePath()` 转字符串再交给 `Files`。
- 索引见 [`INDEX.md`](INDEX.md)。
