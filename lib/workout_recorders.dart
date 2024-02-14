// // lib/workout_recorder.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:mob_dev/view_models/workout_recorder_view_model.dart';
// import 'package:mob_dev/app_status.dart';
//
// class WorkoutRecorder extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => WorkoutRecorderViewModel(Provider.of<RecordingState>(context)),
//       child: Consumer<WorkoutRecorderViewModel>(
//         builder: (context, viewModel, child) {
//           return Scaffold(
//             appBar: AppBar(
//               centerTitle: true,
//               title: const Text('Workout Recorder'),
//             ),
//             body: Column(
//               children: [
//                 const Text('Select Exercise'),
//                 DropdownButton<String>(
//                   value: viewModel.exercise,
//                   onChanged: (String? newValue) {
//                     if (newValue != null) {
//                       viewModel.updateExercise(newValue);
//                     }
//                   },
//                   items: viewModel.exerciseList.map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                 ),
//                 const Text('Quantity'),
//                 TextField(
//                   controller: viewModel.quantityController,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(
//                     hintText: 'Enter Reps',
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: viewModel.logWorkout,
//                   child: const Text('Log Workout'),
//                 ),
//                 ElevatedButton(
//                   onPressed: viewModel.clearWorkout,
//                   child: const Text('Clear Logs'),
//                 ),
//                 const Divider(),
//                 const Text('Workout Logs'),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: viewModel.workouts.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(viewModel.workouts[index]['exercise']),
//                         subtitle: Text(
//                           'Quantity: ${viewModel.workouts[index]['quantity']}',
//                           key: Key('quantity_${viewModel.workouts[index]['quantity']}'), // Add a key
//                         ),
//                         trailing: Text(
//                           'Logged on: ${viewModel.workouts[index]['datetime'].toString()}',
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }