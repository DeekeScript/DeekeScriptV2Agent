# DeekeScript

框架杂项：版本、读项目文件、一次性取出当前界面全部无障碍节点原始数据。单点点击/输入请用 [`UiSelector`](UiSelector.md) / [`UiObject`](UiObject.md)。批量处理节点时，本 API 一次取全树，性能更好。

## 可用上下文

- **tasks.js**：主场景（批量节点）。
- **page.js**：`version` / `readFile` / `getProjectRoot` 可用；不要在页面里扫节点树。

## 方法

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| version | `version()` | 无 | `number` | 框架版本号 |
| readFile | `readFile(path: string)` | 相对 **JS 项目根** 的路径 | `string \| null` | 读项目内文件；失败 null |
| getProjectRoot | `getProjectRoot()` | 无 | `string` | 当前 JS 项目根的绝对路径 |
| getNodeFields | `getNodeFields()` | 无 | `string[]` | 可用于 `getAllAccessibilityNodeInfo` 的字段名 |
| getAllAccessibilityNodeInfo | `getAllAccessibilityNodeInfo(bool, fields)` | `true` 复杂模式（含全部字段语义）；`false` 简单模式。`fields` 要返回的字段名 | `{ nodes: DeekeNodeInfo[] } \| null` | 一次取当前界面节点。无障碍未开返回 null |

常用节点字段（官方）：`key`、`viewIdResourceName`、`text`、`contentDescription`、`className`、`childCount`、`packageName`、`hintText`、`inputType`、`drawingOrder`、`depth`、`maxTextLength`、`isPassword`、`boundsInScreen`、`boundsInParent`、各类 `is*`、`children`。

`DeekeBounds`：`left`、`top`、`width`、`height`。

## 最小片段

```javascript
console.log(DeekeScript.version());
```

## 注意

- `getAllAccessibilityNodeInfo` 需要无障碍。只要部分字段时传入短 `fields` 数组。
- `readFile` 相对项目根，与 [`Files.read`](Files.md)（绝对/私有目录）不是同一套路径。
- 索引见 [`INDEX.md`](INDEX.md)。
