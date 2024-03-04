// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class ELeaderboards extends StatefulWidget {
//   final LeaderboardService leaderboardService;
//
//   const ELeaderboards({Key? key, required this.leaderboardService}) : super(key: key);
//
//   @override
//   State<ELeaderboards> createState() => _ELeaderboardsState();
// }
//
// class _ELeaderboardsState extends State<ELeaderboards> {
//   Future<List<Map<String, dynamic>>> getGlobalLeaderboard() async {
//     return widget.leaderboardService.getGlobalLeaderboard();
//   }
//
//   Future<Map<String, dynamic>> getUserRank() async {
//     return widget.leaderboardService.getUserRank();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: FutureBuilder<List<Map<String, dynamic>>>(
//               future: getGlobalLeaderboard(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Text("Error: ${snapshot.error}");
//                 } else {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('Top 10 Users', style: Theme.of(context).textTheme.titleLarge),
//                       ),
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: snapshot.data?.length ?? 0,
//                           itemBuilder: (context, index) {
//                             var entry = snapshot.data![index];
//                             Widget? leadingIcon;
//                             if (index == 0) {
//                               leadingIcon = Icon(Icons.emoji_events, color: Colors.amber);
//                             } else if (index == 1) {
//                               leadingIcon = Icon(Icons.emoji_events, color: Colors.grey);
//                             } else if (index == 2) {
//                               leadingIcon = Icon(Icons.emoji_events, color: Colors.brown);
//                             }
//                             return ListTile(
//                               leading: leadingIcon,
//                               title: Text(entry["name"] ?? "Unknown"),
//                               trailing: Text('${entry["points"] ?? 0} pts'),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 }
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text('Your Rank', style: Theme.of(context).textTheme.titleLarge),
//           ),
//           FutureBuilder<Map<String, dynamic>>(
//             future: getUserRank(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return CircularProgressIndicator();
//               } else if (snapshot.hasError) {
//                 return Text("Error: ${snapshot.error}");
//               } else {
//                 return ListTile(
//                   title: Text(snapshot.data?["name"] ?? "N/A"),
//                   trailing: Text('${snapshot.data?["points"] ?? 0} pts'),
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// abstract class LeaderboardService {
//   Future<List<Map<String, dynamic>>> getGlobalLeaderboard();
//   Future<Map<String, dynamic>> getUserRank();
// }
//
// class FirebaseLeaderboardService implements LeaderboardService {
//   @override
//   Future<List<Map<String, dynamic>>> getGlobalLeaderboard() async {
//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .orderBy('ecoScore', descending: true)
//         .limit(10)
//         .get();
//     return snapshot.docs.map((doc) {
//       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//       return {
//         'name': data['username'] ?? 'N/A',
//         'points': data['ecoScore'] ?? 0,
//       };
//     }).toList();
//   }
//
//   @override
//   Future<Map<String, dynamic>> getUserRank() async {
//     return {"name": "You", "points": 50};
//   }
// }
//
// // mock data for testing
// class MockLeaderboardService implements LeaderboardService {
//   @override
//   Future<List<Map<String, dynamic>>> getGlobalLeaderboard() async {
//     // Simulate a network response with mock data
//     return List.generate(10, (index) => {
//       "name": "Mock User ${index + 1}",
//       "points": 100 - index * 10,
//     });
//   }
//
//   @override
//   Future<Map<String, dynamic>> getUserRank() async {
//     // Simulate a user rank with mock data
//     return {"name": "You", "points": 0};
//   }
// }


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeaderboardsPage extends StatefulWidget{
  @override
  _LeaderboardsPage createState() => _LeaderboardsPage();
}

class _LeaderboardsPage extends State<LeaderboardsPage> {
  @override

  Widget build(BuildContext context){
    return Scaffold();
  }
}