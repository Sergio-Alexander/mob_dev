// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mob_dev/pages/workout_recorder.dart';
// import 'package:mob_dev/app_status.dart';
// import 'package:provider/provider.dart';
//
// void main() {
//   testWidgets('Logging a workout adds it to the list', (WidgetTester tester) async {
//     await tester.pumpWidget(
//       MaterialApp(
//         home: ChangeNotifierProvider(
//           create: (context) => RecordingState(),
//           child: const Scaffold(body: WorkoutRecorder()),
//         ),
//       ),
//     );
//
//     // open dropdown menu
//     await tester.tap(find.byIcon(Icons.arrow_drop_down));
//     await tester.pumpAndSettle();
//
//     // select exercise
//     await tester.tap(find.text('Bouldering').last);
//     await tester.pumpAndSettle();
//
//     // enter quantity
//     await tester.enterText(find.byType(TextField), '10');
//     await tester.pump();
//
//     // tap log button
//     await tester.tap(find.text('Log Workout'));
//     await tester.pumpAndSettle();
//
//     // verify if workout appears in list
//     bool isWorkoutLogged(Widget widget) {
//       if (widget is ListTile) {
//         final title = widget.title is Text ? (widget.title as Text).data : '';
//         final subtitle = widget.subtitle is Text ? (widget.subtitle as Text).data : '';
//         return title == 'Bouldering' && subtitle!.contains('10');
//       }
//       return false;
//     }
//
//     expect(find.byWidgetPredicate(isWorkoutLogged), findsOneWidget);
//   });
// }
