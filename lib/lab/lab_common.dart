import 'package:flutter/material.dart';

/// 任务卡统一配色。
const Color kInk = Color(0xFF111827);
const Color kMuted = Color(0xFF6B7280);
const Color kPrimary = Color(0xFF4F46E5);
const Color kBorder = Color(0xFFE2E8F0);
const Color kPaneTint = Color(0xFFF8FAFC);

/// 场景卡：编号 + 标题 + 一句话原理 + 参数标注 + 演示区。
///
/// 参数标注直接画在卡片上，所以截图即可完成「截图标注参数」。
class SceneCard extends StatelessWidget {
  const SceneCard({
    super.key,
    required this.index,
    required this.title,
    required this.point,
    required this.children,
    this.params = const <String>[],
  });

  final String index;
  final String title;
  final String point;
  final List<String> params;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  index,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4338CA),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: kInk,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            point,
            style: const TextStyle(fontSize: 12, color: kMuted, height: 1.5),
          ),
          if (params.isNotEmpty) ...<Widget>[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: <Widget>[
                for (final String param in params) ParamChip(text: param),
              ],
            ),
          ],
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

/// 参数标注小标签，例如 `flex: 2`、`textAlign: center`。
class ParamChip extends StatelessWidget {
  const ParamChip({super.key, required this.text, this.tinted = false});

  final String text;
  final bool tinted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tinted ? const Color(0xFFFFF7ED) : const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5,
          height: 1.2,
          fontWeight: FontWeight.w600,
          color: tinted ? const Color(0xFFB45309) : const Color(0xFF4338CA),
        ),
      ),
    );
  }
}

/// 演示区外框，可选左上角小标签。
class DemoPane extends StatelessWidget {
  const DemoPane({
    super.key,
    required this.child,
    this.label,
    this.tinted = kPaneTint,
  });

  final Widget child;
  final String? label;
  final Color tinted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: tinted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (label != null) ...<Widget>[
            Text(
              label!,
              style: const TextStyle(
                fontSize: 10.5,
                height: 1.4,
                color: kMuted,
              ),
            ),
            const SizedBox(height: 8),
          ],
          child,
        ],
      ),
    );
  }
}

/// 「左边参数名 + 右边演示」的一行，方便对照截图。
class DemoRow extends StatelessWidget {
  const DemoRow({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 86,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10.5,
                height: 1.3,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4338CA),
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// 带浅色边框的小盒子，用来显示「父约束给出的可用空间」。
class BorderedBox extends StatelessWidget {
  const BorderedBox({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.maxWidth,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    this.fill = Colors.white,
  });

  final Widget child;
  final double? height;
  final double? width;
  final double? maxWidth;
  final EdgeInsets padding;
  final Color fill;

  @override
  Widget build(BuildContext context) {
    final Widget box = Container(
      width: width ?? double.infinity,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kBorder),
      ),
      child: child,
    );
    if (maxWidth == null) {
      return box;
    }
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth!),
      child: box,
    );
  }
}
