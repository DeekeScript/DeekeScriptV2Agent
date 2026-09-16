# Sms

监听系统短信（验证码等）。全局对象名是 `Sms`。多数验证码 App 会发通知，也可优先用 [`NotificationBridge`](Notification.md)，不必申请短信权限。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 权限引导可以 |
| `tasks/*.js` | 监听放任务脚本 |

## 前置权限

```javascript
if (!Access.hasSmsPermission()) {
  Access.requestSmsPermission();
  System.exit();
}
```

永久拒绝时用 `Access.isSmsPermissionPermanentlyDenied()` 并 `Access.openPermissionSettings()`。

## 方法

| 方法 | 签名 | 说明 |
|------|------|------|
| startListening | `startListening(onSms)` | 回调 `(address, body)` |
| stopListening | `stopListening()` | 停止 |
| extractCode | `extractCode(body, length?)` | 提取数字验证码；省略 length 则匹配 4–8 位 |

## 最小片段

```javascript
if (!Access.hasSmsPermission()) {
  Access.requestSmsPermission();
  System.exit();
}

Sms.startListening(function (address, body) {
  let code = Sms.extractCode(body, 6);
  console.log(address, body, code);
});
```

结束任务前调用 `Sms.stopListening()`。

## 注意

- 商店与机型对短信权限管控严，部分设备可能拿不到。
- 索引见 [`INDEX.md`](INDEX.md)。
