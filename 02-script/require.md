# require

`page.js` 与 `tasks/*.js` 都能 `require`。把重复逻辑放到 `common/*.js`，用 `module.exports` 导出。不要拼磁盘绝对路径：开发时根目录是工程目录，打包后是应用内部。

## 路径规则

| 写法 | 基准 | 何时用 |
|------|------|--------|
| **`./`、`../`（优先）** | 当前这个 JS 文件所在目录 | **生成代码默认写法**。同目录、上一级、`common/` 等都用相对路径 |
| 不以 `./`、`../` 开头 | 项目根目录 | 仅在相对路径不清晰、或跨很深目录时作备选 |

**AI / 生成规则：优先 `./`、`../`，不要默认写项目根写法。**

| 当前文件 | 引入 | 推荐 |
|----------|------|------|
| `tasks/xxx.js` | `common/permission.js` | `require('../common/permission.js')` |
| `pages/home/page.js` | `common/permission.js` | `require('../../common/permission.js')` |
| `pages/home/page.js` | 同目录 `helper.js` | `require('./helper.js')` |
| `tasks/a.js` | 同目录 `b.js` | `require('./b.js')` |

不推荐（能相对就别这样写）：`require('common/permission.js')`。

`Engines.executeScript` **仍相对项目根**（如 `'tasks/xxx.js'`），与 `require` 不同，见 [`api/Engines.md`](api/Engines.md)。

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
let hello = require('../../common/hello.js');
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
let hello = require('../common/hello.js');
System.toast(hello.text);
```

## 注意

- 必须带 `.js` 后缀，与工程里真实文件名一致。
- 导出用 `module.exports`。不要依赖未在页面示例中出现的其它导出写法。
- 被 `require` 的文件里同样可以使用 `Storage`、`UiSelector` 等全局 API，上下文仍是调用方（页面或任务）。
- 禁止磁盘绝对路径（如 `C:/...`、`/storage/...`）。
