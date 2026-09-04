# Audio

音频播放。支持网络流、`file://`、`content://`、绝对路径、`project://` 项目相对路径，以及默认按项目根解析的相对路径。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 是 |
| `tasks/*.js` | 是 |

## 方法

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `load(source)` | `source {string}` | `boolean` | 载入，不自动播放 |
| `play()` | 无 | `boolean` | 播放已加载音频 |
| `play(source)` | `source {string}` | `boolean` | 先 load 再 play |
| `playAndRelease(source)` | `source {string}` | `boolean` | 播完自动释放，适合短提示音（d.ts 未列出） |
| `pause()` | 无 | `boolean` | 暂停 |
| `stop()` | 无 | `boolean` | 停止并回到开头 |
| `release()` | 无 | `void` | 释放资源；再播需重新 `load` |
| `seekTo(msec)` | `msec {number}` 毫秒 | `boolean` | 跳转到指定位置 |
| `setLooping(looping)` | `looping {boolean}` | `boolean` | 是否循环 |
| `setVolume(leftVolume, rightVolume)` | 左右声道 `0.0`～`1.0` | `boolean` | 设音量 |
| `isPlaying()` | 无 | `boolean` | 是否正在播放 |
| `isLoaded()` | 无 | `boolean` | 是否已加载 |
| `getDuration()` | 无 | `number` | 总时长毫秒，未加载返回 `-1` |
| `getCurrentPosition()` | 无 | `number` | 当前位置毫秒，未加载返回 `-1` |
| `getCurrentSource()` | 无 | `string` | 当前源路径 |
| `canPlayInBackground()` | 无 | `boolean` | 是否具备后台播放能力（查前台服务权限） |
| `hasForegroundServicePermission()` | 无 | `boolean` | 是否已声明前台服务权限（Android 9+ 后台播放建议用前台服务） |

## 最小片段

```javascript
if (Audio.play('project://assets/bg_music.mp3')) {
  Audio.setLooping(true);
  Audio.setVolume(0.5, 0.5);
  console.log('开始播放背景音乐');
}
```

## 注意

- 用完调用 `release()`。
- 后台播放查 `canPlayInBackground()` / `hasForegroundServicePermission()`。常驻任务见 [`Foreground.md`](./Foreground.md)。
- 路径：`https://`、`file://`、`content://`、`/sdcard/...`、`project://assets/a.mp3`。
