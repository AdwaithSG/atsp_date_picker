import 'package:flutter_test/flutter_test.dart';
import 'package:date_picker_app/main.dart'; // Make sure this matches your project name

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our HomePage button is displayed.
    expect(find.text('Go to Date Picker'), findsOneWidget);

    // Tap the button to navigate to the date picker.
    await tester.tap(find.text('Go to Date Picker'));
    await tester.pumpAndSettle();

    // Verify that the "Select Date" button is displayed on the new screen.
    expect(find.text('Select Date'), findsOneWidget);
  });
}
