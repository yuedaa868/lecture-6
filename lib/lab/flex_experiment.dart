import 'package:flutter/material.dart';

import 'package:profile_card/lab/align_scenes.dart' show kLongText;
import 'package:profile_card/lab/lab_common.dart';

/// 弹性分配实验的三种状态。
enum FlexMode {
  /// 正常：三栏 2:1:1，内容都较短。
  ratio,

  /// 中间一栏塞入超长内容，观察表现。
  longText,

  /// 故意去掉 Expanded，观察 Row 溢出。
  noExpanded,
}

/// 弹性分配实验：三栏 2:1:1 + 一栏内容超长时的表现记录。
class FlexExperimentSection extends StatefulWidget {
  const FlexExperimentSection({super.key, this.initialMode = FlexMode.ratio});

  final FlexMode initialMode;

  @override
  State<FlexExperimentSection> createState() => _FlexExperimentSectionState();
}

class _FlexExperimentSectionState extends State<FlexExperimentSection> {
  late FlexMode _mode = widget.initialMode;

  @override
  Widget build(BuildContext context) {
    return SceneCard(
      index: '实验',
      title: '弹性分配实验：三栏 2:1:1',
      point: '三栏都用 Expanded 包裹，flex 依次 2 : 1 : 1。切换下面三种状态，对比「正常 / 一栏超长 / 去掉 Expanded」。',
      params: <String>[
        'Expanded(flex: 2) : (flex: 1) : (flex: 1)',
        'Row(crossAxisAlignment: CrossAxisAlignment.start)',
        'Text(maxLines: 2, overflow: ellipsis)',
        '栏内数字 = LayoutBuilder 实测到的实际宽度',
      ],
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<FlexMode>(
            showSelectedIcon: false,
            segments: const <ButtonSegment<FlexMode>>[
              ButtonSegment<FlexMode>(
                value: FlexMode.ratio,
                label: Text('2:1:1 正常', style: TextStyle(fontSize: 11)),
              ),
              ButtonSegment<FlexMode>(
                value: FlexMode.longText,
                label: Text('一栏超长', style: TextStyle(fontSize: 11)),
              ),
              ButtonSegment<FlexMode>(
                value: FlexMode.noExpanded,
                label: Text('去掉 Expanded', style: TextStyle(fontSize: 11)),
              ),
            ],
            selected: <FlexMode>{_mode},
            onSelectionChanged: (Set<FlexMode> value) {
              setState(() => _mode = value.first);
            },
          ),
        ),
        const SizedBox(height: 12),
        DemoPane(
          label: _paneLabel,
          tinted: _mode == FlexMode.noExpanded
              ? const Color(0xFFFFFBEB)
              : kPaneTint,
          child: _buildRow(),
        ),
        _ResultNote(mode: _mode),
      ],
    );
  }

  String get _paneLabel {
    switch (_mode) {
      case FlexMode.ratio:
        return '三栏 Expanded(flex: 2 / 1 / 1)，内容都不长 → 比例稳定为 2 : 1 : 1';
      case FlexMode.longText:
        return '中间那栏塞入超长文本（不限行数）→ 观察栏高与其它两栏的位置';
      case FlexMode.noExpanded:
        return '故意去掉三个 Expanded（每栏固定宽 120）→ 观察 Row 溢出';
    }
  }

  Widget _buildRow() {
    switch (_mode) {
      case FlexMode.ratio:
        return const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: _Pane(
                key: ValueKey<String>('flex-pane-0'),
                caption: 'A · flex 2',
                tint: Color(0xFFEEF2FF),
                text: '内容较短',
              ),
            ),
            Expanded(
              flex: 1,
              child: _Pane(
                key: ValueKey<String>('flex-pane-1'),
                caption: 'B · flex 1',
                tint: Color(0xFFECFDF5),
                text: '内容较短',
              ),
            ),
            Expanded(
              flex: 1,
              child: _Pane(
                key: ValueKey<String>('flex-pane-2'),
                caption: 'C · flex 1',
                tint: Color(0xFFFFF7ED),
                text: '内容较短',
              ),
            ),
          ],
        );
      case FlexMode.longText:
        return const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: _Pane(
                key: ValueKey<String>('flex-pane-0'),
                caption: 'A · flex 2',
                tint: Color(0xFFEEF2FF),
                text: '内容较短',
              ),
            ),
            Expanded(
              flex: 1,
              child: _Pane(
                key: ValueKey<String>('flex-pane-1'),
                caption: 'B · flex 1',
                tint: Color(0xFFECFDF5),
                text: kLongText,
              ),
            ),
            Expanded(
              flex: 1,
              child: _Pane(
                key: ValueKey<String>('flex-pane-2'),
                caption: 'C · flex 1',
                tint: Color(0xFFFFF7ED),
                text: '内容较短',
              ),
            ),
          ],
        );
      case FlexMode.noExpanded:
        return const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 120,
              child: _Pane(
                key: ValueKey<String>('flex-pane-0'),
                caption: 'A · 固定 120 宽',
                tint: Color(0xFFEEF2FF),
                text: '内容较短',
              ),
            ),
            SizedBox(
              width: 120,
              child: _Pane(
                key: ValueKey<String>('flex-pane-1'),
                caption: 'B · 固定 120 宽',
                tint: Color(0xFFECFDF5),
                text: '内容较短',
              ),
            ),
            SizedBox(
              width: 120,
              child: _Pane(
                key: ValueKey<String>('flex-pane-2'),
                caption: 'C · 固定 120 宽',
                tint: Color(0xFFFFF7ED),
                text: '内容较短',
              ),
            ),
          ],
        );
    }
  }
}

/// 一栏：标注 flex 值 + LayoutBuilder 实测到的实际宽度。
class _Pane extends StatelessWidget {
  const _Pane({
    super.key,
    required this.caption,
    required this.tint,
    required this.text,
  });

  final String caption;
  final Color tint;
  final String text;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(minHeight: 96),
          decoration: BoxDecoration(
            color: tint,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                caption,
                style: const TextStyle(
                  fontSize: 10,
                  height: 1.3,
                  fontWeight: FontWeight.w700,
                  color: kInk,
                ),
              ),
              Text(
                '${constraints.maxWidth.toStringAsFixed(0)} px',
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.25,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4338CA),
                ),
              ),
              Text(
                '实测宽度',
                style: const TextStyle(
                  fontSize: 9,
                  height: 1.3,
                  color: kMuted,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                text,
                style: const TextStyle(fontSize: 10.5, height: 1.45, color: kMuted),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 每种状态对应的现象记录。
class _ResultNote extends StatelessWidget {
  const _ResultNote({required this.mode});

  final FlexMode mode;

  @override
  Widget build(BuildContext context) {
    final (String text, Color bg, Color fg) = switch (mode) {
      FlexMode.ratio => (
          '结果：三栏宽度严格按 2 : 1 : 1 分配（实测值见栏内标注）。'
              'Expanded 先把 Row 的剩余空间按 flex 切好，再让子组件填满，'
              '所以内容长短不影响分栏比例。',
          const Color(0xFFECFDF5),
          const Color(0xFF047857),
        ),
      FlexMode.longText => (
          '结果：B 栏不限行数的长文本在栏内自动换行，栏高被撑高；'
              'Row 的高度取最高那一栏，另两栏因 crossAxisAlignment: start 贴顶，下方留白。'
              '但三栏宽度比例仍是 2 : 1 : 1，没有被挤压。',
          const Color(0xFFFFF7ED),
          const Color(0xFFB45309),
        ),
      FlexMode.noExpanded => (
          '结果：去掉 Expanded 后每栏只能拿固定宽度，三栏总宽超过 Row 可用宽度，'
              '右上角立刻出现黄黑警示条，控制台打印 '
              'A RenderFlex overflowed by 56 pixels on the right（390dp 宽实测）。',
          const Color(0xFFFEF2F2),
          const Color(0xFFB91C1C),
        ),
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, height: 1.55, color: fg),
      ),
    );
  }
}
