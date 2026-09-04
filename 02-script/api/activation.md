# activation

激活码由 DeekeScript 客户端请求用户后端。生成对接代码时按下列接口实现。请求会带校验字段。

脚本里用 `Http` 请求完整 URL。下面接口供生成后端或对接代码时对照。

## 上下文

| 环境 | 说明 |
|------|------|
| 后端 HTTP | 必须实现 |
| `page.js` / `tasks/*.js` | 一般不自己发激活请求；可读缓存配置 |

## 接口校验

POST 字段：`android_id`、`secret`、`timestamp`；激活时还有 `token`。

服务端用库里该设备的激活码计算：

```
secret === md5(android_id + token + timestamp)
```

不一致则激活失效。`android_id` 恢复出厂会变，卸载 App 不变。

## 接口

均为 POST，`Content-Type: application/json`。成功约定：`code: 0` 且 `success: true`。

| type | 地址示例 | 何时调用 | 请求要点 | 成功 data |
|------|----------|----------|----------|-----------|
| `bind` | `/dke/login` | 用户提交激活码 | `token`、`android_id` | `{ token_time: "29.99天后过期" }` |
| `checkBind` | `/dke/checkBind` | 每次跑业务 | `timestamp`、`secret`、`android_id` | 同上；失败提示 `msg` |
| `aiSpeechToken` | `/dke/getBaiduToken` | 每次智能话术 | 同 checkBind | `{ access_token: "..." }` |
| `config` | `/dkee/config` | 初始化，**不校验是否已激活** | — | `ad`、`payList`、`role` |
| `getToken` | `/alipay/getToken` | 支付完成后 | — | 成功则关闭支付入口，可带 `token` / `token_time` |
| `createOrder` | `/alipay/createOrder` | 下单 | 扫码含 `"type":"scan"`、`goods_name`、`total_amount` | `params`（支付宝 body）、`order_no` |

`config` 会被 App 缓存约 5 分钟。脚本读取：

```javascript
let config = Storage.create('deekeScript:important').get('DeekeConfig');
let res = Json.parse(config);
console.log(res);
```

`role`、`ad` 可供页面拉取后 `setData` 展示。页面自己 `Http.get` + `setData` 即可。

## 升级

`settingLists` 里 `type: "updateApp"` 的 `url`（如 `/dke/updateApp`）。点击后 POST `...?version=100`。有更新返回 `downloadUrl`、`newVersion`、`appCurrentVersion`；`newVersion` 大于当前则下载安装。

## 注意

- 不要在客户端伪造 `secret`。
- 相关：[`backend.md`](./backend.md)、[`apk.md`](./apk.md)、[`Storage.md`](./Storage.md)。
