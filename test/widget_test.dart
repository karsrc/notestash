import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notestash/main.dart';

void main() {
  testWidgets('App launches and shows greeting', (WidgetTester tester) async {
    await tester.pumpWidget(GoalsPage());

    expect(find.textContaining('Good'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
  });
}