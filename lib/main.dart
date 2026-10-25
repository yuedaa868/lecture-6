import 'package:flutter/material.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
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
        title: const Text('个人名片'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: const ProfileCard(),
            ),
          ),
        ),
      ),
    );
  }
}

/// 名片主体：头像区、姓名签名区、统计条、标签云，仅负责结构与对齐。
class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircleAvatar(
          radius: 44,
          child: Icon(Icons.person, size: 44),
        ),
        const SizedBox(height: 16),
        Text(
          '李雨桐',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 6),
        Text(
          'Flutter 开发者 · 把想法变成界面',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        const StatsBar(),
        const SizedBox(height: 24),
        const TagCloud(),
      ],
    );
  }
}

/// 统计条：三块等分宽度，为后续装饰保留结构。
class StatsBar extends StatelessWidget {
  const StatsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatItem(
            key: const ValueKey('stat-0'),
            value: '128',
            label: '项目',
          ),
        ),
        Expanded(
          child: StatItem(
            key: const ValueKey('stat-1'),
            value: '12.6k',
            label: '关注',
          ),
        ),
        Expanded(
          child: StatItem(
            key: const ValueKey('stat-2'),
            value: '4.9k',
            label: '获赞',
          ),
        ),
      ],
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
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
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
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final String tag in tags) Chip(label: Text(tag)),
      ],
    );
  }
}
