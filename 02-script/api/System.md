# System

休眠、时间、前台 Activity/包名、剪贴板、toast、音量/振动、shell、等待界面、退出引擎、无障碍模式、常亮等。

## 可用上下文

- **page.js** 与 **tasks.js** 都能用。`currentActivity` / `currentPackage` / `waitFor*` 依赖无障碍，放任务脚本。

## 方法

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| sleep | `sleep(milliSecond: number)` | 毫秒 | `void` | 休眠 |
| preciseSleep | `preciseSleep(milliSecond: number)` | 毫秒 | `void` | 更精确的休眠（WakeLock + 循环检查）。更耗电；不要求精确用 `sleep` |
| gc | `gc()` | 无 | `void` | 可用 |
| time | `time()` | 无 | `string` | 当前系统时间，如 `2024-03-07 12:12:12` |
| currentActivity | `currentActivity()` | 无 | `string` | 最近监测到的 Activity。依赖无障碍，未开则抛错并提示 |
| currentPackage | `currentPackage()` | 无 | `string` | 最近监测到的前台包名。依赖无障碍。详见下方说明 |
| setClip | `setClip(text: string)` | 文本 | `void` | 写入剪贴板 |
| getClip | `getClip()` | 无 | `string` | 剪贴板内容；失败可为 null |
| toast | `toast(text: string)` | 文案 | `void` | 短 toast，异步，不等待消失。后台请用 `FloatDialogs.toast` |
| toastLong | `toastLong(text: string)` | 文案 | `void` | 较长 toast。后台请用 `FloatDialogs.toastLong` |
| waitForActivity | `waitForActivity(activity, period, timeout)` | Activity 名；检查间隔 ms；总超时 ms | `boolean` | 等到出现为 true，超时 false |
| waitForPackage | `waitForPackage(packageName, period, timeout)` | 包名；间隔；总超时 | `boolean` | 等到出现为 true，超时 false |
| exit | `exit()` | 无 | `void` | 关闭脚本引擎 |
| cleanUp | `cleanUp()` | 无 | `void` | 可用 |
| setTimeWindowShow | `setTimeWindowShow(show: boolean)` | 是否显示 | `void` | 运行时间悬浮窗显隐 |
| setAccessibilityMode | `setAccessibilityMode(mode: string)` | `'fast'` 快速；其它为正常 | `void` | 切换无障碍扫描。快速会过滤非重要节点；按 id/text 查找不受影响。立即生效 |
| setKeepScreenOn | `setKeepScreenOn(keepOn: boolean)` | 是否常亮 | `void` | 通过右侧悬浮窗实现。无悬浮窗权限或隐藏了右侧悬浮窗则不生效 |
| getLocaleInfo | `getLocaleInfo()` | 无 | `{ language, country, tag }` | 系统语言区域。需 Android 7.0+ |
| vibrate | `vibrate(ms)` / `vibrate(pattern, repeat)` | 毫秒；或模式数组与 repeat（-1 不重复） | `void` | 振动 |
| cancelVibrate | `cancelVibrate()` | 无 | `void` | 取消振动 |
| getVolume | `getVolume(stream?)` | music/ring/notification/alarm/system/voice，默认 music | `number` | 当前音量 |
| getMaxVolume | `getMaxVolume(stream?)` | 同上 | `number` | 最大音量 |
| setVolume | `setVolume(volume)` / `setVolume(stream, volume)` | 音量或流+音量 | `boolean` | 设置音量 |
| getRingerMode | `getRingerMode()` | 无 | `number` | 0 静音，1 振动，2 正常 |
| setRingerMode | `setRingerMode(mode)` | 0/1/2 | `boolean` | 部分机型受勿扰限制可能失败 |
| shell | `shell(cmd, root?)` | 命令；root 默认 false | `{ code, result, error }` | 执行 shell，超时 30s |

d.ts 还列出与 locale 返回字段同名的属性 `language` / `country` / `tag`。请以 `getLocaleInfo()` 为准。

### currentPackage

返回最近监测到的前台应用包名。与 [`App.currentPackageName()`](App.md) 不同：后者是**当前 DeekeScript 工程 App** 的包名，不是屏幕上其它 App。

从本项目点「运行」或 `permission.runScript` 启动 `tasks/*.js` 后，即使用户屏幕上是第三方 App（如抖音推荐页），`currentPackage()` **也可能仍返回 DeekeScript 包名**（如 `com.android.deeke.script.pro`）。因此：

- **不要**用 `currentPackage() !== TARGET_PKG` 判断是否在目标 App，也不要据此弹「请切回…」并 `continue`——会误判且可能死循环。
- **应**用 [`UiSelector`](UiSelector.md) 检测目标 App 界面特征节点，例如 `UiSelector().id('com.example:id/desc').exists()`。
- **前台窗口是谁**（系统设置 vs 目标 App）看 snapshot 根节点 `packageName` 或 `node.getPackageName()`，不要用 `currentPackage()`。误入设置时的恢复见 [`keep-host-alive.md`](../pitfalls/keep-host-alive.md)。

## 最小片段

```javascript
console.log('立即输出');
System.sleep(1000);
console.log('1秒钟后输出');
```

## 注意

- 任务循环里用 `System.sleep` 让出时间，不要空转。
- 停止整段脚本：`FloatWindow.stopTask()`（手动/非脚本线程）或任务内 `Engines.closeAll()`（自动）；`System.exit()` 关当前引擎。见 [`FloatWindow.md`](FloatWindow.md)。
- 索引见 [`INDEX.md`](INDEX.md)。
