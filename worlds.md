# Worlds 目录 - 世界场景示例

本文档介绍 `examples/worlds/` 目录下的所有 SDF 场景文件，可直接用 `gz sim <文件名>` 运行。

> **提示**：大多数场景都提供了控制命令示例，可通过 `gz topic` 发送指令控制模型。

---

## 基础场景


| 文件                | 说明                 |
| --------------------- | ---------------------- |
| `empty.sdf`         | 空世界，最基础的模板 |
| `empty_gui.sdf`     | 带 GUI 的空世界      |
| `default.sdf`       | 默认场景设置         |
| `minimal_scene.sdf` | 最小化场景           |

---

## 几何与形状


| 文件                        | 说明                                 |
| ----------------------------- | -------------------------------------- |
| `shapes.sdf`                | 基础几何形状演示（球、立方体、圆柱） |
| `3k_shapes.sdf`             | 大规模形状（3000个），性能测试       |
| `rolling_shapes.sdf`        | 滚动物体，物理演示                   |
| `shapes_bitmask.sdf`        | 碰撞位掩码演示                       |
| `shapes_population.sdf.erb` | 大量形状生成（ERB 模板）             |

运行方式：`erb -T 1 shapes_population.sdf.erb > shapes_population.sdf` 生成 SDF

---

## 摄像机与传感器

### 视觉传感器


| 文件                      | 说明                 |
| --------------------------- | ---------------------- |
| `camera_sensor.sdf`       | 普通 RGB 摄像机      |
| `depth_camera_sensor.sdf` | 深度相机，输出距离图 |
| `segmentation_camera.sdf` | 语义分割相机         |
| `thermal_camera.sdf`      | 热成像相机           |
| `wide_angle_camera.sdf`   | 广角/鱼眼相机        |
| `boundingbox_camera.sdf`  | 边界框检测相机       |
| `camera_lens_flare.sdf`   | 镜头光晕效果演示     |

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim camera_sensor.sdf
```

**查看相机数据**：

```bash
# 查看 RGB 图像
gz topic -e -t /camera/view/image

# 查看深度图
gz topic -e -t /camera/depth/image

# 查看分割结果
gz topic -e -t /camera/segmentation/image
```

### 激光雷达


| 文件                                | 说明                    |
| ------------------------------------- | ------------------------- |
| `gpu_lidar_sensor.sdf`              | GPU 加速激光雷达        |
| `gpu_lidar_retro_values_sensor.sdf` | 激光雷达反射值/retro 值 |

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim gpu_lidar_sensor.sdf
```

**查看点云数据**：

```bash
gz topic -e -t /lidar/points
```

### 特殊传感器


| 文件                                | 说明                             |
| ------------------------------------- | ---------------------------------- |
| `contact_sensor.sdf`                | 接触力传感器                     |
| `environmental_sensor.sdf`          | 环境数据传感器（温度、湿度等）   |
| `logical_camera_sensor.sdf`         | 逻辑相机，检测特定模型           |
| `triggered_camera_sensor.sdf`       | 触发式相机（满足条件才拍照）     |
| `logical_audio_sensor_plugin.sdf`   | 逻辑音频传感器（麦克风检测声源） |
| `optical_tactile_sensor_plugin.sdf` | 光学触觉传感器（接触力可视化）   |

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim contact_sensor.sdf
```

**查看接触力**：

```bash
gz topic -e -t /contact
```

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim optical_tactile_sensor_plugin.sdf
```

**启用/禁用触觉传感器**：

```bash
gz service -s /optical_tactile_plugin/enable \
    --reqtype gz.msgs.Boolean --reptype gz.msgs.Empty \
    --timeout 2000 -r 'data: false'
```

### 传感器综合


| 文件               | 说明               |
| -------------------- | -------------------- |
| `sensors.sdf`      | 多传感器综合演示   |
| `sensors_demo.sdf` | 传感器功能演示场景 |

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim sensors.sdf
```

---

## 车辆与移动

### 地面车辆


| 文件                         | 说明                   |
| ------------------------------ | ------------------------ |
| `diff_drive.sdf`             | 差速驱动车辆           |
| `diff_drive_skid.sdf`        | 差速驱动（带打滑物理） |
| `mecanum_drive.sdf`          | 麦克纳姆轮全方位移动   |
| `track_drive.sdf`            | 履带车辆               |
| `skid_steer_mecanum.sdf`     | 转向与麦克纳姆轮组合   |
| `ackermann_steering.sdf`     | 阿克曼转向（汽车式）   |
| `tracked_vehicle_simple.sdf` | 简化履带车辆           |

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim diff_drive.sdf
```

**控制命令**：

```bash
# 控制蓝色车辆前进
gz topic -t "/model/vehicle_blue/cmd_vel" -m gz.msgs.Twist -p "linear: {x: 0.5}, angular: {z: 0.05}"

# 控制绿色车辆前进
gz topic -t "/model/vehicle_green/cmd_vel" -m gz.msgs.Twist -p "linear: {x: 1.0}, angular: {z: -0.1}"

# 查看里程计
gz topic -e -t /model/vehicle_blue/odometry
```

### 飞行器


| 文件                               | 说明           |
| ------------------------------------ | ---------------- |
| `quadcopter.sdf`                   | 四旋翼无人机   |
| `multicopter_velocity_control.sdf` | 多旋翼速度控制 |

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim multicopter_velocity_control.sdf
```

**控制命令（直接电机控制）**：

```bash
# 起飞（设置电机转速）
gz topic -t /X3/gazebo/command/motor_speed --msgtype gz.msgs.Actuators -p 'velocity:[700, 700, 700, 700]'

# 悬停（停止电机）
gz topic -t /X3/gazebo/command/motor_speed --msgtype gz.msgs.Actuators -p 'velocity:[0, 0, 0, 0]'
```

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim multicopter_velocity_control.sdf
```

**控制命令（速度控制）**：

```bash
# X3 上升
gz topic -t "/X3/gazebo/command/twist" -m gz.msgs.Twist -p "linear: {x: 0, y: 0, z: 0.1}, angular: {z: 0}"

# X3 悬停
gz topic -t "/X3/gazebo/command/twist" -m gz.msgs.Twist -p "linear: {x: 0, y: 0, z: 0}, angular: {z: 0}"

# X4 上升
gz topic -t "/X4/gazebo/command/twist" -m gz.msgs.Twist -p "linear: {x: 0, y: 0, z: 0.1}, angular: {z: 0}"

# 查看里程计
gz topic -e -t /model/x3/odometry
```

---

## 控制器


| 文件                              | 说明              |
| ----------------------------------- | ------------------- |
| `joint_controller.sdf`            | 通用关节控制器    |
| `joint_position_controller.sdf`   | 关节位置控制器    |
| `joint_trajectory_controller.sdf` | 关节轨迹控制器    |
| `velocity_control.sdf`            | 线速度/角速度控制 |
| `drive_to_pose_controller.sdf`    | 位姿目标控制      |
| `trajectory_follower.sdf`         | 轨迹跟随控制器    |

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim joint_position_controller.sdf
```

**控制命令**：

```bash
# 设置目标位置
gz topic -t "/model/joint_position_controller/cmd_position" -m gz.msgs.Double -p "data: 1.57"

# 查看关节状态
gz topic -e -t /model/joint_position_controller/state
```

---

## 物理与力

### 流体物理（水下/空气）


| 文件                            | 说明                         |
| --------------------------------- | ------------------------------ |
| `buoyancy.sdf`                  | 基础浮力                     |
| `buoyancy_engine.sdf`           | 带引擎的浮力系统             |
| `graded_buoyancy.sdf`           | 分层浮力（不同深度不同浮力） |
| `fluid_added_mass.sdf`          | 流体附加质量效应             |
| `lift_drag.sdf`                 | 升力和阻力                   |
| `lift_drag_battery.sdf`         | 升力阻力（带电池耗电）       |
| `lift_drag_nested.sdf`          | 嵌套模型的升力阻力           |
| `advanced_lift_drag_system.sdf` | 高级升力阻力系统             |

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim buoyancy.sdf
```

> 水下场景会自动受到浮力和阻力影响，无需手动控制。

### 外力施加


| 文件                    | 说明             |
| ------------------------- | ------------------ |
| `apply_joint_force.sdf` | 施加关节力/力矩  |
| `apply_link_wrench.sdf` | 施加连杆力和力矩 |

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim apply_joint_force.sdf
```

**控制命令**：

```bash
# 施加关节力
gz topic -t "/model/my_joint/cmd_force" -m gz.msgs.Double -p "data: 10.0"
```

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim apply_link_wrench.sdf
```

**控制命令**：

```bash
# 施加连杆力（力和力矩）
gz topic -t "/model/my_link/cmd_wrench" -m gz.msgs.Wrench -p "force: {x: 10, y: 0, z: 0}, torque: {x: 0, y: 0, z: 0}"
```

### 车轮物理


| 文件                             | 说明                 |
| ---------------------------------- | ---------------------- |
| `lookup_wheel_slip.sdf`          | 车轮打滑查找表       |
| `trisphere_cycle_wheel_slip.sdf` | 三球周期车轮打滑模型 |

---

## 空间与地形

### 地形


| 文件                   | 说明               |
| ------------------------ | -------------------- |
| `heightmap.sdf`        | 程序化高度地图地形 |
| `dem_monterey_bay.sdf` | 蒙特雷湾真实地形   |
| `dem_moon.sdf`         | 月球表面地形       |

### 环境


| 文件                        | 说明                     |
| ----------------------------- | -------------------------- |
| `sky.sdf`                   | 天空盒设置               |
| `spherical_coordinates.sdf` | 球坐标系统（大地理区域） |
| `wind.sdf`                  | 风场模拟                 |

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim wind.sdf
```

**控制命令**：

```bash
# 查看当前风速
gz topic -e -t /wind
```

---

## 通信

### 声学通信（水下）


| 文件                                  | 说明             |
| --------------------------------------- | ------------------ |
| `acoustic_comms.sdf`                  | 基础声学通信     |
| `acoustic_comms_demo.sdf`             | 声学通信演示     |
| `acoustic_comms_moving_targets.sdf`   | 移动目标声学通信 |
| `acoustic_comms_packet_collision.sdf` | 数据包碰撞演示   |
| `acoustic_comms_propagation.sdf`      | 声波传播模拟     |

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim acoustic_comms_demo.sdf
```

**控制命令**：

```bash
# 播放声源（蓝色盒子）
gz service -s /model/blue_box/sensor/source_1/play \
    --reqtype gz.msgs.Empty --reptype gz.msgs.Boolean \
    --timeout 1000 -r 'unused: false'

# 停止声源
gz service -s /model/blue_box/sensor/source_1/stop \
    --reqtype gz.msgs.Empty --reptype gz.msgs.Boolean \
    --timeout 1000 -r 'unused: false'

# 查看麦克风检测
gz topic -e -t /model/green_box/sensor/mic_1/detection
```

### 射频通信


| 文件                | 说明                     |
| --------------------- | -------------------------- |
| `rf_comms.sdf`      | 射频无线通信             |
| `perfect_comms.sdf` | 完美通信（无延迟无丢包） |

---

## 能源


| 文件                      | 说明                     |
| --------------------------- | -------------------------- |
| `fuel.sdf`                | 燃料系统                 |
| `fuel_textured_mesh.sdf`  | 带纹理的燃料模型         |
| `linear_battery_demo.sdf` | 线性电池模型（电量消耗） |

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim linear_battery_demo.sdf
```

**查看电池状态**：

```bash
gz topic -e -t /model/battery/linear_battery/state
```

---

## Actor 与人群


| 文件                        | 说明                          |
| ----------------------------- | ------------------------------- |
| `actor.sdf`                 | 单个 Actor（行人/角色）演示   |
| `actor_crowd.sdf`           | 人群模拟，多个 Actor          |
| `follow_actor.sdf`          | 跟随 Actor 功能               |
| `actors_population.sdf.erb` | 大规模 Actor 生成（ERB 模板） |

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim actor.sdf
```

**控制命令**：

```bash
# 控制 Actor 移动
gz topic -t "/model/actor_0/cmd_pose" -m gz.msgs.Pose -p "position: {x: 1, y: 0, z: 1}, orientation: {x: 0, y: 0, z: 0, w: 1}"

# 查看 Actor 位姿
gz topic -e -t /model/actor_0/pose
```

---

## 飞行器与航天


| 文件                            | 说明             |
| --------------------------------- | ------------------ |
| `plane_propeller_demo.sdf`      | 螺旋桨飞机       |
| `lighter_than_air_blimp.sdf`    | 飞艇（轻于空气） |
| `spacecraft.sdf`                | 航天器           |
| `ground_spacecraft_testbed.sdf` | 航天器地面测试台 |

---

## 水下机器人


| 文件                     | 说明                  |
| -------------------------- | ----------------------- |
| `auv_controls.sdf`       | AUV（水下机器人）控制 |
| `lrauv_control_demo.sdf` | LRAUV 控制演示        |
| `multi_lrauv_race.sdf`   | 多 LRAUV 竞赛         |
| `dvl_world.sdf`          | 多普勒速度计（DVL）   |

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim lrauv_control_demo.sdf
```

**控制命令**：

```bash
# 设置推进器推力
gz topic -t "/model/tethys/joint/propeller_joint/cmd_thrust" -m gz.msgs.Double -p "data: 50"

# 设置方向舵角度
gz topic -t "/model/tethys/joint/vertical_fins_joint/0/cmd_pos" -m gz.msgs.Double -p "data: 0.5"

# 设置俯仰舵角度
gz topic -t "/model/tethys/joint/horizontal_fins_joint/0/cmd_pos" -m gz.msgs.Double -p "data: 0.3"

# 查看里程计
gz topic -e -t /model/tethys/odometry
```

---

## 机械结构


| 文件                                  | 说明               |
| --------------------------------------- | -------------------- |
| `conveyor.sdf`                        | 传送带             |
| `elevator.sdf`                        | 电梯               |
| `mimic_fast_slow_pendulums_world.sdf` | 摆动机构（快慢摆） |
| `pendulum_links.sdf`                  | 摆连杆结构         |
| `auto_inertia_pendulum.sdf`           | 自动惯性摆         |
| `auto_inertia_rolling_shapes.sdf`     | 自动惯性滚动形状   |

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim conveyor.sdf
```

**控制命令**：

```bash
# 传送带前进
gz topic -t "/model/conveyor/link/base_link/track_cmd_vel" -m gz.msgs.Double -p "data: 1.0"

# 传送带后退
gz topic -t "/model/conveyor/link/base_link/track_cmd_vel" -m gz.msgs.Double -p "data: -1.0"

# 传送带停止
gz topic -t "/model/conveyor/link/base_link/track_cmd_vel" -m gz.msgs.Double -p "data: 0.0"

# 查看里程计
gz topic -e -t /model/conveyor/link/base_link/odometry
```

**键盘控制**：

- `W` - 前进
- `X` - 后退
- `S` - 停止

---

## 高级功能

### 关节与连接


| 文件                               | 说明                       |
| ------------------------------------ | ---------------------------- |
| `detachable_joint.sdf`             | 可分离关节（连接后可断开） |
| `world_joint.sdf`                  | 世界关节（连接到世界坐标） |
| `nested_model.sdf`                 | 嵌套模型                   |
| `nested_model_joint_positions.sdf` | 嵌套模型关节位置控制       |

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim detachable_joint.sdf
```

**控制命令**：

```bash
# 分离关节（针对 B1）
gz service -s /B1/detach --reqtype gz.msgs.Empty --reptype gz.msgs.Boolean --timeout 1000 -r 'unused: false'

# 分离关节（针对 B2）
gz service -s /B2/detach --reqtype gz.msgs.Empty --reptype gz.msgs.Boolean --timeout 1000 -r 'unused: false'

# 分离关节（针对 B3）
gz service -s /B3/detach --reqtype gz.msgs.Empty --reptype gz.msgs.Boolean --timeout 1000 -r 'unused: false'

# 查看状态
gz topic -e -t /B1/state
```

### 场景管理


| 文件                       | 说明                        |
| ---------------------------- | ----------------------------- |
| `levels.sdf`               | 分层场景（Level of Detail） |
| `levels_no_performers.sdf` | 无表演者的分层场景          |
| `spaces.sdf`               | 空间划分                    |
| `grid.sdf`                 | 网格场景                    |

### 可视化辅助


| 文件                   | 说明                     |
| ------------------------ | -------------------------- |
| `projector.sdf`        | 投影仪（投射图像到表面） |
| `breadcrumbs.sdf`      | 航迹标记（记录轨迹点）   |
| `polylines.sdf`        | 多段线可视化             |
| `particle_emitter.sdf` | 粒子发射器               |

---

## 可视化与调试


| 文件                         | 说明                     |
| ------------------------------ | -------------------------- |
| `debug_shapes.sdf`           | 调试形状（线框模式）     |
| `visualize_contacts.sdf`     | 可视化接触点             |
| `visualize_frustum.sdf`      | 可视化视锥体（相机视野） |
| `visualize_lidar.sdf`        | 可视化激光雷达点云       |
| `kinetic_energy_monitor.sdf` | 动能监控器               |
| `plot_3d.sdf`                | 3D 绘图                  |
| `performer_detector.sdf`     | 表演者检测器             |
| `visibility.sdf`             | 可见性检测               |

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim visualize_contacts.sdf
```

**查看调试信息**：

```bash
# 查看接触点
gz topic -e -t /contacts
```

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim kinetic_energy_monitor.sdf
```

**查看动能**：

```bash
gz topic -e -t /model/monitor/kinetic_energy
```

---

## 日志与录制


| 文件                                   | 说明             |
| ---------------------------------------- | ------------------ |
| `log_record_dbl_pendulum.sdf`          | 双摆日志录制     |
| `log_record_keyboard.sdf`              | 键盘事件日志录制 |
| `log_record_resources.sdf`             | 资源日志录制     |
| `log_record_shapes.sdf`                | 形状日志录制     |
| `video_record_dbl_pendulum.sdf`        | 双摆视频录制     |
| `camera_video_record_dbl_pendulum.sdf` | 相机视频录制     |

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim log_record_shapes.sdf
```

**控制命令**：

```bash
# 开始录制
gz service -s /world/log/record --reqtype gz.msgs.StringMsg --reptype gz.msgs.Boolean --timeout 1000 -r 'data: "/tmp/log"'

# 停止录制
gz service -s /world/log/stop --reqtype gz.msgs.Empty --reptype gz.msgs.Boolean --timeout 1000

# 回放日志
gz sim -r /tmp/log/state.tlog
```

---

## 灯光与渲染


| 文件                      | 说明             |
| --------------------------- | ------------------ |
| `lights.sdf`              | 多灯光演示       |
| `shadow_texture_size.sdf` | 阴影纹理大小设置 |
| `global_illumination.sdf` | 全局光照         |
| `lightmap.sdf`            | 光照贴图         |
| `shader_param.sdf`        | 自定义着色器参数 |

---

## 数据导出


| 文件                         | 说明             |
| ------------------------------ | ------------------ |
| `export_occupancy_grid.sdf`  | 导出占用栅格地图 |
| `collada_world_exporter.sdf` | COLLADA 格式导出 |

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim export_occupancy_grid.sdf
```

**查看导出数据**：

```bash
gz topic -e -t /map
```

---

## 资源与导入


| 文件                    | 说明                   |
| ------------------------- | ------------------------ |
| `import_mesh.sdf`       | 导入外部网格模型       |
| `resource_spawner.sdf`  | 资源生成器             |
| `model_photo_shoot.sdf` | 模型拍摄（多角度渲染） |

---

## 触发与事件


| 文件                      | 说明         |
| --------------------------- | -------------- |
| `triggered_publisher.sdf` | 触发式发布器 |
| `pose_publisher.sdf`      | 位姿发布器   |
| `touch_plugin.sdf`        | 触摸触发插件 |

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim triggered_publisher.sdf
```

**查看触发事件**：

```bash
gz topic -e -t /triggered_publisher/topic
```

---

## Python 系统


| 文件                       | 说明                  |
| ---------------------------- | ----------------------- |
| `python_system_loader.sdf` | Python 系统加载器示例 |

**启动**：

```bash
cd gz-sim/examples/worlds
gz sim python_system_loader.sdf
```

运行前需设置环境变量：

```bash
export GZ_SIM_SYSTEM_PLUGIN_PATH=path_to_gazebo/examples/scripts/python_api/systems
export PYTHONPATH=path_to_colcon_workspace/install/lib/python:$PYTHONPATH
```

---

## 物理配置


| 文件                  | 说明             |
| ----------------------- | ------------------ |
| `physics_options.sdf` | 物理引擎选项配置 |

---

## 特殊场景


| 文件         | 说明     |
| -------------- | ---------- |
| `tunnel.sdf` | 隧道场景 |

---

## 通用工具命令

### 查看话题列表

```bash
gz topic -l
```

### 监听话题

```bash
gz topic -e -t /话题名称
```

### 调用服务

```bash
gz service -s /服务名称 --reqtype 类型 --reptype 类型 --timeout 超时 -r '数据'
```

### 发布消息

```bash
gz topic -t /话题名称 --msgtype 消息类型 -p '载荷'
```

---

## 快速参考


| 需求           | 推荐文件                                                  |
| ---------------- | ----------------------------------------------------------- |
| 学习传感器基础 | `camera_sensor.sdf`, `sensors.sdf`                        |
| 学习车辆控制   | `diff_drive.sdf`, `quadcopter.sdf`                        |
| 水下仿真       | `buoyancy.sdf`, `lrauv_control_demo.sdf`                  |
| 地形仿真       | `heightmap.sdf`, `dem_moon.sdf`                           |
| 多人协作       | `actor_crowd.sdf`, `actors_population.sdf.erb`            |
| 性能测试       | `3k_shapes.sdf`                                           |
| 调试可视化     | `debug_shapes.sdf`, `visualize_contacts.sdf`              |
| 日志回放       | `log_record_*.sdf`                                        |
| 导出数据       | `export_occupancy_grid.sdf`, `collada_world_exporter.sdf` |

---

## 运行方式

所有文件都在 `gz-sim/examples/worlds/` 目录下：

```bash
# 进入 worlds 目录
cd gz-sim/examples/worlds

# 运行单个场景
gz sim shapes.sdf

# 运行并暂停
gz sim -p empty.sdf

# 运行并立即开始（实时）
gz sim -r diff_drive.sdf

# 带 GUI 运行
gz sim empty_gui.sdf
```

或者使用完整路径（从项目根目录）：

```bash
# 运行单个场景
gz sim gz-sim/examples/worlds/shapes.sdf

# 运行并暂停
gz sim -p gz-sim/examples/worlds/empty.sdf

# 运行并立即开始（实时）
gz sim -r gz-sim/examples/worlds/diff_drive.sdf
```
