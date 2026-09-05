# 表单 `name` 唯一（页内必守，Storage 防跨页撞键）

`name` 不是「字段标签」，而是绑到 `Page.data` 的键。同一键上的所有控件共享一份值。这与组件 `type` 无关：`switch` / `input` / `textarea` / `slider` / `checkbox` / `range` 的 `start.name`/`end.name` 都一样。

权威说明也写在 [`data-binding.md`](../data-binding.md)。Storage 键见 [`Storage.md`](../../02-script/api/Storage.md)、[`ui-and-task.md`](../../02-script/ui-and-task.md)。

## 硬规则

1. **同一页面内 `name` 必须唯一。** 含：正文、弹层、`list`/`grid` 模板里的控件（模板每渲染一行都会带上这个 `name`）、`range` 的左右两个 `name`。重复则双向绑定到同一 `data` 字段，会联动或互相覆盖。
   - **列表里的表单：可以不写 `name`。** switch / input / checkbox / radio / slider 等的 `onChange` 都带 `e.value` / `e.item` / `e.index`。Switch 未写 `value` 时默认读 `item.enabled`。若仍写静态 `"name": "enabled"`，引擎会自动变成 `enabled#0`、`enabled#1`。
   - 列表里若仍要 `name` 绑 `data`：静态名会自动加 `#下标`；或写成 `"{{item.id}}"` 这种每行唯一。不要指望多行共用同一个 `data.enabled`。
2. **默认 `Storage` 是整应用一份**，不是「一页一份」。不同页面可以都有 `name: "keyword"`（页内 `data` 不串），但若都 `Storage.put('keyword', …)` 或都 `Storage.put('dylc.keyword', …)`，后写的会盖掉先写的。保存时**禁止**用裸 `name` 当 Storage 键；必须 `项目前缀.模块或页面.字段`。

## 页内重复（错误）

```json
{ "type": "input", "name": "keyword", "label": "搜索词" },
{ "type": "textarea", "name": "keyword", "label": "备注" }
```

两个框写的是同一个 `data.keyword`。

列表里每行都 `"name": "enabled"` 同理：所有开关绑 `data.enabled`，点一个其它跟着动。

## 页内正确

页面根表单：每个控件不同 `name`。

```json
{ "type": "input", "name": "keyword", "label": "搜索词" },
{ "type": "textarea", "name": "remark", "label": "备注" }
```

列表行开关可以不写 `name`，用 `e.item` / `e.index` 保存。页面根表单仍须每控件不同 `name`。

## Storage 跨页撞键（错误）

设置页和另一页都有 `name: "keyword"`，两边都：

```javascript
Storage.put('keyword', this.data.keyword);
// 或
Storage.put('dylc.keyword', this.data.keyword);
```

默认库全局共享，两页在抢同一把钥匙。

## Storage 正确

```javascript
Storage.put('dylc.settings.keyword', this.data.keyword);
Storage.put('dylc.search.keyword', this.data.keyword);
```

任务脚本用**同一套带前缀的键**去 `get`。不要 `Storage.put(name, value)` 把控件 `name` 直接当 key。

## 自检

- [ ] 打开任意 `page.json`，所有 `name`（含 list 模板、range 两端）不重复
- [ ] `Storage.put*` 的 key 带项目前缀；多页同名字段再带页面/模块名
