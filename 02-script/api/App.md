# App

当前应用与其它已装应用：包名、版本、启动、打开设置或 URL。

## 可用上下文

- **page.js** 与 **tasks.js** 都能用。启动目标 App、判断是否安装，多在任务脚本。

## 方法

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| currentPackageName | `currentPackageName()` | 无 | `string` | 当前开发的这个 App 的包名（不是前台其它 App） |
| currentVersionCode | `currentVersionCode()` | 无 | `number` | 当前 App 版本号 |
| currentVersionName | `currentVersionName()` | 无 | `string` | 当前 App 版本名 |
| packageInfo | `packageInfo(packageName: string)` | 目标包名 | `any` | 包信息，可取 `versionCode` / `versionName` 等 |
| gotoIntent | `gotoIntent(uri: string)` | URI | `void` | 按 URI 启动 Activity |
| startActivity | `startActivity(intent: Intent)` | Intent | `void` | 按 Intent 启动 Activity。官方标明 2.0 即将上线 |
| backApp | `backApp()` | 无 | `void` | 回到执行脚本的 App |
| startService | `startService(service: Intent)` | Intent | `any` | d.ts 有此方法；官方文档未单独说明 |
| sendBroadcast | `sendBroadcast(intent: Intent)` | Intent | `void` | d.ts 有此方法；官方文档未单独说明 |
| launch | `launch(packageName: string)` | 包名 | `void` | 按包名打开应用 |
| notifySuccess | `notifySuccess(title: string, content: string)` | 标题、内容 | `void` | 显示成功通知 |
| getAppVersionName | `getAppVersionName(packageName: string)` | 包名 | `string` | 指定应用版本名 |
| getAppVersionCode | `getAppVersionCode(packageName: string)` | 包名 | `number` | 指定应用版本号 |
| openAppSetting | `openAppSetting(packageName: string)` | 包名 | `void` | 打开该应用的系统设置页 |
| isAppInstalled | `isAppInstalled(packageName: string)` | 包名 | `boolean` | 是否已安装 |
| openUrl | `openUrl(url: string, packageName?: string)` | URL；可选包名 | `void` | 打开 URL。有包名则优先用该应用，未安装则浏览器；无包名则浏览器 |

`currentPackage()`（前台包名）在 [`System`](System.md)，不要和 `App.currentPackageName()` 混用。

## 最小片段

```javascript
App.launch('top.deeke.script');
```

## 注意

- 从后台拉起其它 App，部分机型还要后台弹窗权限，见 [`Access`](Access.md) / [`permission.md`](../permission.md)。
- 索引见 [`INDEX.md`](INDEX.md)。
