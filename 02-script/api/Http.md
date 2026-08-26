# Http

HTTP：GET/POST、上传、下载、超时、流式 POST。POST 的 Content-Type 为 `application/json; charset=utf-8`。

## 可用上下文

- **page.js** 与 **tasks.js** 都能用。

## 方法

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| post | `post(url: string, json: object, headers?: object)` | 地址、JSON 参数、可选请求头 | `string \| null` | POST JSON |
| get | `get(url: string, headers: object)` | 地址、请求头 | `string \| null` | GET。d.ts 要求 headers；官方文档写可省略，建议传 `{}` |
| postFile | `postFile(url, files, params, httpCallback)` | 地址、文件列表、表单参数、`{ success, fail }` | `void` | 上传文件。回调里可读 `response.body().string()`、`response.code()` |
| download | `download(url: string, destPath: string, headers?: object)` | 下载地址、本地路径、可选请求头 | `string \| null` | 下载到 destPath |
| setConnectTimeout | `setConnectTimeout(seconds: number)` | 秒 | `void` | 连接超时，默认 10 秒 |
| setReadTimeout | `setReadTimeout(seconds: number)` | 秒 | `void` | 读超时，默认 30 秒 |
| setWriteTimeout | `setWriteTimeout(seconds: number)` | 秒 | `void` | 写超时，默认 30 秒 |
| setTimeout | `setTimeout(connectSeconds, readSeconds, writeSeconds)` | 连接/读/写秒数 | `void` | 分别设置 |
| setTimeout | `setTimeout(seconds: number)` | 秒 | `void` | 三类超时设成同一值 |
| postStream | `postStream(url, json, headers, onData, onError)` | 地址、JSON、请求头、逐行回调、错误回调 | `void` | 流式 POST（如 SSE），每行调用 `onData` |
| postStream | `postStream(url, json, onData, onError)` | 无请求头版本 | `void` | 同上 |

## 最小片段

```javascript
let res = Http.get('https://script.deeke.cn/api/userInfo', {});
console.log(res);
```

## 注意

- 返回值按字符串处理，需要对象时再 `JSON.parse`。先判断非 `null`。
- 下载路径可用 [`Files.getCachePath()`](Files.md) 等应用目录。
- 回调写成 `function`，不要用箭头函数。
- 索引见 [`INDEX.md`](INDEX.md)。
