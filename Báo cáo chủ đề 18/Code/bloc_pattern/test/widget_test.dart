import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Ban đầu phải có "Giá trị: 0"
    expect(find.text('Giá trị: 0'), findsOneWidget);
    expect(find.text('Giá trị: 1'), findsNothing);

    // Ấn nút cộng
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Kiểm tra sau khi ấn
    expect(find.text('Giá trị: 0'), findsNothing);
    expect(find.text('Giá trị: 1'), findsOneWidget);
  });
}
