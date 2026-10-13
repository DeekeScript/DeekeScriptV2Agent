# Share

系统分享面板（`Intent.createChooser` + `FileProvider`）。分享文本或文件时可选微信 / QQ 等。

**不要**自己拼 `Intent.ACTION_SEND` 再 `startActivity`：会跳进系统默认 App（如小红书），看不到选择面板。必须走 `Share.*`。

## 可用上下文

- **page.js** 与 **tasks.js** 都能用。

## 方法

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| shareText | `shareText(text, title?)` | 文本；可选标题 | `{ ok, message, mode }` | 分享纯文本 |
| shareFile | `shareFile(path, title?, mimeType?)` | 绝对路径；标题；MIME | `{ ok, message, mode, path?, uri?, mimeType? }` | 单文件（FileProvider） |
| shareFiles | `shareFiles(paths, title?, mimeType?)` | 路径数组；标题；MIME | `{ ok, message, mode, count?, mimeType? }` | 多文件 |
| share | `share(options)` | `{ text\|path\|paths, title?, mimeType?, subject? }` | 同上结构 | 综合入口 |

文件路径支持应用私有 `files` / `cache` / `externalFiles` 等（底座 FileProvider 已配置）。

## 最小片段

```javascript
Share.shareText('hello', '分享');

let p = Files.getFilesPath() + '/logs/today.txt';
let r = Share.shareFile(p, '诊断日志', 'text/plain');
if (!r.ok) {
  console.log(r.message);
}

Share.share({ path: p, title: '日志', mimeType: 'text/plain' });
Share.share({ paths: [p1, p2], title: '多个文件' });
```

## 注意

- 不要对 `Share` 使用 `typeof`；直接调用，用返回的 `ok` / `message` 判断成败。
- 真机示例：底座 **示例 → 接口 → 分享 Share**；亦可对照 `deekeScript-v2-demo` 的 `pages/apiShare`。
- 相关：[`Files`](Files.md)、[`Intent`](Intent.md)、索引 [`INDEX.md`](INDEX.md)。
