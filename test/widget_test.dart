import 'package:flutter_test/flutter_test.dart';
import 'package:protekfm/main.dart'; // Ensure main.dart exists and contains MyApp

void main() {
  testWidgets('App launches correctly', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(MyApp());

    // Verify that "ProTekFM Reminders" is found in the UI
    expect(find.text('ProTekFM Reminders'), findsOneWidget);
  });
}
