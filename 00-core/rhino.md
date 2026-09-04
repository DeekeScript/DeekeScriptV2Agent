# Rhino 1.8

写任何 JS（`page.js`、`component.js`、`tasks/*.js`、`common/*.js`）时读这篇。引擎是 Rhino 1.8，三处脚本同一套语法。可以直接调 Java。`setTimeout` / `setInterval` / `console` / `Promise` 可用。箭头函数可用。不要用 `async/await`、可选链、空值合并、`import` / `export`。

## 能写

| 类别 | 写法 |
|------|------|
| 函数 | `function foo() {}`、箭头 `() => {}`；**对象方法优先简写** `onLoad(params) {}` / `open() {}`，不要 `open: function () {}` |
| 变量 | `var`、`let` |
| 模块 | `require('../common/hello.js')`（优先相对路径）、`module.exports = { ... }` |
| 控制流 | `if` / `for` / `while` / `switch` / `try/catch` |
| 逻辑 | `===`、`\|\|`、`&&`、三元 `a ? b : c` |
| 定时 | `setTimeout`、`setInterval`、`clearTimeout`、`clearInterval` |
| 调试 | `console.log` / `warn` / `error` |
| 异步 | `Promise`（不要配 `async/await`） |
| Java | 直接调 Java 对象；`Packages` / `JavaImporter` |
| JSON | `JSON.parse`、`JSON.stringify` |
| 全局 API | `Http`、`Storage`、`Engines`、`System`、`Dialogs`、`Access` 等（见 [上下文边界](./context-split.md)） |

```javascript
// common/hello.js
module.exports = {
  greet(name) {
    return '你好，' + (name || '用户');
  }
};
```

```javascript
// pages/home/page.js
let hello = require('../../common/hello.js');

Page({
  data: {
    text: ''
  },
  onLoad() {
    var that = this;
    this.setData({ text: hello.greet('运营A') });
    setTimeout(function () {
      console.log(that.data.text);
    }, 500);
  }
});
```

## 不能写

| 语法 | 替代 |
|------|------|
| `async` / `await` | `Promise` + `.then`，或同步 `Http.get` / `System.sleep` |
| 可选链 `e?.detail` | `e && e.detail` |
| 空值合并 `a ?? b` | `a != null ? a : b` 或 `a \|\| b`（注意 `0` / `''`） |
| `import` / `export` | `require` / `module.exports` |
| 拼磁盘绝对路径的 `require` | 相对当前文件或相对项目根 |

```javascript
// 错误
onPicked(e) {
  const keyword = e?.detail?.keyword ?? '';
}

// 正确
onPicked(e) {
  var d = e && e.detail ? e.detail : {};
  var keyword = d.keyword ? d.keyword : '';
  this.setData({ picked: keyword || '未选' });
}
```

## 推荐写法

| 场景 | 推荐 |
|------|------|
| 业务 / 模块能力（`common/`、`tasks/`） | **必须**对象 + 方法简写，禁止顶层业务 `function`。见 [`code-org.md`](../02-script/code-org.md) |
| `Page` / `Component` / `module.exports` / `FloatWindow.on` | **方法简写** `onLoad() {}`、`greet(name) {}`；不要 `onLoad: function () {}` |
| 需要 `this` 的页面方法 | 用简写或普通 `function`；**不要** `onLoad: () => {}`（箭头会绑错 `this`） |
| API 回调（`setTimeout`、`Dialogs`、`.then` 等） | `function` 或 `=>` 均可 |
| 回调里保存 `this` | `var that = this;` 再进 `setTimeout` / `Dialogs.confirm`（或箭头回调直接用外层 `this`） |
| 空判断 | `if (!node) { return; }` |
| 字符串拼接 | `'已保存：' + name`（少用模板字符串，避免混入不受支持的写法） |
| 延时 | 页面短延时用 `setTimeout`；任务里等待用 `System.sleep` |
| 导出 | 一个 `module.exports` 对象 |

`Page({})` / `Component({})` 里未声明的生命周期不会调用。`this` 就是传入的那个对象。
