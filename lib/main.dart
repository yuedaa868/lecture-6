import 'package:flutter/material.dart';

const Color _ink = Color(0xFF111827);
const Color _muted = Color(0xFF6B7280);
const Color _primary = Color(0xFF4F46E5);

void main() {
  runApp(const ProfileCardApp());
}

class ProfileCardApp extends StatelessWidget {
  const ProfileCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '个人名片',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _primary),
        scaffoldBackgroundColor: const Color(0xFFEEF2FF),
      ),
      home: const ProfileCardPage(),
    );
  }
}

class ProfileCardPage extends StatelessWidget {
  const ProfileCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '个人名片',
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
            colors: [
              Color(0xFFEEF2FF),
              Color(0xFFEDE9FE),
              Color(0xFFFDF4FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: const ProfileCard(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 名片主体：头像区、姓名签名区、统计条、标签云。
class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('profile-card'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F4F46E5),
            blurRadius: 32,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _AvatarWithBadge(),
          const SizedBox(height: 18),
          const Text(
            '王跃达',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: _ink,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Flutter 开发者 · 把想法变成界面',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: _muted, height: 1.4),
          ),
          const SizedBox(height: 24),
          const StatsBar(),
          const SizedBox(height: 24),
          const TagCloud(),
        ],
      ),
    );
  }
}

/// 头像 + 右下角在线状态徽标。
class _AvatarWithBadge extends StatelessWidget {
  const _AvatarWithBadge();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const CircleAvatar(
          radius: 48,
          backgroundColor: _primary,
          child: Text(
            'WYD',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ),
        Positioned(
          right: 4,
          bottom: 4,
          child: Container(
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

/// 统计条：三块等分宽度，外层容器提供圆角与浅色底。
class StatsBar extends StatelessWidget {
  const StatsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('stats-bar'),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: StatItem(
              key: const ValueKey('stat-0'),
              value: '128',
              label: '项目',
            ),
          ),
          const _StatDivider(),
          Expanded(
            child: StatItem(
              key: const ValueKey('stat-1'),
              value: '12.6k',
              label: '关注',
            ),
          ),
          const _StatDivider(),
          Expanded(
            child: StatItem(
              key: const ValueKey('stat-2'),
              value: '4.9k',
              label: '获赞',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 30,
      color: const Color(0xFFDDD6FE),
    );
  }
}

class StatItem extends StatelessWidget {
  const StatItem({
    super.key,
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _primary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: _muted),
        ),
      ],
    );
  }
}

class TagCloud extends StatelessWidget {
  const TagCloud({super.key});

  static const List<String> tags = <String>[
    'Flutter',
    'Dart',
    '移动开发',
    'UI 设计',
    '开源',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      key: const ValueKey('tag-cloud'),
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final String tag in tags) _Tag(label: tag),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE0E7FF)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF4338CA),
        ),
      ),
    );
  }
}
