import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:svg_optimizer_example/benchmarks/loading_svg_benchmark_app.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'benchmark svg on-screen loading',
    (WidgetTester widgetTester) async {
      runApp(const LoadingSvgBenchmarkApp());
      await binding.traceAction(
        () async {
          await widgetTester.pumpAndSettle();
          expect(find.byKey(picturesListKey), findsOne);
        },
        reportKey: 'loading_svgs',
      );
    },
  );
}
