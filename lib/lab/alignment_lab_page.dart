import 'package:flutter/material.dart';

import 'package:profile_card/lab/align_scenes.dart';
import 'package:profile_card/lab/flex_experiment.dart';
import 'package:profile_card/lab/lab_common.dart';
import 'package:profile_card/lab/stack_container_scenes.dart';

/// 对齐任务卡：六种对齐场景 + 弹性分配实验 + 层叠角标 + 容器美化。
///
/// 每个场景卡都把关键参数直接画在界面上，截图即可完成「截图标注参数」。
class AlignmentLabPage extends StatelessWidget {
  const AlignmentLabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '对齐任务卡',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: const Color(0xFF312E81),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFFF1F5F9),
              Color(0xFFEEF2FF),
              Color(0xFFFDF4FF),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            key: const ValueKey<String>('lab-scroll'),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: const <Widget>[
              _LabIntro(),
              TextAlignScene(),
              RowColumnScene(),
              FlexScene(),
              WrapScene(),
              StackScene(),
              ContainerScene(),
              FlexExperimentSection(),
              _AiNote(),
            ],
          ),
        ),
      ),
    );
  }
}

/// 页首说明：六种场景索引 + 三层参考系。
class _LabIntro extends StatelessWidget {
  const _LabIntro();

  static const List<(String, String)> _index = <(String, String)>[
    ('场景 1', 'Text 自身对齐（textAlign）'),
    ('场景 2', 'Row / Column 主轴与交叉轴'),
    ('场景 3', 'Expanded / Spacer 弹性分配'),
    ('场景 4', 'Wrap 流式换行对齐'),
    ('场景 5', 'Stack / Positioned 层叠角标'),
    ('场景 6', 'Container 对齐与卡片美化'),
    ('实验', '三栏 2:1:1 + 一栏超长'),
  ];

  @override
  Widget build(BuildContext context) {
    return SceneCard(
      index: '总览',
      title: '六种对齐场景 + 弹性实验 + 层叠角标',
      point: '对齐永远先问「参考系是谁」：Text 的 textAlign 参考自己；Row / Column 的 main / cross 参考父容器给的空间；'
          'Container 的 alignment / Align 参考父容器的可用空间；Expanded 则是把父容器的剩余空间按 flex 切分。',
      params: const <String>[
        '参考系：自己 / 父容器 / 剩余空间',
        '每个场景卡顶部都标注了关键参数',
        '参数在截图里可直接看到，无需另做标注',
      ],
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (final (String index, String title) in _index)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 52,
                        child: Text(
                          index,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4338CA),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 11,
                            height: 1.4,
                            color: kInk,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// AI 使用标注（任务卡要求）。
class _AiNote extends StatelessWidget {
  const _AiNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kBorder),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'AI 使用标注',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: kInk,
            ),
          ),
          SizedBox(height: 6),
          Text(
            '仅使用 AI 辅助我理解知识点和辅助思考问题。'
            '布局代码、参数选择与截图验收均由我自己完成。',
            style: TextStyle(fontSize: 11.5, height: 1.6, color: kMuted),
          ),
        ],
      ),
    );
  }
}
