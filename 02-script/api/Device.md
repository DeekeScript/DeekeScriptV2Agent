# Device

屏幕、系统版本、机型、网络、位置、已安装应用。

## 可用上下文

- **page.js** 与 **tasks.js** 都能用。`getLocation` 需先申请位置权限。

## 方法

d.ts 里还有一批与返回对象字段同名的属性（如 `ipv4`、`latitude`、`packageName`）。生成时按下面方法调用，不要当独立 API 编造用法。

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| width | `width()` | 无 | `number` | 屏幕真实宽度 px；旋转后仍是真实宽度 |
| height | `height()` | 无 | `number` | 屏幕真实高度 px |
| pixelDensity | `pixelDensity()` | 无 | `number` | 像素密度，用于 dp 与 px。如 1=mdpi、2=xhdpi、3=xxhdpi |
| sdkInt | `sdkInt()` | 无 | `number` | SDK 版本号 |
| device | `device()` | 无 | `string` | 硬件标识，不是市场名/品牌名 |
| androidVersion | `androidVersion()` | 无 | `string` | Android 版本号 |
| getUuid | `getUuid()` | 无 | `string` | ANDROID_ID。恢复出厂可能变；卸载 App 不变 |
| getToken | `getToken()` | 无 | `string` | 设备激活码（激活后才有） |
| getAttr | `getAttr(key: string)` | 键 | `string` | 其它设备数据；也可用 `getAttr('token')` |
| brand | `brand()` | 无 | `string` | 品牌，如 `huawei` |
| os | `os()` | 无 | `string` | 操作系统标识，多为 `android` |
| model | `model()` | 无 | `string` | 型号名 |
| codename | `codename()` | 无 | `string` | 代号 |
| manufacturer | `manufacturer()` | 无 | `string` | 制造商 |
| hardware | `hardware()` | 无 | `string` | 硬件名 |
| board | `board()` | 无 | `string` | 主板 |
| product | `product()` | 无 | `string` | 产品名 |
| bootloader | `bootloader()` | 无 | `string` | Bootloader 版本 |
| buildId | `buildId()` | 无 | `string` | 构建 ID |
| display | `display()` | 无 | `string` | 显示版本 |
| fingerprint | `fingerprint()` | 无 | `string` | 设备指纹 |
| host | `host()` | 无 | `string` | 主机名 |
| user | `user()` | 无 | `string` | 构建用户 |
| getCpuAbi | `getCpuAbi()` | 无 | `string` | CPU 架构，如 `arm64-v8a` |
| getCpuAbis | `getCpuAbis()` | 无 | `string[]` | 支持的架构列表 |
| getWifiIPAddress | `getWifiIPAddress()` | 无 | `string` | WiFi IP；未连 WiFi 为 `""` |
| getIPAddress | `getIPAddress()` | 无 | `string` | 当前活动网络局域网 IP；失败为 `127.0.0.1` |
| getPublicIPAddress | `getPublicIPAddress()` | 无 | `string` | 公网 IPv4；需网络，可能较慢；失败 `""` |
| getPublicIPAddressV6 | `getPublicIPAddressV6()` | 无 | `string` | 公网 IPv6；失败 `""` |
| getPublicIPInfo | `getPublicIPInfo()` | 无 | `{ ipv4, ipv6 }` | 公网 IPv4 与 IPv6 |
| getIpInfo | `getIpInfo()` | 无 | `{ ip, wifiIP, publicIP, publicIPV6, publicIPInfo }` | 完整 IP 信息 |
| getMacAddress | `getMacAddress()` | 无 | `string` | MAC；WiFi 未连为 `""` |
| getNetworkType | `getNetworkType()` | 无 | `"WiFi" \| "Mobile" \| "Ethernet" \| "Other" \| "None"` | 网络类型 |
| isNetworkConnected | `isNetworkConnected()` | 无 | `boolean` | 是否已联网 |
| getNetworkInfo | `getNetworkInfo()` | 无 | `{ type, connected, macAddress, ip, wifiIP, publicIP, publicIPV6 }` | 完整网络信息 |
| getLocation | `getLocation()` | 无 | 位置对象或 `null` | 需位置权限。优先 GPS，否则网络/被动。字段：latitude、longitude、altitude、accuracy、speed、bearing、time、provider |
| getStatusBarHeight | `getStatusBarHeight()` | 无 | `number` | 状态栏高度 px；失败 0 |
| getNavigationBarHeight | `getNavigationBarHeight()` | 无 | `number` | 底部导航栏高度；隐藏或物理键为 0 |
| getInstalledPackages | `getInstalledPackages()` | 无 | `string[]` | 已装应用包名 |
| getInstalledApplications | `getInstalledApplications()` | 无 | 数组 | 每项含 packageName、appName、versionName、versionCode |

## 最小片段

```javascript
console.log(Device.width(), Device.height());
```

## 注意

- `getLocation` 前用 [`Access.hasLocationPermission`](Access.md) / `requestLocationPermissions`。
- 手势坐标用 `width()` / `height()`，单位 px。
- 索引见 [`INDEX.md`](INDEX.md)。
