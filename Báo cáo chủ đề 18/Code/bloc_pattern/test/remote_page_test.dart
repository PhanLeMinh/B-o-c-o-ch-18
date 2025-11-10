import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_pattern/remote/remote_bloc.dart';
import 'package:bloc_pattern/remote/remote_event.dart';
import 'package:bloc_pattern/remote/remote_state.dart';
import 'package:bloc_pattern/remote/remote_page.dart';

void main() {
  testWidgets('CounterPage hiển thị và cập nhật đúng khi nhấn +',
      (WidgetTester tester) async {
    // Khởi tạo CounterBloc
    final bloc = CounterBloc();

    // Bọc widget bằng BlocProvider
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: const CounterPage(),
        ),
      ),
    );

    // Ban đầu phải hiển thị "Giá trị: 0"
    expect(find.text('Giá trị: 0'), findsOneWidget);

    // Giả lập nhấn nút cộng
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Kiểm tra hiển thị state mới
    expect(find.text('Giá trị: 1'), findsOneWidget);
  });
}
