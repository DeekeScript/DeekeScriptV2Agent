# Gesture

按屏幕坐标做点击、长按、滑动，以及返回 / Home / 最近任务。需要无障碍。找得到节点时优先 [`UiObject.click`](UiObject.md)。

## 可用上下文

- **tasks.js**：主场景。
- **page.js**：能调用，页面不要靠手势驱动。

## 方法

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| click | `click(x: number, y: number)` | 屏幕坐标 | `boolean` | 点击。时长约 200–300ms；要控时长用 `press` |
| longClick | `longClick(x: number, y: number)` | 屏幕坐标 | `boolean` | 长按。时长约 600–800ms；要控时长用 `press` |
| press | `press(x: number, y: number, duration: number)` | 坐标与按压毫秒 | `boolean` | 按压一段时间 |
| swipe | `swipe(x1, y1, x2, y2, duration)` | 起点、终点、滑动毫秒 | `boolean` | 滑动手势 |
| back | `back()` | 无 | `boolean` | 返回键 |
| home | `home()` | 无 | `boolean` | Home，回到桌面 |
| recents | `recents()` | 无 | `boolean` | 最近任务 |

## 最小片段

```javascript
Gesture.click(100, 200);
```

## 注意

- 坐标是像素。屏幕宽高用 [`Device.width`](Device.md) / `height()`。节点中心可用 `obj.bounds().centerX()` / `centerY()`。
- 点坐标前若可能点到右侧悬浮球，先 [`FloatDialogs.setFloatWindowClickable(false)`](FloatDialogs.md)，`System.sleep(300)` 后再点，点完改回 `true`。
- 索引见 [`INDEX.md`](INDEX.md)。
