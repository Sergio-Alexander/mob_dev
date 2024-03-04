import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../firestore_models/users.dart';
import 'package:uuid/uuid.dart';

Future<void> setupFirestoreCollection() async {
  var usersCollectionRef = FirebaseFirestore.instance.collection('users');
  // Checking an arbitrary document to decide on initialization could be replaced
  // with a more robust check if needed, but we'll proceed with your approach
  var docSnapshot = await usersCollectionRef.doc('init_check').get();

  var uuid = Uuid();

  if (!docSnapshot.exists) {
    // Define the users with the provided names and points
    var usersData = [
      {'username': 'Ava Smith', 'points': 100},
      {'username': 'Liam Johnson', 'points': 100},
      {'username': 'Olivia Williams', 'points': 100},
      {'username': 'Noah Brown', 'points': 100},
      {'username': 'Emma Jones', 'points': 100},
      {'username': 'Oliver Garcia', 'points': 100},
      {'username': 'Amelia Miller', 'points': 100},
      {'username': 'Elijah Martinez', 'points': 100},
      {'username': 'Mia Rodriguez', 'points': 100},
      {'username': 'Lucas Davis', 'points': 100},
      {'username': 'Charlotte Lopez', 'points': 100},
      {'username': 'Ethan Wilson', 'points': 100},
      {'username': 'Sophia Anderson', 'points': 100},
      {'username': 'Logan Thomas', 'points': 100},
      {'username': 'Isabella Taylor', 'points': 100},
      {'username': 'Mason Moore', 'points': 100},
      {'username': 'Harper Jackson', 'points': 100},
      {'username': 'Benjamin Harris', 'points': 100},
      {'username': 'Aiden Clark', 'points': 100},
      {'username': 'Ella Lewis', 'points': 100},
    ];



    // Convert each user to a User object and add to Firestore
    for (var userData in usersData) {
      var user = User(
        id: uuid.v4(),
        username: userData['username'] as String,
        healthPoints: userData['healthPoints'] as int,
      );
      await usersCollectionRef.add(user.toMap());
    }

    // Mark initialization
    await usersCollectionRef.doc('init_check').set({'initialized': true});
  }
}
