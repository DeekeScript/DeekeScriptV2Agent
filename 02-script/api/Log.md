# Log

把日志写到文件，**不会**打印到控制台。控制台输出用 [`console`](console.md)。

## 可用上下文

- **page.js** 与 **tasks.js** 都能用。长时间任务建议 `setFile` 后再 `Log.log`。

## 方法

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| setFile | `setFile(filename: string)` | 文件名 | `boolean` | 设置输出文件 |
| log | `log(...obj: object)` | 任意若干参数 | `void` | 写入文件，类似 `console.log` 但不打控制台 |

未打包时文件在 `/data/data/com.android.deeke.script/files/log/` 下；打包后在 `/data/data/<你的包名>/files/log/` 下。例如 `Log.setFile("myfile.log")` → `.../files/log/myfile.log`。

## 最小片段

```javascript
Log.setFile('myfile.log');
Log.log(132, 'sdfds', [12, 3]);
```

## 注意

- 先 `setFile` 再 `log`，否则没有明确文件目标。
- 索引见 [`INDEX.md`](INDEX.md)。
