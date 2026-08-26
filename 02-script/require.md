# require

`page.js` 与 `tasks/*.js` 都能 `require`。把重复逻辑放到 `common/*.js`，用 `module.exports` 导出。不要拼磁盘绝对路径：开发时根目录是工程目录，打包后是应用内部。

## 路径规则

| 写法 | 基准 | 示例 |
|------|------|------|
| 以 `./` 或 `../` 开头 | 当前这个 JS 文件所在目录 | `require('./helper.js')`、`require('../../common/line.js')` |
| 其它 | 项目根目录 | `require('common/hello.js')`、`require('tasks/xxx.js')` |

`Engines.executeScript` 的路径规则相同，见 [`api/Engines.md`](api/Engines.md)。

## `module.exports`

```javascript
// common/hello.js
module.exports = {
  text: '你好'
};
```

页面：

```javascript
// pages/home/helper.js
module.exports = {
  greet: function (name) {
    return '你好，' + name;
  }
};
```

```javascript
// pages/home/page.js
let hello = require('common/hello.js');
let helper = require('./helper.js');

Page({
  data: {
    hint: hello.text,
    greet: helper.greet('体验者')
  }
});
```

任务脚本：

```javascript
// tasks/xxx.js
let hello = require('common/hello.js');
System.toast(hello.text);
```

同目录的 `pages/home/helper.js` 对 `page.js` 用 `require('./helper.js')`。`tasks/xxx.js` 引用公共模块用项目根写法 `require('common/hello.js')`，或 `require('../common/hello.js')`。

## 注意

- 必须带 `.js` 后缀，与工程里真实文件名一致。
- 导出用 `module.exports`。不要依赖未在 V2 页面示例中出现的其它导出写法。
- 被 `require` 的文件里同样可以使用 `Storage`、`UiSelector` 等全局 API，上下文仍是调用方（页面或任务）。
