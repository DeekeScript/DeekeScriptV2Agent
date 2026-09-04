# extension

Rhino 可直接用 Java 类：`java.lang.*`、`JavaImporter`、`Packages`。用来补 JS 没有的能力。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 可用，慎用 |
| `tasks/*.js` | 是 |

## 用法

| 写法 | 说明 |
|------|------|
| `new java.lang.String(...)` | 直接 `java.` 包名 |
| `java.lang.Math.PI` | 静态字段 |
| `new java.util.Date()` | 构造 |
| `new java.io.File(path)` | 文件等 |
| `JavaImporter(java.lang.Thread, java.lang.Runnable)` | 导入后配合 `with` 使用短名 |
| `Packages.java.nio.file.Files` | 用 `Packages` 取类 |

d.ts：`declare function JavaImporter(...packages: any[]): any`；`declare var java: java`；`declare var Packages: Packages`。

## 最小片段

```javascript
let javaString = new java.lang.String('Java');
console.log(javaString);
console.log(java.lang.Math.PI);

var NioFiles = Packages.java.nio.file.Files;
var path = Packages.java.nio.file.Paths.get('example.txt');
console.log(NioFiles.exists(path));
```

`JavaImporter` 示例（谨慎使用）：

```javascript
let obj = {
  run: function () {
    console.log('线程');
  }
};
let javaImporterTest = JavaImporter(java.lang.Thread, java.lang.Runnable);
with (javaImporterTest) {
  new Thread(new Runnable(obj)).start();
}
```

## 注意

- 多线程优先 [`timer.md`](./timer.md) / [`Engines.md`](./Engines.md)，不要默认 `java.lang.Thread`。
- `JavaImporter` 的类名外层不要加引号。
- 不要用 Java 去实现界面。初始化放页面 / 任务脚本，见 [`no-hook.md`](./no-hook.md)。
- 文件读写优先 [`Files.md`](./Files.md)。
