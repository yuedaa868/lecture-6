import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:profile_card/lab/alignment_lab_page.dart';
import 'package:profile_card/lab/align_scenes.dart';
import 'package:profile_card/lab/flex_experiment.dart';
import 'package:profile_card/lab/stack_container_scenes.dart';
import 'package:profile_card/main.dart';

const Size _phone = Size(390, 844);

/// 把单个场景放进可滚动的页面里渲染，方便逐项断言。
Future<void> _pumpScene(
  WidgetTester tester,
  Widget scene, {
  Size size = _phone,
}) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: scene,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

double _paneWidth(WidgetTester tester, int index) {
  return tester
      .getSize(find.byKey(ValueKey<String>('flex-pane-$index')))
      .width;
}

void main() {
  testWidgets('场景 1 / 2 / 3 / 6 渲染无异常', (WidgetTester tester) async {
    final List<(String, Widget)> scenes = <(String, Widget)>[
      ('场景 1 Text 自身对齐', const TextAlignScene()),
      ('场景 2 Row/Column 对齐', const RowColumnScene()),
      ('场景 3 Expanded/Spacer', const FlexScene()),
      ('场景 6 Container 卡片', const ContainerScene()),
    ];
    for (final (String name, Widget scene) in scenes) {
      await _pumpScene(tester, scene);
      expect(tester.takeException(), isNull, reason: name);
    }
  });

  testWidgets('场景 4：Wrap 正常换行；对照用的 Row 会溢出并报警', (WidgetTester tester) async {
    await _pumpScene(tester, const WrapScene());
    final Object? error = tester.takeException();
    expect(error, isNotNull);
    expect(error.toString(), contains('overflowed'));
    debugPrint('【记录】Wrap 场景里故意用 Row 的对照示例：'
        '${error.toString().split('\n').first}');
  });

  testWidgets('场景 5：内侧徽标落在头像内，越界徽标伸到头像外', (WidgetTester tester) async {
    await _pumpScene(tester, const StackScene());

    Rect avatarOf(String key) => tester.getRect(
          find.descendant(
            of: find.byKey(ValueKey<String>(key)),
            matching: find.byType(CircleAvatar),
          ),
        );
    Rect badgeOf(String key) => tester.getRect(
          find.descendant(
            of: find.byKey(ValueKey<String>(key)),
            matching: find.byKey(const ValueKey<String>('badge-dot')),
          ),
        );

    final Rect avatarIn = avatarOf('avatar-inside');
    final Rect badgeIn = badgeOf('avatar-inside');
    expect(avatarIn.contains(badgeIn.center), isTrue);
    expect(badgeIn.right, lessThanOrEqualTo(avatarIn.right));
    expect(badgeIn.bottom, lessThanOrEqualTo(avatarIn.bottom));

    final Rect avatarOut = avatarOf('avatar-outside');
    final Rect badgeOut = badgeOf('avatar-outside');
    expect(badgeOut.right, greaterThan(avatarOut.right));
    expect(badgeOut.bottom, greaterThan(avatarOut.bottom));

    final Rect photo = tester.getRect(find.byKey(const ValueKey<String>('photo-frame')));
    final Rect overlay = tester.getRect(find.byKey(const ValueKey<String>('photo-overlay')));
    expect(photo.contains(overlay.center), isTrue);
    expect(overlay.bottom, lessThanOrEqualTo(photo.bottom));
    expect(overlay.left, greaterThan(photo.left));

    expect(tester.takeException(), isNull);
  });

  testWidgets('场景 6：Container 的 alignment 真的改变了孩子位置', (WidgetTester tester) async {
    await _pumpScene(tester, const ContainerScene());

    Rect dotOf(String label) => tester.getRect(
          find.descendant(
            of: find.byKey(ValueKey<String>('container-align-$label')),
            matching: find.byKey(const ValueKey<String>('align-dot')),
          ),
        );

    final Rect topLeft = dotOf('topLeft');
    final Rect center = dotOf('center');
    final Rect bottomRight = dotOf('bottomRight');

    expect(topLeft.left, lessThan(center.left));
    expect(topLeft.top, lessThan(center.top));
    expect(bottomRight.right, greaterThan(center.right));
    expect(bottomRight.bottom, greaterThan(center.bottom));

    expect(tester.takeException(), isNull);
  });

  testWidgets('实验：三栏宽度实测比例为 2 : 1 : 1', (WidgetTester tester) async {
    await _pumpScene(tester, const FlexExperimentSection());

    final double w0 = _paneWidth(tester, 0);
    final double w1 = _paneWidth(tester, 1);
    final double w2 = _paneWidth(tester, 2);

    expect(w0 / w1, closeTo(2.0, 0.12));
    expect(w1, closeTo(w2, 0.5));
    debugPrint('【记录】2:1:1 三栏实测宽度：'
        '${w0.toStringAsFixed(1)} / ${w1.toStringAsFixed(1)} / '
        '${w2.toStringAsFixed(1)} px');
    expect(tester.takeException(), isNull);
  });

  testWidgets('实验：一栏内容超长时该栏被撑高，但比例不变且不溢出',
      (WidgetTester tester) async {
    await _pumpScene(tester, const FlexExperimentSection());

    final double beforeHeight =
        tester.getSize(find.byKey(const ValueKey<String>('flex-pane-1'))).height;
    final double w0 = _paneWidth(tester, 0);

    await tester.tap(find.text('一栏超长'));
    await tester.pumpAndSettle();

    final Size tallPane =
        tester.getSize(find.byKey(const ValueKey<String>('flex-pane-1')));
    expect(tallPane.height, greaterThan(beforeHeight));
    expect(w0 / tallPane.width, closeTo(2.0, 0.12));

    debugPrint('【记录】超长内容那一栏高度：'
        '${beforeHeight.toStringAsFixed(1)} → '
        '${tallPane.height.toStringAsFixed(1)} px，宽度比例仍为 2 : 1 : 1');
    expect(tester.takeException(), isNull);
  });

  testWidgets('实验：去掉 Expanded 后 Row 溢出并打印 RenderFlex 警告',
      (WidgetTester tester) async {
    await _pumpScene(tester, const FlexExperimentSection());

    await tester.tap(find.text('去掉 Expanded'));
    await tester.pumpAndSettle();

    final Object? error = tester.takeException();
    expect(error, isNotNull);
    expect(error.toString(), contains('overflowed'));

    debugPrint('【记录】去掉 Expanded 后：'
        '${error.toString().split('\n').first}');
  });

  testWidgets('首页可以从 AppBar 进入对齐任务卡页面', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = _phone;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProfileCardApp());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(TextButton, '对齐任务卡'));
    await tester.pumpAndSettle();

    expect(find.byType(AlignmentLabPage), findsOneWidget);
    expect(find.text('总览'), findsOneWidget);
  });
}
