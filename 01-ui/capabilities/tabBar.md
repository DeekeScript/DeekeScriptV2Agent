# 底部菜单

配置或运行时改底栏时读这篇。底栏不是 body 里的组件。写在入口 `bottomMenus`，颜色写在 `window.tabBar`。页面里用 `this.setTabBar` 创建/恢复整栏，用 `setTabBarItem` / `setTabBarStyle` 改运行时状态。切 Tab 用 `switchTab`，不要 `navigate`。改底栏是全局的，离开独立页时要恢复。

## 配置

不配或空数组则没有底栏。字段见 [入口 JSON](../entry-json.md)。页内选项卡是另一个组件（`type: tabs`），不是底栏。

```json
{
  "window": {
    "tabBar": {
      "color": "#6F7978",
      "selectedColor": "#006A65",
      "background": "#FFFFFF",
      "borderColor": "#EEEEEE"
    }
  },
  "bottomMenus": [
    { "title": "首页", "icon": "img/home.svg", "page": "pages/home" },
    { "title": "组件", "icon": "img/apps.svg", "page": "pages/components", "badge": 3 },
    { "title": "能力", "icon": "img/setting.svg", "page": "pages/ability" }
  ]
}
```

## setTabBar

二级页默认没有底栏。`this.setTabBar({ items })` 在当前页创建一栏；`this.setTabBar()` 写回入口 `bottomMenus`。用 `page`（文件夹或 id）或 `index`（从 0 起）定位某一项。

| 参数 | 说明 |
|------|------|
| items | 菜单数组，字段与入口 `bottomMenus` 相同。不传则恢复默认 |
| 其余 | 与 `setTabBarStyle` 相同，创建时一并生效 |

```javascript
this.setTabBar({
  items: [
    { title: '首页', icon: 'img/home.svg', page: 'pages/home' },
    { title: '组件', icon: 'img/apps.svg', page: 'pages/components', badge: 3 }
  ]
});
this.setTabBar();
```

## setTabBarItem

| 参数 | 说明 |
|------|------|
| page / index | 改哪一项。`page` 可写 `pages/stats` 或 `stats` |
| badge | 角标数字或短文案。`0`、`''` 表示去掉 |
| hidden | `true` 隐藏这一项，`false` 再显示 |
| title | 改文字 |
| icon / selectedIcon | 改图标路径 |

颜色是整栏一起改的，不能只改某一项的图标色。某一项的文字用 `title`。`setTabBarStyle` 只覆盖传入的字段：改文字色不会动图标色，改背景也不会把颜色改回去。

```javascript
this.setTabBarItem({ page: 'pages/components', badge: 9 });
this.setTabBarItem({ page: 'pages/components', title: '控件' });
this.setTabBarItem({ page: 'pages/components', hidden: true });
```

## setTabBarStyle

只覆盖传入的字段。改 `color` / `selectedColor` 只动文字，图标保持入口原色；要改图标必须传 `iconColor` / `selectedIconColor`。

| 参数 | 说明 |
|------|------|
| color | 未选中文字色。只改这一项时，图标保持原色 |
| selectedColor | 选中文字色。只改这一项时，图标保持原色 |
| iconColor | 未选中图标色。入口未写时初始跟 `color` |
| selectedIconColor | 选中图标色。入口未写时初始跟 `selectedColor` |
| background | 底栏背景 |
| borderColor | 顶部分割线 |
| fontSize | 文字大小（sp） |
| hidden | `true` 隐藏整栏 |

```javascript
this.setTabBarStyle({ color: '#C2410C', selectedColor: '#EA580C' });
this.setTabBarStyle({ iconColor: '#C2410C', selectedIconColor: '#EA580C' });
this.setTabBarStyle({ background: '#1A1A1A', borderColor: '#333333' });
this.setTabBarStyle({ hidden: true });
```

## 离开页恢复

进入独立页时可 `setTabBar({ items })` 创建底栏，离开时 `this.setTabBar()` 写回入口配置。

```javascript
Page({
  onShow: function () {
    this.setTabBar({
      items: [
        { title: '首页', icon: 'img/home.svg', page: 'pages/home' },
        { title: '组件', icon: 'img/apps.svg', page: 'pages/components', badge: 3 },
        { title: '能力', icon: 'img/setting.svg', page: 'pages/ability' }
      ]
    });
  },
  onHide: function () {
    this.setTabBar();
  },
  onUnload: function () {
    this.setTabBar();
  }
});
```
