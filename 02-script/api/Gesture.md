# Gesture

按屏幕坐标做点击、长按、滑动、多指手势，以及返回 / Home / 最近任务。需要无障碍。找得到节点时优先 [`UiObject.click`](UiObject.md)。

## 可用上下文

- **tasks.js**：主场景。
- **page.js**：能调用，页面不要靠手势驱动。

## 方法

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| click | `click(x: number, y: number)` | 屏幕坐标 | `boolean` | 点击。时长约 200–300ms；要控时长用 `press` |
| longClick | `longClick(x: number, y: number)` | 屏幕坐标 | `boolean` | 长按。时长约 600–800ms；要控时长用 `press` |
| press | `press(x: number, y: number, duration: number)` | 坐标与按压毫秒 | `boolean` | 按压一段时间（阻塞至结束） |
| pressQuick | `pressQuick(x, y, duration)` | 坐标与按压毫秒 | `boolean` | 派发后立刻返回，不等手势演完 |
| swipe | `swipe(x1, y1, x2, y2, duration)` | 起点、终点、滑动毫秒 | `boolean` | 直线滑动 |
| swipeHuman | `swipeHuman(sx, sy, ex, ey, duration)` | 起点、终点、滑动毫秒 | `boolean` | 带弧度的拟人手势滑动 |
| gesture | `gesture(duration, points)` | 整段毫秒；`points` 为 `[[x,y], ...]` | `boolean` | 单指路径手势 |
| gestures | `gestures(strokes)` 或 `gestures(stroke1, stroke2, ...)` | 多 stroke | `boolean` | 多指 / 组合手势 |
| back | `back()` | 无 | `boolean` | 系统返回键，弹出**整机 Activity 栈**（含 DeekeScript）。只用于仍在目标 App 内的 overlay；禁止循环调用 |
| home | `home()` | 无 | `boolean` | Home，回到桌面。调试时不要用，会把 DeekeScript 送走 |
| recents | `recents()` | 无 | `boolean` | 最近任务。调试时不要用 |

### gesture / gestures 参数

- `gesture(duration, points)`：`points` 为 `[[x, y], [x, y], ...]`，整段耗时 `duration` 毫秒。
- `gestures` 每个 stroke 二选一：
  - 数组：`[startTime, duration, [x1,y1], [x2,y2], ...]`
  - 对象：`{ startTime, duration, points: [[x,y], ...] }`
- `startTime` 相对本批手势开始的毫秒偏移。

## 最小片段

```javascript
Gesture.click(100, 200);
Gesture.pressQuick(100, 200, 50);
Gesture.swipeHuman(500, 1500, 500, 400, 400);

// 单指折线
Gesture.gesture(300, [[100, 200], [300, 400], [500, 200]]);

// 双指捏合（pinch）
let cx = Device.width() / 2, cy = Device.height() / 2;
Gesture.gestures([
  [0, 400, [cx - 200, cy], [cx - 40, cy]],
  [0, 400, [cx + 200, cy], [cx + 40, cy]]
]);

// 双指放大（zoom out → 手指外扩）
Gesture.gestures(
  { startTime: 0, duration: 400, points: [[cx - 40, cy], [cx - 200, cy]] },
  { startTime: 0, duration: 400, points: [[cx + 40, cy], [cx + 200, cy]] }
);
```

## 注意

- 坐标是像素。屏幕宽高用 [`Device.width`](Device.md) / `height()`。节点中心可用 `obj.bounds().centerX()` / `centerY()`。
- 点坐标前若可能点到右侧悬浮球，先 [`FloatDialogs.setFloatWindowClickable(false)`](FloatDialogs.md)，`System.sleep(300)` 后再点，点完改回 `true`。
- **`back()` 不是「回到目标 App」。** 栈上常有 DeekeScript。误入系统设置用 `App.launch(目标包名)`。硬规则见 [`keep-host-alive.md`](../pitfalls/keep-host-alive.md)。
- 索引见 [`INDEX.md`](INDEX.md)。
