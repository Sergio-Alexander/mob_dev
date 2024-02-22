// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mob_dev/pages/diet_recorder.dart';
// import 'package:mob_dev/app_status.dart';
// import 'package:provider/provider.dart';
//
// void main() {
//   testWidgets('Recording food adds it to the dropdown list', (WidgetTester tester) async {
//     // Wrap the DietRecorder with the Provider
//     await tester.pumpWidget(
//       MaterialApp(
//         home: ChangeNotifierProvider(
//           create: (context) => RecordingState(),
//           child: const Scaffold(body: DietRecorder()),
//         ),
//       ),
//     );
//
//     // enter food
//     await tester.enterText(find.byType(TextField).first, 'Apple');
//
//     // enter amount
//     await tester.enterText(find.byType(TextField).last, '2');
//
//     // tap log button
//     await tester.tap(find.text('Log Food'));
//     await tester.pumpAndSettle();
//
//     // check if DropdownButton is rendered using its key
//     expect(find.byKey(const Key('foodDropdown')), findsOneWidget);
//
//     // open the dropdown
//     await tester.tap(find.byKey(const Key('foodDropdown')));
//     await tester.pumpAndSettle();
//
//     // check if apple is in the dropdown list
//     expect(find.text('Apple'), findsWidgets);
//   });
// }
