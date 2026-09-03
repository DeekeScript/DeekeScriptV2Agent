# FloatWindow



**项目**悬浮球的展开菜单。`floatWindow.menus` 与 `FloatWindow` 只作用于点「运行」之后（以及打包 App）的那颗球。DeekeScript 开发器那颗球不读 `floatWindow` 配置。

**用户未特别要求悬浮窗菜单时，不要在工程里写 `floatWindow` / `menus`，也不要写对应的 `FloatWindow.on`。** 默认连点两次即可停任务，勿重复造 stop 菜单。

## 默认行为（未配 menus）

| | 开发器球 | 项目球（未写 `floatWindow.menus`） |
|--|---------|-----------------------------------|
| 停止任务 | 第一次变成关闭图标，**3 秒内**再点才停止 | 与开发器一致 |
| 任务运行中 | 悬浮球旋转 | 悬浮球旋转 |

配置了 `floatWindow.menus` 或调用了 `FloatWindow.setMenus` 后，点球展开扇形菜单，停止等操作在 `FloatWindow.on` 里写。完整对比见 [`floatWindow.md`](../../01-ui/capabilities/floatWindow.md#两种球不要混)。

**仅当用户明确要菜单时**：必读 [`01-ui/capabilities/floatWindow.md`](../../01-ui/capabilities/floatWindow.md) 与 [`03-recipes/float-window.md`](../../03-recipes/float-window.md)；**menus 与 `FloatWindow.on` 必须同一轮交付**。



**停止任务**：菜单里用 `FloatWindow.stopTask()`（停整项任务并恢复悬浮球）。与 `Engines.closeAll()` 的区别见 [`floatWindow.md`](../../01-ui/capabilities/floatWindow.md#关闭任务底层逻辑必读)。



d.ts 未声明 `FloatWindow`；显隐球用 [`FloatDialogs.setFloatWindowVisible`](FloatDialogs.md)。



## 可用上下文



- **tasks.js**（推荐绑 `on` / 跳过逻辑）

- **page.js**（可 `on` / `setMenus`，但任务行为应跟 `tasks/` 走）



JSON 配在 `deekeScript.json` 的 `floatWindow.menus`，最多展示 5 个。



## 方法



| 方法 | 说明 |

|------|------|

| `setMenus(menus)` | 运行时替换菜单 |

| `on(id, fn)` / `on({ ... })` | 绑点击（**必填**，否则点了无反应） |

| `update(id, patch)` | 改 label / icon / background / visible |

| `collapse()` | 收起菜单 |
| `stopTask()` | 从悬浮窗停止**整项项目任务**，并恢复悬浮球（停旋转、还原图标） |



## 最小片段（与 JSON 同轮出现在 tasks/*.js）



```javascript

FloatWindow.on({

  stop: function () {

    FloatWindow.stopTask();

  },

  hide: function () {

    FloatDialogs.setFloatWindowVisible(false);

  },

  skip: function () {

    skipped = true;

    FloatWindow.update('skip', { label: '已跳过', background: '#E8F5E9' });

  }

});

```



### stopTask 示例（菜单里停止）

```javascript
FloatWindow.on({
  stop: function () {
    FloatWindow.collapse();
    FloatWindow.stopTask();
    FloatDialogs.toast('任务已停止');
  }
});
```

## 注意



- 未开悬浮窗权限球不会出现 → [`Access.md`](Access.md)

- 索引见 [`INDEX.md`](INDEX.md)


