# Cos

腾讯云对象存储上传。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 短上传可以 |
| `tasks/*.js` | 是 |

## 方法

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `setConfig(secretId, secretKey, region, bucket)` | 腾讯云密钥、地域如 `"ap-guangzhou"`、桶名如 `"my-bucket-1234567890"` | — | 设置并初始化客户端。换账号或桶再调一次 |
| `upload(localPath, cosKey)` | 本地路径、COS 对象键如 `"images/photo.jpg"` | `[url, error]` | 同步上传；成功时 `url` 有值、`error` 为 null |
| `upload(localPath)` | 仅本地路径 | `[url, error]` | 自动生成 `uploads/时间戳_文件名` |
| `uploadAsync(localPath, cosKey, callback)` | `callback` 含 `success(url)`、`fail(error)` | — | 异步，不阻塞 |
| `uploadAsync(localPath, callback)` | 自动 cosKey | — | 异步 |
| `shutdown()` | 无 | — | 关闭客户端，释放网络资源 |

## 最小片段

```javascript
Cos.setConfig(
  'YOUR_SECRET_ID',
  'YOUR_SECRET_KEY',
  'ap-guangzhou',
  'my-bucket-1234567890'
);

let result = Cos.upload('/sdcard/DCIM/photo.jpg', 'images/photo.jpg');
if (result[0]) {
  console.log('上传成功：' + result[0]);
} else {
  console.log('上传失败：' + result[1]);
}

Cos.shutdown();
```

## 注意

- 密钥勿写进公开仓库；生产环境用服务端临时密钥更安全。
- 索引见 [`INDEX.md`](INDEX.md)。
