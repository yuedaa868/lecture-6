import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:profile_card/main.dart';

void main() {
  testWidgets('名片页在窄屏下正常渲染且无溢出', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProfileCardApp());
    await tester.pumpAndSettle();

    expect(find.text('王跃达'), findsOneWidget);
    expect(find.text('项目'), findsOneWidget);
    expect(find.text('关注'), findsOneWidget);
    expect(find.text('获赞'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('统计条三个数字块由 Expanded 等分宽度', (WidgetTester tester) async {
    await tester.pumpWidget(const ProfileCardApp());

    final List<double> widths = <double>[
      for (int i = 0; i < 3; i++)
        tester.getSize(find.byKey(ValueKey<String>('stat-$i'))).width,
    ];

    expect(widths[0], closeTo(widths[1], 0.5));
    expect(widths[1], closeTo(widths[2], 0.5));
  });
}
