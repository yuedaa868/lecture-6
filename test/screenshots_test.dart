import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:profile_card/lab/align_scenes.dart';
import 'package:profile_card/lab/flex_experiment.dart';
import 'package:profile_card/lab/stack_container_scenes.dart';
import 'package:profile_card/main.dart';

/// 截图输出目录（相对项目根目录）。
const String _outDir = 'doc/screenshots';

/// 加载系统里的中文字体，否则测试环境会把文字渲染成方块。
Future<void> _loadFonts() async {
  const List<String> faces = <String>[
    r'C:\Windows\Fonts\simhei.ttf',
    r'C:\Windows\Fonts\Dengb.ttf',
  ];
  final FontLoader loader = FontLoader('Roboto');
  for (final String path in faces) {
    final File file = File(path);
    if (file.existsSync()) {
      loader.addFont(
        Future<ByteData>.value(ByteData.sublistView(file.readAsBytesSync())),
      );
    }
  }
  await loader.load();
}

/// 把一个场景渲染成 PNG。
Future<void> _capture(
  WidgetTester tester,
  String fileName,
  Widget scene, {
  double width = 390,
  double viewHeight = 4000,
  double dpr = 2,
}) async {
  tester.view.devicePixelRatio = dpr;
  tester.view.physicalSize = Size(width * dpr, viewHeight * dpr);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  // 测试环境默认关闭阴影，打开才能截到「阴影」这一层美化。
  debugDisableShadows = false;

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: RepaintBoundary(
            key: const ValueKey<String>('capture'),
            child: Container(
              width: width - 32,
              color: const Color(0xFFF1F5F9),
              child: scene,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  // 清掉故意的溢出异常（比如场景 4 的 Row 对照、实验的「去掉 Expanded」）。
  tester.takeException();

  final RenderRepaintBoundary boundary =
      tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const ValueKey<String>('capture')),
  );
  await tester.runAsync(() async {
    final ui.Image image = await boundary.toImage(pixelRatio: dpr);
    final ByteData? data = await image.toByteData(format: ui.ImageByteFormat.png);
    final File file = File('$_outDir/$fileName')
      ..createSync(recursive: true);
    file.writeAsBytesSync(data!.buffer.asUint8List());
    image.dispose();
  });
  debugDisableShadows = true;
}

void main() {
  setUpAll(() async {
    await _loadFonts();
  });

  testWidgets('截图 00：名片首页（容器美化实例 1）', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 2;
    tester.view.physicalSize = const Size(390 * 2, 844 * 2);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    debugDisableShadows = false;

    await tester.pumpWidget(
      const RepaintBoundary(
        key: ValueKey<String>('capture'),
        child: ProfileCardApp(),
      ),
    );
    await tester.pumpAndSettle();

    final RenderRepaintBoundary boundary =
        tester.renderObject<RenderRepaintBoundary>(
      find.byKey(const ValueKey<String>('capture')),
    );
    await tester.runAsync(() async {
      final ui.Image image = await boundary.toImage(pixelRatio: 2);
      final ByteData? data =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final File file = File('$_outDir/00_profile_home.png')
        ..createSync(recursive: true);
      file.writeAsBytesSync(data!.buffer.asUint8List());
      image.dispose();
    });
    debugDisableShadows = true;
  });

  testWidgets('截图 01：Text 自身对齐', (WidgetTester tester) async {
    await _capture(tester, '01_text_align.png', const TextAlignScene());
  });

  testWidgets('截图 02：Row / Column 对齐', (WidgetTester tester) async {
    await _capture(tester, '02_row_column_align.png', const RowColumnScene());
  });

  testWidgets('截图 03：Expanded / Spacer', (WidgetTester tester) async {
    await _capture(tester, '03_expanded_flex.png', const FlexScene());
  });

  testWidgets('截图 04：Wrap 换行', (WidgetTester tester) async {
    await _capture(tester, '04_wrap.png', const WrapScene());
  });

  testWidgets('截图 05：Stack 层叠角标', (WidgetTester tester) async {
    await _capture(tester, '05_stack_overlay.png', const StackScene());
  });

  testWidgets('截图 06：Container 对齐与卡片美化', (WidgetTester tester) async {
    await _capture(tester, '06_container_card.png', const ContainerScene());
  });

  testWidgets('截图 07：三栏 2:1:1 正常', (WidgetTester tester) async {
    await _capture(
      tester,
      '07_flex_ratio_2_1_1.png',
      const FlexExperimentSection(initialMode: FlexMode.ratio),
      viewHeight: 1600,
    );
  });

  testWidgets('截图 08：一栏内容超长', (WidgetTester tester) async {
    await _capture(
      tester,
      '08_flex_long_text.png',
      const FlexExperimentSection(initialMode: FlexMode.longText),
      viewHeight: 1600,
    );
  });

  testWidgets('截图 09：去掉 Expanded 溢出', (WidgetTester tester) async {
    await _capture(
      tester,
      '09_flex_no_expanded.png',
      const FlexExperimentSection(initialMode: FlexMode.noExpanded),
      viewHeight: 1600,
    );
  });
}
