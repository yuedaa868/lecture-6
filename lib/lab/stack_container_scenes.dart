import 'package:flutter/material.dart';

import 'package:profile_card/lab/lab_common.dart';

// ---------------------------------------------------------------------------
// 场景 5：Stack + Positioned 层叠角标（对应课件 4.6）
// ---------------------------------------------------------------------------

class StackScene extends StatelessWidget {
  const StackScene({super.key});

  @override
  Widget build(BuildContext context) {
    return SceneCard(
      index: '场景 5',
      title: 'Stack + Positioned 层叠角标',
      point: 'Stack 里后放的孩子画在上层，Positioned 用 left / top / right / bottom 相对 Stack 四条边定位；'
          '角标要伸出 Stack 边界时，必须设 clipBehavior: Clip.none。',
      params: const <String>[
        'Stack(clipBehavior: Clip.none)',
        'Positioned(right: 4, bottom: 4)',
        'Positioned(right: -6, bottom: -6) 越界',
        'Positioned(left: 12, bottom: 12) 浮层文字',
      ],
      children: <Widget>[
        const DemoPane(
          label: '场景 A · 头像 + 右下角在线徽标（徽标完全落在头像内）',
          child: Row(
            children: <Widget>[
              AvatarBadgeDemo(key: ValueKey<String>('avatar-inside'), radius: 40, outside: false),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  '徽标 18×18，白边 3px，Positioned(right: 4, bottom: 4) 让它贴在头像右下角内侧。',
                  style: TextStyle(fontSize: 11, height: 1.5, color: kMuted),
                ),
              ),
            ],
          ),
        ),
        const DemoPane(
          label: '场景 A-2 · 徽标越界：Positioned(right: -6, bottom: -6) + Stack(clipBehavior: Clip.none)',
          child: Row(
            children: <Widget>[
              AvatarBadgeDemo(key: ValueKey<String>('avatar-outside'), radius: 40, outside: true),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  '不写 Clip.none 的话，越界的一半徽标会被裁掉。',
                  style: TextStyle(fontSize: 11, height: 1.5, color: kMuted),
                ),
              ),
            ],
          ),
        ),
        const DemoPane(
          label: '场景 B · 图片 + 浮层文字（底部半透明黑底文字条 + 右上角 NEW 角标）',
          child: _PhotoOverlayDemo(),
        ),
      ],
    );
  }
}

/// 头像 + 在线状态徽标。
class AvatarBadgeDemo extends StatelessWidget {
  const AvatarBadgeDemo({super.key, this.radius = 40, this.outside = false});

  final double radius;
  final bool outside;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        CircleAvatar(
          radius: radius,
          backgroundColor: kPrimary,
          child: Text(
            'WYD',
            style: TextStyle(
              fontSize: radius * 0.58,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ),
        Positioned(
          right: outside ? -6 : 4,
          bottom: outside ? -6 : 4,
          child: Container(
            key: const ValueKey<String>('badge-dot'),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
          ),
        ),
      ],
    );
  }
}

/// 「照片 + 浮层文字」：用渐变容器模拟图片，避免依赖网络图。
class _PhotoOverlayDemo extends StatelessWidget {
  const _PhotoOverlayDemo();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        key: const ValueKey<String>('photo-frame'),
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(0xFF6366F1),
                    Color(0xFFA855F7),
                    Color(0xFFEC4899),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'NEW',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFDB2777),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Container(
                key: const ValueKey<String>('photo-overlay'),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xB3000000),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '浮层标题写在图片之后',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Positioned(left: 12, right: 12, bottom: 12)',
                      style: TextStyle(fontSize: 10, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 场景 6：Container 对齐与卡片美化（对应课件 5.4）
// ---------------------------------------------------------------------------

class ContainerScene extends StatelessWidget {
  const ContainerScene({super.key});

  static const List<(String, Alignment)> _alignPairs = <(String, Alignment)>[
    ('topLeft', Alignment.topLeft),
    ('center', Alignment.center),
    ('bottomRight', Alignment.bottomRight),
  ];

  @override
  Widget build(BuildContext context) {
    return SceneCard(
      index: '场景 6',
      title: 'Container 对齐与卡片美化',
      point: 'Container 的 alignment 参考系是父容器约束出来的可用空间，只能在自己的地盘里摆孩子；'
          '圆角 + 阴影 + 留白就是卡片的三件套。',
      params: const <String>[
        'Container(alignment: Alignment.topLeft)',
        'borderRadius / boxShadow',
        'padding（内边距） vs margin（外边距）',
        'color 与 decoration 互斥',
      ],
      children: <Widget>[
        for (final (String label, Alignment value) in _alignPairs)
          DemoRow(
            label: 'alignment\n$label',
            child: _AlignmentSample(
              key: ValueKey<String>('container-align-$label'),
              alignment: value,
            ),
          ),
        const SizedBox(height: 6),
        const DemoPane(
          label: '美化 ① 白卡：borderRadius 24 + 阴影 blurRadius 24 / offset(0,10) + padding 18',
          child: _WhiteCardDemo(),
        ),
        const DemoPane(
          label: '美化 ② 渐变卡：圆角 20 + 橙红渐变 + transform 旋转（对应课件 5.4 的 5.20 卡）',
          child: _GradientCardDemo(),
        ),
        const DemoPane(
          label: '美化 ③ 统计条：圆角 18 + 浅紫底 + 上下内边距 14，margin 为 0',
          child: _StatsPillDemo(),
        ),
        const DemoPane(
          label: 'padding 与 margin：外层黄框是 margin 推出来的距离，紫色块是 padding 让出的空间',
          tinted: Color(0xFFFFFBEB),
          child: _PaddingMarginDemo(),
        ),
      ],
    );
  }
}

class _AlignmentSample extends StatelessWidget {
  const _AlignmentSample({super.key, required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return BorderedBox(
      height: 72,
      child: Container(
        alignment: alignment,
        child: Container(
          key: const ValueKey<String>('align-dot'),
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kPrimary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'A',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _WhiteCardDemo extends StatelessWidget {
  const _WhiteCardDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x1F4F46E5),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '白色圆角卡',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: kInk,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '圆角 24 · 阴影 0x1F4F46E5 / blur 24 / offset (0,10) · 内边距 18',
            style: TextStyle(fontSize: 11, height: 1.5, color: kMuted),
          ),
        ],
      ),
    );
  }
}

class _GradientCardDemo extends StatelessWidget {
  const _GradientCardDemo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.rotate(
        angle: -0.06,
        child: Container(
          width: 108,
          height: 108,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color(0xFFFB923C), Color(0xFFEF4444)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x40F97316),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: const Text(
            '5.20',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsPillDemo extends StatelessWidget {
  const _StatsPillDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: <Widget>[
          Expanded(child: _PillItem(value: '128', label: '项目')),
          Expanded(child: _PillItem(value: '12.6k', label: '关注')),
          Expanded(child: _PillItem(value: '4.9k', label: '获赞')),
        ],
      ),
    );
  }
}

class _PillItem extends StatelessWidget {
  const _PillItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: kPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 10.5, color: kMuted),
        ),
      ],
    );
  }
}

class _PaddingMarginDemo extends StatelessWidget {
  const _PaddingMarginDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E7FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFA5B4FC)),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kPrimary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          'margin: 10  →  padding: 12  →  内容',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
