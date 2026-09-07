# ScreenRecord

屏幕录制，输出 mp4。与 `Images.capture()` 共用录屏权限。录屏过程中仍可截图/找图，建议同时开启无障碍。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 是 |
| `tasks/*.js` | 是 |

## 前置权限

```javascript
if (!Access.isMediaProjectionEnable()) {
  Dialogs.confirm('提示', '请开启屏幕录制权限', function (result) {
    Access.openMediaProjectionSetting();
    System.exit();
  });
}

// 录屏过程中还要 capture/找图：建议开无障碍
if (!Access.isAccessibilityServiceEnabled()) {
  Access.openAccessibilityServiceSetting();
  System.exit();
}
```

`withAudio: true` 时还需麦克风权限，用 `hasRecordAudioPermission()` 检查。

## 方法

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `start()` | 无 | `boolean` | 开始录屏，输出到缓存目录 |
| `start(outputPath)` | `outputPath {string}` | `boolean` | 指定输出 mp4 路径 |
| `start(outputPath, bitRate)` | 路径；码率 bps，`<=0` 默认约 6Mbps | `boolean` | |
| `start(outputPath, bitRate, frameRate)` | 再加帧率，`<=0` 默认 30 | `boolean` | |
| `start(outputPath, bitRate, frameRate, withAudio)` | `withAudio {boolean}` 是否录麦克风 | `boolean` | |
| `stop()` | 无 | `string` / `null` | 停止并返回文件路径；过短可能失败 |
| `isRecording()` | 无 | `boolean` | 是否正在录屏 |
| `getOutputPath()` | 无 | `string` | 当前或最近一次输出路径 |
| `hasRecordAudioPermission()` | 无 | `boolean` | 是否有麦克风权限 |

路径：绝对路径、`project://`、相对项目根；省略则写缓存目录 `screen_时间戳.mp4`。

## 最小片段

```javascript
if (!Access.isMediaProjectionEnable()) {
  Access.openMediaProjectionSetting();
  System.exit();
}

if (!ScreenRecord.start('/sdcard/Movies/demo.mp4')) {
  console.log('启动录屏失败');
  System.exit();
}

// 录屏期间截图（建议已开无障碍）
let imageFile = Images.capture();
console.log(imageFile);

System.sleep(10000);
let path = ScreenRecord.stop();
if (path) {
  console.log('录屏完成：' + path);
  // 已写到 /sdcard/Movies/，不要再 MediaStore.saveVideo
  // 仅 start() 无参/缓存目录时才：MediaStore.saveVideo(path);
}
```

## 注意

- 未开录屏权限不要调用 `start()`。
- 录屏中可 `Images.capture()`；同时截图/找图时建议开无障碍。
- 录制过短时 `stop()` 可能返回 `null`。
- **勿重复保存：** 公共目录录完即落盘；`MediaStore.saveVideo` 只用于私有/缓存文件入库。
- 相关：[`Access.md`](./Access.md)、[`Images.md`](./Images.md)、[`MediaStore.md`](./MediaStore.md)。
