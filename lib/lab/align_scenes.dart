import 'package:flutter/material.dart';

import 'package:profile_card/lab/lab_common.dart';

/// 长文本样例，用来观察换行与溢出。
const String kLongText =
    '这是一段很长很长的项目描述，用来观察内容超长时 Row / Wrap 里其他栏会不会被挤压，'
    '以及整个布局的高度会不会被撑高。';

// ---------------------------------------------------------------------------
// 场景 1：Text 自身对齐（对应课件 3.1.1）
// ---------------------------------------------------------------------------

class TextAlignScene extends StatelessWidget {
  const TextAlignScene({super.key});

  @override
  Widget build(BuildContext context) {
    return SceneCard(
      index: '场景 1',
      title: 'Text 自身对齐',
      point: 'textAlign 的参考系只有 Text 自己：Text 有多宽，文字就在这段宽度里靠左 / 居中 / 靠右。'
          '所以先给它一个比内容更宽的框，才看得到差别。',
      params: const <String>[
        'Text(textAlign: TextAlign.left)',
        'Text(textAlign: TextAlign.center)',
        'Text(textAlign: TextAlign.right)',
        'Text(maxLines: 2, overflow: ellipsis)',
      ],
      children: <Widget>[
        const DemoRow(
          label: 'left',
          child: _AlignSample(align: TextAlign.left, maxWidth: 220),
        ),
        const DemoRow(
          label: 'center',
          child: _AlignSample(align: TextAlign.center, maxWidth: 220),
        ),
        const DemoRow(
          label: 'right',
          child: _AlignSample(align: TextAlign.right, maxWidth: 220),
        ),
        const DemoPane(
          label: '反例：Text 在 Row 里被收缩成「内容宽度」，此时 textAlign 看不出任何效果',
          tinted: Color(0xFFFFFBEB),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '王跃达 · Flutter 开发者',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 12.5, color: kInk, height: 1.45),
              ),
            ],
          ),
        ),
        const DemoPane(
          label: 'maxLines: 2 + overflow: TextOverflow.ellipsis（宽度 220）',
          child: _AlignSample(
            align: TextAlign.left,
            maxWidth: 220,
            text: kLongText,
            maxLines: 2,
            ellipsis: true,
          ),
        ),
      ],
    );
  }
}

class _AlignSample extends StatelessWidget {
  const _AlignSample({
    required this.align,
    required this.maxWidth,
    this.text = '王跃达 · Flutter 开发者',
    this.maxLines,
    this.ellipsis = false,
  });

  final TextAlign align;
  final double maxWidth;
  final String text;
  final int? maxLines;
  final bool ellipsis;

  @override
  Widget build(BuildContext context) {
    return BorderedBox(
      maxWidth: maxWidth,
      child: Text(
        text,
        textAlign: align,
        maxLines: maxLines,
        overflow: ellipsis ? TextOverflow.ellipsis : null,
        style: const TextStyle(fontSize: 12.5, color: kInk, height: 1.45),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 场景 2：Row / Column 的主轴与交叉轴（对应课件 4.3）
// ---------------------------------------------------------------------------

class RowColumnScene extends StatelessWidget {
  const RowColumnScene({super.key});

  static const List<(String, MainAxisAlignment)> _mainAxisPairs =
      <(String, MainAxisAlignment)>[
    ('start', MainAxisAlignment.start),
    ('center', MainAxisAlignment.center),
    ('end', MainAxisAlignment.end),
    ('spaceBetween', MainAxisAlignment.spaceBetween),
    ('spaceAround', MainAxisAlignment.spaceAround),
    ('spaceEvenly', MainAxisAlignment.spaceEvenly),
  ];

  static const List<(String, CrossAxisAlignment)> _crossAxisPairs =
      <(String, CrossAxisAlignment)>[
    ('start', CrossAxisAlignment.start),
    ('center', CrossAxisAlignment.center),
    ('end', CrossAxisAlignment.end),
    ('stretch', CrossAxisAlignment.stretch),
  ];

  @override
  Widget build(BuildContext context) {
    return SceneCard(
      index: '场景 2',
      title: 'Row / Column 主轴与交叉轴',
      point: 'mainAxisAlignment（主轴）/ crossAxisAlignment（交叉轴）的参考系是父容器给 Row / Column 的可用空间，'
          '不是子组件自己的宽度。',
      params: const <String>[
        'Row(mainAxisAlignment: ...)',
        'Column(crossAxisAlignment: ...)',
        'Row(mainAxisSize: max / min)',
      ],
      children: <Widget>[
        const Text(
          'Row 的主轴：mainAxisAlignment',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: kInk),
        ),
        const SizedBox(height: 6),
        for (final (String label, MainAxisAlignment value) in _mainAxisPairs)
          DemoRow(label: label, child: _MainAxisSample(alignment: value)),
        const SizedBox(height: 6),
        const Text(
          'Column 的交叉轴：crossAxisAlignment',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: kInk),
        ),
        const SizedBox(height: 6),
        for (final (String label, CrossAxisAlignment value) in _crossAxisPairs)
          DemoRow(label: label, child: _CrossAxisSample(alignment: value)),
      ],
    );
  }
}

class _MainAxisSample extends StatelessWidget {
  const _MainAxisSample({required this.alignment});

  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return BorderedBox(
      height: 34,
      child: Row(
        mainAxisAlignment: alignment,
        children: const <Widget>[
          _Square(color: Color(0xFF818CF8)),
          SizedBox(width: 4),
          _Square(color: Color(0xFFA78BFA)),
          SizedBox(width: 4),
          _Square(color: Color(0xFFF0ABFC)),
        ],
      ),
    );
  }
}

class _CrossAxisSample extends StatelessWidget {
  const _CrossAxisSample({required this.alignment});

  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return BorderedBox(
      height: 76,
      child: Column(
        crossAxisAlignment: alignment,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          _Bar(width: 96, color: Color(0xFF818CF8)),
          SizedBox(height: 4),
          _Bar(width: 64, color: Color(0xFFA78BFA)),
          SizedBox(height: 4),
          _Bar(width: 36, color: Color(0xFFF0ABFC)),
        ],
      ),
    );
  }
}

class _Square extends StatelessWidget {
  const _Square({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.width, required this.color});

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 场景 3：Expanded / Spacer 弹性分配（对应课件 4.4）
// ---------------------------------------------------------------------------

class FlexScene extends StatelessWidget {
  const FlexScene({super.key});

  @override
  Widget build(BuildContext context) {
    return SceneCard(
      index: '场景 3',
      title: 'Expanded / Spacer 弹性分配',
      point: 'Expanded 把 Row 的剩余空间按 flex 值切分，所以每一栏宽度都由 flex 决定，'
          '栏里的内容再长也不会把别人挤扁。Spacer 就是 Expanded(child: SizedBox.shrink())。',
      params: const <String>[
        'Expanded(flex: 2) : Expanded(flex: 1) : Expanded(flex: 1)',
        'Row 内每个栏后面标注了实测 px 宽度',
        'Spacer() = Expanded(child: SizedBox.shrink())',
      ],
      children: <Widget>[
        const DemoPane(
          label: '水平方向 2 : 1 : 1（宽度见各栏标注）',
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(flex: 2, child: _FlexSample(flex: 2, color: Color(0xFF4F46E5))),
              Expanded(flex: 1, child: _FlexSample(flex: 1, color: Color(0xFF22C55E))),
              Expanded(flex: 1, child: _FlexSample(flex: 1, color: Color(0xFFF59E0B))),
            ],
          ),
        ),
        const DemoPane(
          label: 'Spacer：把两个标签顶到两端',
          child: Row(
            children: <Widget>[
              ParamChip(text: '左侧标签'),
              Spacer(),
              ParamChip(text: '右侧标签', tinted: true),
            ],
          ),
        ),
        const DemoPane(
          label: '竖直方向也能用 Column + Expanded（10 : 14）',
          child: SizedBox(
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 10,
                  child: _FlexSample(flex: 10, color: Color(0xFF6366F1), vertical: true),
                ),
                Expanded(
                  flex: 14,
                  child: _FlexSample(flex: 14, color: Color(0xFF8B5CF6), vertical: true),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FlexSample extends StatelessWidget {
  const _FlexSample({
    required this.flex,
    required this.color,
    this.vertical = false,
  });

  final int flex;
  final Color color;
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final String size = vertical
            ? '${constraints.maxHeight.toStringAsFixed(0)} px'
            : '${constraints.maxWidth.toStringAsFixed(0)} px';
        return Container(
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          constraints: const BoxConstraints(minHeight: 38),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'flex: $flex',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                size,
                style: const TextStyle(fontSize: 10, color: Colors.white70),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// 场景 4：Wrap 流式换行（对应课件 4.5）
// ---------------------------------------------------------------------------

class WrapScene extends StatelessWidget {
  const WrapScene({super.key});

  static const List<String> _tags = <String>[
    'Flutter',
    'Dart',
    '移动开发',
    'UI 设计',
    '开源',
    '性能优化',
  ];

  @override
  Widget build(BuildContext context) {
    return SceneCard(
      index: '场景 4',
      title: 'Wrap 流式换行对齐',
      point: 'Row 在一行放不下会溢出并报 RenderFlex；Wrap 放不下就自动换行，'
          '每一行的对齐方式由 alignment 决定，行与行之间由 runSpacing 控制。',
      params: const <String>[
        'Wrap(alignment: WrapAlignment.start/center/end)',
        'spacing: 8（同列间距）',
        'runSpacing: 8（行间距）',
      ],
      children: <Widget>[
        for (final (String label, WrapAlignment value) in const <(String, WrapAlignment)>[
          ('start', WrapAlignment.start),
          ('center', WrapAlignment.center),
          ('end', WrapAlignment.end),
        ])
          DemoRow(
            label: 'Wrap\nalignment: $label',
            child: BorderedBox(
              maxWidth: 220,
              padding: const EdgeInsets.all(8),
              child: Wrap(
                alignment: value,
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  for (final String tag in _tags) ParamChip(text: tag),
                ],
              ),
            ),
          ),
        const DemoPane(
          label: '对照：同样内容放进 Row 会溢出（右上出现黄黑警示条），所以标签云用 Wrap',
          tinted: Color(0xFFFFFBEB),
          child: _OverflowRowPreview(),
        ),
      ],
    );
  }
}

/// 故意让 Row 溢出，展示黄黑警示条纹（仅用于对照教学）。
class _OverflowRowPreview extends StatelessWidget {
  const _OverflowRowPreview();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: Row(
        children: <Widget>[
          for (final String tag in WrapScene._tags)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ParamChip(text: tag, tinted: true),
            ),
        ],
      ),
    );
  }
}
