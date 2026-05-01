// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:fit_flow/core/di/service_locator.dart';
import 'package:fit_flow/fit_flow_app.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('App boots into onboarding', (WidgetTester tester) async {
    setupDependencies();
    await tester.pumpWidget(const FitFlowApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Select Your Goal'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
