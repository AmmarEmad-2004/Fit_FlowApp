import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'app_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> runFlow(
    WidgetTester tester,
    String goalTitle,
    String availability,
  ) async {
    final robot = AppRobot(tester);
    await robot.launchApp();
    robot.expectOnboardingLoaded();
    await robot.selectGoal(goalTitle);
    await robot.selectAvailability(availability);
    if (availability == '3 Days') {
      robot.expectRecommendedVisible();
    }
    await robot.tapContinue();
    robot.expectHomeLoaded();
  }

  setUpAll(() async {
    await AppRobot.registerTestDependencies();
  });

  setUp(() {
    AppRobot.resetRouterAndSelection();
  });
  group("chose Build Muscle system with 2-5 days availability and navigate to home screen", () {
    testWidgets('onboarding flow navigates to home for 2 days', (tester) async {
      await runFlow(tester, 'Build Muscle', '2 Days');
    });

    testWidgets('onboarding flow navigates to home for 3 days', (tester) async {
      await runFlow(tester, 'Build Muscle', '3 Days');
    });

    testWidgets('onboarding flow navigates to home for 4 days', (tester) async {
      await runFlow(tester, 'Build Muscle', '4 Days');
    });

    testWidgets('onboarding flow navigates to home for 5+ days', (
      tester,
    ) async {
      await runFlow(tester, 'Build Muscle', '5+ Days');
    });
  });
}
