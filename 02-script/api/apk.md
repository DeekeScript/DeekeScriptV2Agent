# apk

把工程打成独立 APK。开发完同步到手机，在 DeekeScript 里能看到项目后操作。

## 上下文

打包是客户端流程，不是运行时 API。生成工程时把打包字段写进 `deekeScript-v2.json`。

## 操作流程

1. 点「打包」
2. 未登录则登录（未注册先注册）
3. 开通会员
4. 开始打包（几分钟内完成）

自动步骤：下载打包助手 → 下载模板 → 解包 → 生成签名 → 打包。

产物在手机 `DCIM/DeekeScript/包名/`，含签名和说明文件。

## 打包字段（V2 入口也可写）

`deekeScript-v2.json` 可写这些字段（含义与 V1 `deekeScript.json` 相同）：

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `name` | String | 是 | 安装后桌面名称 |
| `packageName` | String | 是 | 包名，不要用默认值 |
| `versionCode` | String | 是 | 整型版本号，升级比较用 |
| `versionName` | String | 是 | 如 `1.0.0` |
| `icon` | String | 是 | 建议 200×200 |
| `host` | String | 是 | 接口域名 |

V2 界面入口另需 `homePage`。只跑脚本可以不配页面，但仍要有 `deekeScript-v2.json`。完整字段见官方配置；不要把 V1 的 `hooks` 写进 V2。

## 最小入口示例

```json
{
  "name": "Deeke",
  "packageName": "cn.deeke.demo",
  "versionCode": "100",
  "versionName": "1.0.0",
  "icon": "logo/dke.png",
  "host": "https://example.com",
  "homePage": "pages/home"
}
```

## 注意

- `packageName` 必须改成自己的。
- `debug: false`（若使用）时需要激活码才能跑业务，见 [`activation.md`](./activation.md)。
- 打包默认加密 JS，见 [`code-encryption.md`](./code-encryption.md)。
- DO 模式打包 App 同样可设为 Device Owner，包名换成这里的 `packageName`，见 [`do-mode.md`](./do-mode.md)。
