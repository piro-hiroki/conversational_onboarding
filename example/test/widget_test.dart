import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('example home renders template cards', (tester) async {
    await tester.pumpWidget(const ExampleApp());
    expect(find.text('Cal AI style'), findsOneWidget);
    expect(find.text('Duolingo style'), findsOneWidget);
    expect(find.text('Headspace style'), findsOneWidget);
  });
}
