# System

休眠、时间、前台 Activity/包名、剪贴板、toast、等待界面、退出引擎、无障碍模式、常亮等。

## 可用上下文

- **page.js** 与 **tasks.js** 都能用。`currentActivity` / `currentPackage` / `waitFor*` 依赖无障碍，放任务脚本。

## 方法

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| sleep | `sleep(milliSecond: number)` | 毫秒 | `void` | 休眠 |
| preciseSleep | `preciseSleep(milliSecond: number)` | 毫秒 | `void` | 更精确的休眠（WakeLock + 循环检查）。更耗电；不要求精确用 `sleep` |
| gc | `gc()` | 无 | `void` | d.ts 有此方法；官方文档未单独说明 |
| time | `time()` | 无 | `string` | 当前系统时间，如 `2024-03-07 12:12:12` |
| currentActivity | `currentActivity()` | 无 | `string` | 最近监测到的 Activity。依赖无障碍，未开则抛错并提示 |
| currentPackage | `currentPackage()` | 无 | `string` | 最近监测到的前台包名。依赖无障碍 |
| setClip | `setClip(text: string)` | 文本 | `void` | 写入剪贴板 |
| getClip | `getClip()` | 无 | `string` | 剪贴板内容。官方说明失败可为 null |
| toast | `toast(text: string)` | 文案 | `void` | 短 toast，异步，不等待消失。后台请用 `FloatDialogs.toast` |
| toastLong | `toastLong(text: string)` | 文案 | `void` | 较长 toast。后台请用 `FloatDialogs.toastLong` |
| waitForActivity | `waitForActivity(activity, period, timeout)` | Activity 名；检查间隔 ms；总超时 ms | `boolean` | 等到出现为 true，超时 false |
| waitForPackage | `waitForPackage(packageName, period, timeout)` | 包名；间隔；总超时 | `boolean` | 等到出现为 true，超时 false |
| exit | `exit()` | 无 | `void` | 关闭脚本引擎 |
| cleanUp | `cleanUp()` | 无 | `void` | d.ts 有此方法；官方文档未单独说明 |
| AiSpeechToken | `AiSpeechToken(key: string, secret: string)` | key、secret | `string` | 远程 AI 话术 token（返回 body 字符串，需自行解析） |
| generateWindowElements | `generateWindowElements()` | 无 | `void` | 把当前界面节点记入日志，便于排错 |
| getDataFrom | `getDataFrom(key, dataForm, content)` | 配置 key、数据来源类型、内容类型 | `string \| null` | 取 dataForm 类型表单数据 |
| setTimeWindowShow | `setTimeWindowShow(show: boolean)` | 是否显示 | `void` | 运行时间悬浮窗显隐 |
| setAccessibilityMode | `setAccessibilityMode(mode: string)` | `'fast'` 快速；其它为正常 | `void` | 切换无障碍扫描。快速会过滤非重要节点；按 id/text 查找不受影响。立即生效 |
| setKeepScreenOn | `setKeepScreenOn(keepOn: boolean)` | 是否常亮 | `void` | 通过右侧悬浮窗实现。无悬浮窗权限或隐藏了右侧悬浮窗则不生效 |
| getLocaleInfo | `getLocaleInfo()` | 无 | `{ language, country, tag }` | 系统语言区域。需 Android 7.0+ |

d.ts 还列出与 locale 返回字段同名的属性 `language` / `country` / `tag`。请以 `getLocaleInfo()` 为准。

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
