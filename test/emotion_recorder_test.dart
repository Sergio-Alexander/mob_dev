import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mob_dev/pages/emotion_recorder.dart';
import 'package:mob_dev/app_status.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Selecting an emoji adds it to the list', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (context) => RecordingState(),
          child: const Scaffold(body: EmotionRecorder()),
        ),
      ),
    );

    // open the dropdown menu
    await tester.tap(find.byIcon(Icons.arrow_drop_down));
    await tester.pumpAndSettle();

    // select emoji
    await tester.tap(find.text('😀').last);
    await tester.pumpAndSettle();

    // tap button to record the emotion
    await tester.tap(find.text('Place Emoji'));
    await tester.pumpAndSettle();

    // verify if the emoji appears in the list
    expect(find.text('😀'), findsWidgets);

    // verify if the datetime appears in the list
    expect(find.byType(ListTile), findsWidgets);
  });
}
