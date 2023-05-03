import 'package:flutter_test/flutter_test.dart';
import 'package:whatsapp/app/app.dart';
import 'package:whatsapp/core/utils/responsive_layout.dart';

void main() {
  group('App', () {
    testWidgets('renders ResponsiveLayout', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(ResponsiveLayout), findsOneWidget);
    });
  });
}
