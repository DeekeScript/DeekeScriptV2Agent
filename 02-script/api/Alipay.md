# Alipay

调起支付宝 **App 支付**。底座已集成 `alipaysdk-android`：把服务端返回的 `orderString` 交给 `PayTask.payV2`，拉起支付宝 App。

扫码、H5 网页支付不要用本模块。扫码把后端 `qrCode` 交给 [`QrCode.toFile`](QrCode.md) 生成本地图再展示；H5 用 [`App.openUrl`](App.md)。本模块只处理 App 支付串。

## 可用上下文

- **page.js** 与 **tasks.js** 都能用。下单与调起多在页面脚本。

## 方法

| 方法 | 签名 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| pay | `pay(orderString: string)` | 服务端签好的支付串 | `{ ok, resultStatus, memo, result }` | 同步调起支付宝，等待用户完成或取消 |
| payV2 | `payV2(orderString: string)` | 同 `pay` | 同 `pay` | 与 `pay` 相同，对齐 SDK 方法名 |
| isSuccess | `isSuccess(payResult)` | `pay` 的返回值 | `boolean` | `ok === true` 或 `resultStatus === "9000"` |

返回对象字段：

| 字段 | 类型 | 说明 |
|------|------|------|
| ok | `boolean` | 是否成功（`resultStatus === "9000"`） |
| resultStatus | `string` | 支付宝状态码；成功为 `9000` |
| memo | `string` | 说明文案（取消、失败时常见） |
| result | `string` | SDK 原始 `result` |

## 对接顺序

1. 服务端创建订单（支付宝 `alipay.trade.app.pay`），返回 `orderString`。
2. 客户端 `Alipay.pay(orderString)`（会阻塞直到收银台结束）。
3. 看 `resultStatus` / `ok`；`9000` 只表示 SDK 侧成功。
4. **以服务端为准**：再轮询订单 / 激活接口，确认到账后再开通权益。

## 最小片段

```javascript
let orderString = /* Http 下单得到的 payParams.orderString */;
let r = Alipay.pay(orderString);
if (Alipay.isSuccess(r)) {
  // 再轮询服务端订单 / 激活
}
```

## 页面示例

```javascript
Page({
  onPayApp() {
    this.showLoading('正在调起支付宝…');
    let res = Http.post('https://example.com/api/v1/app/orders', {
      code: 'D0001',
      plan: 'month',
      device_id: Device.getAndroidId(),
      pay_method: 'alipay',
      channel: 'app'
    }, {});
    // 按自己后端解析；下面假定已得到 orderString / orderNo
    let data = JSON.parse(res || '{}');
    let orderString = data.data && data.data.payParams && data.data.payParams.orderString;
    let orderNo = data.data && data.data.orderNo;
    if (!orderString) {
      this.hideLoading();
      this.toast('下单失败');
      return;
    }
    let payResult = null;
    try {
      // 不要对 Alipay 使用 typeof（Rhino 会报「JavaScript 值无效」）
      payResult = Alipay.pay(String(orderString));
    } catch (e) {
      this.hideLoading();
      this.toast((e && e.message) || '调起失败');
      return;
    }
    this.hideLoading();
    // 无论 SDK 结果如何，都建议向服务端确认
    this.pollOrder(orderNo);
    if (Alipay.isSuccess(payResult) || (payResult && payResult.ok)) {
      this.toast('支付完成，正在确认开通…');
    } else {
      let memo = payResult && payResult.memo ? String(payResult.memo) : '';
      this.toast(memo || '支付未完成');
    }
  }
});
```

常见 `resultStatus`（以支付宝 SDK 为准）：`9000` 成功、`6001` 用户取消、`4000` 失败、`8000` 处理中、`6002` 网络错误。

## 注意

- 不要对 `Alipay` 使用 `typeof`；直接 `Alipay.pay(...)`，用 try/catch 兜底。
- 需要当前有可用 Activity；支付过程会拉起支付宝 App。
- 支付串必须由服务端私钥签名；客户端不要存私钥、不要自己拼 `sign`。
- 空串返回失败结果（不会调起支付宝）。
- 客户端 `9000` ≠ 业务已开通；开通以服务端订单 `paid` / 激活为准。
- 相关：[`QrCode`](QrCode.md)（扫码图）、[`App`](App.md)（`openUrl`）、[`Http`](Http.md)、[`Device`](Device.md)、索引 [`INDEX.md`](INDEX.md)。
