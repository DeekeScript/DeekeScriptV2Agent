# Sensors

只读传感器封装。全局对象名是 `Sensors`。按类型注册回调，脚本结束会自动 `unregisterAll`。

## 上下文

| 环境 | 可用 |
|------|------|
| `page.js` | 是（短采样可以） |
| `tasks/*.js` | 是 |

## 方法

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `list()` | 无 | `string[]` | **本机**可用传感器别名 |
| `catalog()` | 无 | `object[]` | 已知类型目录（说明 + `values` 含义），不依赖本机是否具备 |
| `has(type)` | `type {string}` | `boolean` | 是否存在该类型 |
| `register(type, callback)` | 类型、回调 | `boolean` | 注册；默认约 UI 延迟 |
| `register(type, callback, delayMs)` | 另加采样间隔毫秒 | `boolean` | `delayMs <= 0` 用默认 UI 延迟 |
| `unregister(type)` | 类型 | `void` | 取消该类型 |
| `unregisterAll()` | 无 | `void` | 取消全部 |

## 类型目录

| type | 别名 | 说明 | values |
|------|------|------|--------|
| `accelerometer` | `acc` | 加速度计（含重力） | `[0]=x,[1]=y,[2]=z`，m/s² |
| `gyroscope` | `gyro` | 陀螺仪（角速度） | `[0]=x,[1]=y,[2]=z`，rad/s |
| `light` | `light_sensor` | 环境光 | `[0]` 光照，lx |
| `proximity` | — | 距离/接近（听筒遮挡） | `[0]` cm；部分机型仅远/近 |
| `magnetic_field` | `magnetic` / `magnetometer` | 磁场 | `[0]=x,[1]=y,[2]=z`，μT |
| `gravity` | — | 重力加速度 | `[0]=x,[1]=y,[2]=z`，m/s² |
| `linear_acceleration` | — | 线性加速度（已扣重力） | `[0]=x,[1]=y,[2]=z`，m/s² |
| `rotation_vector` | — | 旋转矢量（姿态） | `[0..2]` 分量，`[3]` 可选标量 |
| `step_counter` | — | 计步累计（开机以来） | `[0]` 累计步数；Android 10+ 需 `ACTIVITY_RECOGNITION` |
| `step_detector` | — | 单步检测 | `[0]=1.0` 表示一步；同上权限 |
| `pressure` | — | 气压 | `[0]` hPa |
| `humidity` | `relative_humidity` | 相对湿度 | `[0]` % |
| `temperature` | `ambient_temperature` | 环境温度 | `[0]` ℃ |

也可用 `type_<数字>` 按 Android `Sensor.TYPE_*` 常量注册（本机有对应传感器时）。

运行时查看：

```javascript
console.log(JSON.stringify(Sensors.catalog()));
```

## 回调对象

`callback(event)`，`event` 字段：

| 字段 | 类型 | 说明 |
|------|------|------|
| `values` | `number[]` | 传感器读数（含义见上表） |
| `timestamp` | `number` | 时间戳 |
| `accuracy` | `number` | 精度 |
| `type` | `string` | 注册时的类型别名 |

## 最小片段

```javascript
console.log(Sensors.list());
console.log(Sensors.catalog());

if (Sensors.has('accelerometer')) {
  Sensors.register('accelerometer', function (e) {
    console.log(e.values[0], e.values[1], e.values[2]);
  }, 100);
}

setInterval(function () {
  console.log('采样中');
}, 5000);

// 结束前
// Sensors.unregister('accelerometer');
// Sensors.unregisterAll();
```

## 注意

- `list()` 是本机实际有的；`catalog()` 是全部已知说明。先 `has` / `list` 再 `register`。
- 同一类型再次 `register` 会先卸掉旧监听。
- 相关：[`Device.md`](./Device.md)、[`timer.md`](./timer.md)。
