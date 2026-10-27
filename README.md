# profile_card

lecture 6 作业：个人名片页 + 对齐任务卡。

## 页面

- **首页（个人名片）**：头像 / 姓名 / 签名 / 统计条 / 标签云，卡片圆角 + 阴影 + 留白，头像右下角 `Stack + Positioned` 在线徽标。
- **对齐任务卡**（首页 AppBar 右上角「对齐任务卡」进入）：
  1. 场景 1 · `Text(textAlign)` 自身对齐（3.1.1）
  2. 场景 2 · `Row / Column` 主轴与交叉轴（4.3）
  3. 场景 3 · `Expanded / Spacer` 弹性分配（4.4）
  4. 场景 4 · `Wrap` 流式换行对齐（4.5）
  5. 场景 5 · `Stack + Positioned` 层叠角标：头像徽标 + 图片浮层文字（4.6）
  6. 场景 6 · `Container` 对齐与卡片美化（5.4）
  7. 弹性分配实验：三栏 2:1:1，可切换「一栏超长 / 去掉 Expanded」观察表现

每一张场景卡都把关键参数（`flex`、`mainAxisAlignment`、`right: 4`…）直接标注在界面上，截图即自带参数说明。

## 目录

```
lib/main.dart                          名片页 + 入口
lib/lab/alignment_lab_page.dart        任务卡页面（总览 + AI 使用标注）
lib/lab/lab_common.dart                场景卡 / 参数标注 / 演示容器
lib/lab/align_scenes.dart              场景 1–4
lib/lab/stack_container_scenes.dart    场景 5–6
lib/lab/flex_experiment.dart           弹性分配实验
test/alignment_lab_test.dart           场景与实验的断言
test/screenshots_test.dart             生成 doc/screenshots 截图
doc/screenshots/*.png                  截图产物
TASK_CARD_REPORT.md                    任务卡实现与验收报告（含实测数据）
```

## 命令

```bash
flutter run
dart analyze lib test
flutter test
flutter test test/screenshots_test.dart   # 重新生成截图
```

AI 使用标注：**仅使用 AI 辅助我理解知识点和辅助思考问题。**
