import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:cembostyle/moduls/auth/presentation/screens/lets_you_in_screen.dart';

void main() {
  testWidgets('welcome screen renders primary auth actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const GetMaterialApp(home: LetsYouInScreen()));

    expect(find.text('Welcome to Cembostyle'), findsOneWidget);
    expect(find.text('Create an Account'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });
}
