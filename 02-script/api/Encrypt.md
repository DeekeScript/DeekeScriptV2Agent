# Encrypt

字符串哈希、Base64、AES-CBC。`page.js` 与任务脚本都能用。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 是 |
| `tasks/*.js` | 是 |

## 方法

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `md5(input)` | `string` | `string` | MD5 |
| `sha1(input)` | `string` | `string` | SHA1 |
| `sha256(input)` | `string` | `string` | SHA256 |
| `base64Encode(input)` | `string` 或 `byte[]` | `string` | Base64 编码 |
| `base64Decode(input)` | `string` | `string` | Base64 解码 |
| `hmac_sha256(key, data)` | 密钥、待签名数据 | `string` | 官方文档：HMAC-SHA256，十六进制。d.ts 未列出 |
| `generateIv()` | 无 | `string` | 生成 AES IV |
| `aesCbcEncode(key, iv, input)` | 密钥、IV、明文 | `string` | AES-CBC 加密 |
| `aesCbcDecode(key, iv, input)` | 密钥、IV、密文 | `string` | AES-CBC 解密 |

## 最小片段

```javascript
console.log(Encrypt.md5('DeekeScript'));

let iv = Encrypt.generateIv();
let key = 'DeekeScript';
let encodeStr = Encrypt.aesCbcEncode(key, iv, 'hello');
let plain = Encrypt.aesCbcDecode(key, iv, encodeStr);
console.log(plain);
```

## 注意

- AES 加解密必须用同一对 `key` 和 `iv`。
- 这是运行时加解密 API。打包时 JS 源码加密见 [`code-encryption.md`](./code-encryption.md)，不要混用。
