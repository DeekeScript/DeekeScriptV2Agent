# 代码加密

打包 APK 时，DeekeScript **默认**用 AES + 随机 IV 加密 JavaScript。生成工程时不要另写加密脚本或要求用户先加密源码。

## 上下文

| 阶段 | 说明 |
|------|------|
| 开发 / 同步 | 工程里仍是明文 `.js` |
| 打包 | 产物内脚本变为密文 |
| 运行 | 引擎解密执行，业务代码仍按明文 API 写 |

这与运行时 [`Encrypt.md`](./Encrypt.md) 不是同一件事：`Encrypt.md5` 是你调用的哈希；本页是打包保护源码。

## 形态

加密前：

```javascript
const dyApp = {
  getName() {
    return 'appName';
  }
};

module.exports = dyApp;
```

加密后类似（不要手写、不要当业务代码）：

```
U2FsdGVkX18fBheHDLwYx8ymlys2OayQV0bmWy4XRFJmDYh+...
```

## 注意

- 生成工程只写明文 JS。不要把密文提交进 `tasks/` 或 `pages/`。
- 不要为了「加密」去引入第三方混淆，除非用户明确要求。
- 相关：[`apk.md`](./apk.md)。
