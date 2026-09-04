# 工程目录

新建工程、移动文件、注册页面或组件时读这篇。根目录放入口 `deekeScript.json`（硬规则见 [`constraints.md`](./constraints.md)）。每个页面是一个文件夹，内含成对的 `page.json` + `page.js`；自定义组件同理，且 JSON 必须 `"component": true`。目录命名可与展厅一致（如 `pages/floatWindow`）；**不要**把展厅工程当生成模板，见 [`demo-gallery.md`](./demo-gallery.md)。

## 完整目录树

只跑脚本时，有入口文件和 `tasks/` 即可。下面是带界面时的完整形态：

```
your-project/
  deekeScript.json
  pages/
    home/
      page.json
      page.js
      helper.js
    task/
      page.json
      page.js
  components/
    choose/
      component.json
      component.js
  common/
    permission.js
    hello.js
  tasks/
    sample.js
  img/
    xhs.svg
    home.svg
  html/
    help.html
```

| 路径 | 必须 | 作用 |
|------|------|------|
| `deekeScript.json` | 是 | 识别工程；必须含 `icon`（文件相对项目根存在）；做界面时写首页、底栏、全局窗口、组件注册 |
| `img/` | 是（至少 `icon` 指向的那张） | 工程图标、底栏 `icon`、组件 `src`。路径相对项目根 |
| `tasks/*.js` | 自动化时是 | 无障碍任务。用 `Engines.executeScript`，或「仅当前文件执行」 |
| `pages/<id>/page.json` | 做界面时是 | 这一页的结构 |
| `pages/<id>/page.js` | 做界面时是 | `Page({})`：数据、生命周期、点击 |
| `components/<id>/component.json` | 用自定义组件时是 | 必须含 `"component": true` |
| `components/<id>/component.js` | 用自定义组件时是 | `Component({})` |
| `common/*.js` | 否 | 公共模块；`require` **优先相对路径**。面向 App 的自动化按操作对象拆分，见 [`code-org.md`](../02-script/code-org.md) |
| `html/` | 否 | 本地 HTML，给 `webview` 的 `src` 用 |

`homePage` 指向的目录（如 `pages/home`）**不必**再写入入口的 `pages` 数组。其它要跳转的页必须成对存在，并在 `pages` 里注册（或跳转时直接写文件夹路径）。

## 页面成对

每个页面目录必须同时有：

| 文件 | 说明 |
|------|------|
| `page.json` | 结构。默认加载同目录 `page.js` |
| `page.js` | `Page({})`。不能当任务脚本执行 |

入口 `pages` 数组一项：

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | String | 是 | 别名，用于跳转和底栏 |
| file | String | 是 | 页面目录，如 `pages/task`，也可写成 `pages/task/page.json` |
| title | String | 否 | 备用标题；`page.json` 的 `title` 优先 |

```json
{
  "homePage": "pages/home",
  "pages": [
    { "id": "task", "file": "pages/task", "title": "任务设置" }
  ]
}
```

## 组件注册

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | String | 是 | 组件名，页面里写 `"type": "choose"` |
| file | String | 是 | 组件目录，如 `components/choose` |

不写 `components` 数组时，引擎按 `components/<id>` 找目录。JSON 没有 `"component": true` 不能当组件加载。成环引用会拒绝。见 [自定义组件](../01-ui/component-custom.md)。

```json
{
  "components": [
    { "id": "choose", "file": "components/choose" }
  ]
}
```

## 命名约定

| 对象 | 约定 |
|------|------|
| 页面目录 | `pages/<id>/`，全小写或驼峰（如 `pages/floatWindow`、`pages/tabBar`） |
| 页面文件 | 固定名 `page.json`、`page.js`，不要改成别的文件名除非用 `js` 字段覆盖 |
| 组件目录 | `components/<id>/`，文件固定为 `component.json`、`component.js` |
| 任务脚本 | `tasks/<name>.js`，路径相对项目根，如 `tasks/sample.js` |
| 公共模块 | `common/<name>.js`，导出用 `module.exports` |
| 图片 | `img/<name>.svg` 或 `.png`，配置里写 `img/home.svg` |
| require | `./`、`../` 相对当前 JS；否则相对项目根。不要拼磁盘绝对路径 |
| 入口 id | 与跳转 `page`、底栏 `page` 对齐：可写 `task` 或 `pages/task` |

入口字段与最小配置见 [入口 JSON](../01-ui/entry-json.md)。硬性禁止见 [约束](./constraints.md)。
