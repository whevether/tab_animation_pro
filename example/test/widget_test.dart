import 'package:flutter_test/flutter_test.dart';
import 'package:tab_animation_pro_example/main.dart';

void main() {
  testWidgets('example app loads home', (tester) async {
    await tester.pumpWidget(const TabExampleApp());
    expect(find.text('tab_animation_pro'), findsOneWidget);
    expect(find.text('3D switch'), findsOneWidget);
  });
}
