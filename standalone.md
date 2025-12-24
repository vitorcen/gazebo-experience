# Standalone 示例编译与使用指南

## 快速编译

所有 standalone 示例已成功编译。使用项目根目录的脚本一键编译：

```bash
./build-standalone.sh
```

脚本功能：
- 自动定位 gz-sim/examples/standalone 目录
- 自动禁用 conda 环境干扰
- 使用纯净系统库编译
- 并行编译所有 15 个项目
- 彩色输出编译状态

## 编译结果

**全部 15 个项目编译成功**

| 项目 | 可执行文件 | 说明 |
|------|-----------|------|
| acoustic_comms_demo | `gz-sim/examples/standalone/acoustic_comms_demo/build/acoustic_comms_demo` | 声学通信演示 |
| comms | `gz-sim/examples/standalone/comms/build/publisher` | 通信发布器 |
| custom_server | `gz-sim/examples/standalone/custom_server/build/custom_server` | 自定义仿真服务器 |
| each_performance | `gz-sim/examples/standalone/each_performance/build/each` | 性能测试工具 |
| entity_creation | `gz-sim/examples/standalone/entity_creation/build/entity_creation` | 动态实体创建 |
| external_ecm | `gz-sim/examples/standalone/external_ecm/build/external_ecm` | 外部 ECM 访问 |
| gtest_setup | `gz-sim/examples/standalone/gtest_setup/build/gravity_TEST`<br>`gz-sim/examples/standalone/gtest_setup/build/command_TEST` | 单元测试示例 |
| joy_to_twist | `gz-sim/examples/standalone/joy_to_twist/build/joy_to_twist` | 手柄到速度转换 |
| joystick | `gz-sim/examples/standalone/joystick/build/joystick` | 手柄输入处理 |
| keyboard | `gz-sim/examples/standalone/keyboard/build/keyboard` | 键盘控制 |
| light_control | `gz-sim/examples/standalone/light_control/build/light_control` | 灯光控制 |
| lrauv_control | `gz-sim/examples/standalone/lrauv_control/build/lrauv_control` | LRAUV PID 控制器 |
| marker | `gz-sim/examples/standalone/marker/build/marker` | 可视化标记 |
| multi_lrauv_race | `gz-sim/examples/standalone/multi_lrauv_race/build/multi_lrauv_race` | 多 LRAUV 竞赛 |
| scene_requester | `gz-sim/examples/standalone/scene_requester/build/scene_requester` | 场景请求处理 |

---

## 使用示例

### 1. keyboard - 键盘控制车辆

**场景**：两辆差速驱动车辆的键盘控制

**终端 1 - 启动仿真**：
```bash
gz sim -v 4 gz-sim/examples/worlds/diff_drive.sdf
```

**终端 2 - 运行键盘控制**：
```bash
cd gz-sim/examples/standalone/keyboard/build
./keyboard ../keyboard.sdf
```

**体验**：
- 方向键：控制蓝色车辆
- WASD 键：控制绿色车辆
- 可以同时控制两辆车

---

### 2. lrauv_control - 水下机器人控制

**场景**：使用 PID 控制器控制 LRAUV 水下机器人

**终端 1 - 启动仿真**：
```bash
gz sim -r gz-sim/examples/worlds/lrauv_control_demo.sdf
```

**终端 2 - 运行 PID 控制器**：
```bash
cd gz-sim/examples/standalone/lrauv_control/build
# ./lrauv_control <速度m/s> <偏航角rad> <俯仰角rad>
./lrauv_control 0.5 0.174 0.174
```

**体验**：
- 水下机器人会按照指定速度和姿态运动
- 终端实时显示速度、偏航角、俯仰角的误差
- 观察 PID 控制器的收敛过程

---

### 3. acoustic_comms_demo - 声学通信演示

**场景**：3 艘水下机器人通过声学通信协同运动

**终端 1 - 启动仿真**：
```bash
cd gz-sim/examples/standalone/acoustic_comms_demo/build
gz sim -r ../../../worlds/acoustic_comms_demo.sdf
```

**终端 2 - 运行控制程序**：
```bash
./acoustic_comms_demo
```

**体验**：
- Triton（中间车）立即开始移动并发送声学信号
- Tethys（中间）先收到信号并开始移动
- Daphne（最远）最后收到信号并移动
- 演示声音传播延迟效果

---

### 4. multi_lrauv_race - 多 LRAUV 竞赛

**场景**：多个水下机器人竞速

**终端 1 - 启动仿真**：
```bash
cd gz-sim/examples/standalone/multi_lrauv_race/build
gz sim -r ../../../worlds/multi_lrauv_race.sdf
```

**终端 2 - 运行控制程序**：
```bash
./multi_lrauv_race
```

**体验**：
- 多个 LRAUV 同时接收随机控制指令
- 观察推进器和舵面控制效果
- 低速运动模拟真实水下机器人

---

### 5. entity_creation - 动态创建实体

**场景**：运行时动态生成模型

**终端 1 - 启动空世界**：
```bash
gz sim gz-sim/examples/worlds/empty.sdf
```

**终端 2 - 运行创建程序**：
```bash
cd gz-sim/examples/standalone/entity_creation/build
./entity_creation
```

**体验**：
- 在空世界中动态生成多个实体
- 演示程序化模型创建

---

### 6. marker - 可视化标记

**场景**：在仿真中添加可视化标记（线、点、框等）

**终端 1 - 启动仿真**：
```bash
gz sim
```

**终端 2 - 运行标记程序**：
```bash
cd gz-sim/examples/standalone/marker/build
./marker
```

**体验**：
- 仿真窗口中会出现各种可视化标记
- 终端输出标记操作信息
- 用于调试和可视化辅助

---

### 7. external_ecm - 外部 ECM 访问

**场景**：从外部程序访问实体组件管理器（ECM）

**终端 1 - 启动仿真**：
```bash
gz sim gz-sim/examples/worlds/
gz sim shapes.sdf
```

**终端 2 - 查询实体**：
```bash
cd gz-sim/examples/standalone/external_ecm/build
./external_ecm shapes
```

**体验**：
- 列出世界中所有实体及其父子关系
- 显示实体 ID 和名称
- 演示外部程序如何查询仿真状态

---

### 8. joystick + joy_to_twist - 手柄控制

**场景**：使用游戏手柄控制车辆（需要实体手柄设备）

**终端 1 - 手柄输入**：
```bash
cd gz-sim/examples/standalone/joystick/build
./joystick ../joystick.sdf
```

**终端 2 - Joy 转 Twist**：
```bash
cd gz-sim/examples/standalone/joy_to_twist/build
./joy_to_twist ../joy_to_twist.sdf
```

**终端 3 - 启动仿真**：
```bash
gz sim gz-sim/examples/worlds/
gz sim -v 4 diff_drive.sdf
```

**体验**：
- 按住手柄 A 键，使用摇杆控制车辆
- 手柄输入 → Joy 消息 → Twist 消息 → 车辆运动
- 演示完整的输入处理链

**注意**：需要手柄连接到 `/dev/input/js0`

---

### 9. gtest_setup - 单元测试

**场景**：运行 gz-sim 的单元测试

**运行测试**：
```bash
cd gz-sim/examples/standalone/gtest_setup/build
./gravity_TEST
./command_TEST
```

**体验**：
- 测试重力系统功能
- 测试命令系统功能
- 演示如何为 gz-sim 编写单元测试

---

### 10. light_control - 灯光控制

**场景**：动态控制场景灯光

**终端 1 - 启动仿真**：
```bash
gz sim
```

**终端 2 - 控制灯光**：
```bash
cd gz-sim/examples/standalone/light_control/build
./light_control
```

**体验**：
- 程序化修改场景灯光属性
- 改变灯光颜色、强度、位置

---

### 11. scene_requester - 场景请求

**场景**：请求场景信息

**终端 1 - 启动仿真**：
```bash
gz sim shapes.sdf
```

**终端 2 - 请求场景**：
```bash
cd gz-sim/examples/standalone/scene_requester/build
./scene_requester
```

**体验**：
- 获取场景完整信息
- 演示场景查询接口

---

### 12. custom_server - 自定义服务器

**场景**：运行自定义的仿真服务器

**运行**：
```bash
cd gz-sim/examples/standalone/custom_server/build
./custom_server
```

**体验**：
- 创建自定义仿真服务器
- 不依赖 `gz sim` 命令
- 完全控制仿真循环

---

### 13. each_performance - 性能测试

**场景**：测试 ECM 的 `Each` 方法性能

**运行**：
```bash
cd gz-sim/examples/standalone/each_performance/build
./each
```

**体验**：
- 性能基准测试
- 输出性能数据
- 可用 `each.gp` 绘制性能图表

---

### 14. comms - 通信发布器

**场景**：演示 gz-transport 通信

**运行**：
```bash
cd gz-sim/examples/standalone/comms/build
./publisher
```

**体验**：
- 发布自定义消息
- 演示 gz-transport 基础用法

---

## 故障排查

### 库版本冲突

**问题**：编译时出现 fmt/spdlog 版本冲突（特别是 conda 环境）

**原因**：conda 的 fmt 库 (v11) 与系统 spdlog (期望 v9) 不兼容

**解决方案**：编译脚本自动使用纯净系统 PATH：
```bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

### 手动编译单个项目

如果需要单独编译某个项目：

```bash
cd gz-sim/examples/standalone/<项目名>
mkdir -p build && cd build
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin cmake ..
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make -j$(nproc)
```

### 清理重新编译

从头重新编译所有项目：

```bash
cd gz-sim/examples/standalone
find . -type d -name "build" -exec rm -rf {} +
cd ../../..
./build-standalone.sh
```

### 手柄设备未找到

如果运行 joystick 例子时报错：

1. 确认手柄已连接：`ls /dev/input/js*`
2. 修改 `joystick.sdf` 中的 `<dev>` 标签指向正确设备
3. Docker 中需要添加 `--device=/dev/input/js0` 参数

---

## 系统要求

- Ubuntu 24.04 或兼容系统
- gz-sim 已安装
- 系统库：
  - libfmt9 (9.1.0)
  - libspdlog1.12 (1.12.0)
  - gz-transport
  - sdformat
  - gz-msgs
  - gz-common

---

## 注意事项

- 所有例子使用 gz-transport 进行进程间通信
- 大多数例子需要运行中的 gz-sim 实例
- 部分例子需要 `examples/worlds/` 中的特定场景文件
- 编译产物在各项目的 `build/` 目录下

---

## 快速参考

| 需求 | 推荐示例 |
|------|---------|
| 学习键盘控制 | keyboard |
| 学习手柄控制 | joystick + joy_to_twist |
| 水下机器人控制 | lrauv_control |
| 多机器人协同 | acoustic_comms_demo, multi_lrauv_race |
| 动态创建模型 | entity_creation |
| 查询仿真状态 | external_ecm, scene_requester |
| 可视化调试 | marker |
| 灯光控制 | light_control |
| 自定义服务器 | custom_server |
| 单元测试 | gtest_setup |
| 性能测试 | each_performance |
