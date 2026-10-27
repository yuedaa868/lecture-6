# 对齐任务卡 · 实现与验收报告

- 课程：移动应用软件开发 · lecture 6
- 工程：`profile_card`（Flutter 3.47.4 / Dart 3.13.3，Material 3）
- 入口：`flutter run` → 首页 AppBar 右上角 **「对齐任务卡」** → 任务卡页面
- 截图：`doc/screenshots/`（全部由 `test/screenshots_test.dart` 渲染生成，命令见文末）

---

## 0. 一页速览

| 任务卡要求 | 落地位置 | 截图 |
| --- | --- | --- |
| 六种对齐场景逐一实现并截图标注参数 | `lib/lab/align_scenes.dart`、`lib/lab/stack_container_scenes.dart`（场景 1–6） | `01` – `06` |
| 弹性分配实验：三栏 2:1:1 + 一栏超长表现记录 | `lib/lab/flex_experiment.dart` | `07` – `09` |
| 层叠角标：头像徽标 + 图片浮层文字 | `lib/lab/stack_container_scenes.dart`（场景 5） | `05` |
| 容器美化：卡片（圆角 / 阴影 / 留白）至少两处 | `lib/main.dart` 名片卡 + 场景 6 三张卡 | `00`、`06` |
| AI 使用标注 | 页面底部「AI 使用标注」+ 本报告第 6 节 | — |

> 每个场景卡都把**关键参数以 chip 的方式直接画在界面上**，所以截图本身就带参数标注，不需要再另外 P 图。

---

## 1. 六种对齐场景

### 场景 1 · Text 自身对齐（课件 3.1.1）

- 参考系：**Text 自己**。Text 有多宽，文字就在这段宽度里排。
- 参数：`Text(textAlign: TextAlign.left / center / right)`、`maxLines: 2`、`overflow: TextOverflow.ellipsis`
- 演示：三个等宽框（220 宽）里放同一句话，只改 `textAlign`，可看到文字位置递进；再给一个**反例**——Text 放进 `Row` 后被收缩成内容宽度，`textAlign` 完全看不出效果；最后演示 `maxLines: 2 + ellipsis` 的截断。
- 截图：`01_text_align.png`

### 场景 2 · Row / Column 的主轴与交叉轴（课件 4.3）

- 参考系：**父容器给 Row / Column 的可用空间**（不是子组件自己的宽度）。
- 参数：`Row(mainAxisAlignment: start / center / end / spaceBetween / spaceAround / spaceEvenly)`、`Column(crossAxisAlignment: start / center / end / stretch)`、`Row(mainAxisSize: max / min)`
- 演示：6 行主轴示例 + 4 行交叉轴示例，左边写参数值，右边放同色方块，横向对比。
- 截图：`02_row_column_align.png`

### 场景 3 · Expanded / Spacer 弹性分配（课件 4.4）

- 参数：`Expanded(flex: 2) : Expanded(flex: 1) : Expanded(flex: 1)`、`Spacer()`
- 演示：水平 2:1:1；每栏里用 `LayoutBuilder` 把**实测宽度**写在栏上（`152 px : 76 px : 76 px`）；`Spacer()` 把两个标签顶到两端；竖直方向 `Column + Expanded(10 : 14)` → `63 px : 88 px`。
- 截图：`03_expanded_flex.png`

### 场景 4 · Wrap 流式换行对齐（课件 4.5）

- 参考系：Wrap 自己的行宽；换行位置由子项宽度决定。
- 参数：`Wrap(alignment: WrapAlignment.start / center / end)`、`spacing: 8`、`runSpacing: 8`
- 演示：三个 220 宽的框里放同样的 6 个标签，只改 `alignment`，三行的换行与对齐差别一眼可见；最后放一个**对照**——同样内容塞进 `Row` 会溢出并出现黄黑警示条（390dp 宽实测 `overflowed by 108 pixels on the right`）。
- 截图：`04_wrap.png`

### 场景 5 · Stack + Positioned 层叠角标（课件 4.6）

- 参考系：Stack 的四条边；`Positioned` 用 `left / top / right / bottom` 定位，后放的孩子画在上层。
- 参数：`Stack(clipBehavior: Clip.none)`、`Positioned(right: 4, bottom: 4)`、`Positioned(right: -6, bottom: -6)`、`Positioned(left: 12, right: 12, bottom: 12)`
- 演示（两个层叠场景）：
  1. **头像徽标**：`CircleAvatar` + 18×18 绿色圆点，白边 3px；`right: 4, bottom: 4` 让徽标落在头像内；再给一个越界版本 `right: -6, bottom: -6`，说明必须 `Clip.none` 才不被裁掉。
  2. **图片浮层文字**：渐变「照片」+ 底部半透明黑底文字条（宽 100% - 24）+ 右上角 `NEW` 角标。
- 截图：`05_stack_overlay.png`

### 场景 6 · Container 对齐与卡片美化（课件 5.4）

- 参考系：**父容器约束出来的可用空间**，`alignment` 只能在自己的地盘里摆孩子。
- 参数：`Container(alignment: Alignment.topLeft / center / bottomRight)`、`borderRadius`、`boxShadow`、`padding` vs `margin`、`color` 与 `decoration` 互斥
- 演示：三个 72 高的框演示 `alignment` 三档位置；下面接三处美化卡片（见第 4 节）；最后用嵌套容器讲清 `margin: 10 → padding: 12 → 内容`。
- 截图：`06_container_card.png`

---

## 2. 弹性分配实验：三栏 2:1:1 ＋ 一栏内容超长

实验组件：`FlexExperimentSection`（`lib/lab/flex_experiment.dart`），三档可切换，栏内用 `LayoutBuilder` 显示实测宽度。

| 状态 | 做法 | 实测 / 现象 |
| --- | --- | --- |
| ① 2:1:1 正常 | 三栏 `Expanded(flex: 2 / 1 / 1)`，内容都短 | 宽度 **152.0 / 76.0 / 76.0 px** → 比例 **2.00 : 1.00 : 1.00**；高度 123 px；无告警 |
| ② 一栏内容超长 | 中间那栏换成不限行数的长文本 | 该栏在**栏内自动换行**，高度 **123.0 → 348.0 px**；`Row` 高度取最高那栏，另两栏因 `crossAxisAlignment: start` 贴顶、下方留白；**宽度比例仍是 2 : 1 : 1**，没有被挤压；**无溢出告警** |
| ③ 去掉 Expanded | 三个 `Expanded` 去掉，每栏固定 120 宽 | 三栏总宽 360 > Row 可用宽 306，右上角立刻出现**黄黑警示条**，控制台：`A RenderFlex overflowed by 56 pixels on the right` |

> 结论（口头解释）：`Expanded` 先按 flex 把 Row 的**剩余空间**切好，再让子组件填满这块空间，所以内容再长也只会在自己的栏里换行、撑高，不会把兄弟栏挤扁；去掉 `Expanded` 后子组件只能拿内容宽度，一旦总和超过可用宽度，`Row` 立刻溢出报警。

截图：`07_flex_ratio_2_1_1.png`、`08_flex_long_text.png`、`09_flex_no_expanded.png`

---

## 3. 层叠角标（两个场景）

| 场景 | 关键参数 | 结果 |
| --- | --- | --- |
| 头像在线徽标 | `Stack(clipBehavior: Clip.none)` + `Positioned(right: 4, bottom: 4)`，徽标 18×18、白边 3px | 徽标完全落在头像内（测试断言 `avatarRect.contains(badgeRect.center)`） |
| 徽标越界 | `Positioned(right: -6, bottom: -6)` + `Clip.none` | 徽标右/下边各伸出 6 px（测试断言 `badgeRect.right > avatarRect.right`） |
| 图片浮层文字 | `Positioned(left: 12, right: 12, bottom: 12)` 半透明黑底文字条 + `Positioned(top: 10, right: 10)` NEW 角标 | 文字条在图片内、距左边 12 px（测试断言 `overlay.left > photo.left`） |

截图：`05_stack_overlay.png`

---

## 4. 容器美化（三处卡片）

| 位置 | 圆角 | 阴影 | 留白 | 截图 |
| --- | --- | --- | --- | --- |
| ① 首页名片卡 | `borderRadius: 28` | `0x1F4F46E5 / blurRadius 32 / offset (0,16)` | `padding: 水平 24 · 垂直 28` | `00_profile_home.png` |
| ② 场景 6 白卡 | `borderRadius: 24` | `0x1F4F46E5 / blurRadius 24 / offset (0,10)` | `padding: 18` | `06_container_card.png` |
| ③ 场景 6 渐变卡 | `borderRadius: 20` + 橙红渐变 + `transform` 旋转 | `0x40F97316 / blurRadius 20 / offset (0,10)` | `108 × 108` 固定尺寸内居中 | `06_container_card.png` |
| ④ 统计条 | `borderRadius: 18` | 无（浅色底） | `padding: 水平 12 · 垂直 14`，`margin: 0` | `06_container_card.png` |

---

## 5. 自动化验收

```
dart analyze lib test     →  No issues found!
flutter test              →  All tests passed!（20 个用例）
```

`test/alignment_lab_test.dart` 覆盖：

1. 场景 1 / 2 / 3 / 6 渲染无异常；
2. 场景 4 的 `Wrap` 正常换行，对照用的 `Row` 溢出并报警（断言异常文案含 `overflowed`）；
3. 场景 5 内侧徽标在头像内、越界徽标伸到头像外、浮层文字在图片内；
4. 场景 6 的 `alignment` 三档真的改变了孩子位置（比较 `Rect`）；
5. 实验①：三栏宽度比 `closeTo(2.0, 0.12)`；
6. 实验②：超长栏变高且宽度比例不变、无异常；
7. 实验③：去掉 `Expanded` 后捕获 `RenderFlex overflowed`；
8. 首页 AppBar 可以进入任务卡页面。

---

## 6. AI 使用标注

**仅使用 AI 辅助我理解知识点和辅助思考问题。**

---

## 7. 复现方式

```bash
# 跑起来看页面
flutter run

# 静态检查 + 全部测试
dart analyze lib test
flutter test

# 重新生成 doc/screenshots 下的全部截图（无需真机，测试环境渲染 PNG）
flutter test test/screenshots_test.dart
```

> 截图脚本会加载系统中的中文字体（`simhei.ttf` / `Dengb.ttf`）并打开阴影绘制，所以生成的 PNG 与真机画面一致。
