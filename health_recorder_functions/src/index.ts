/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onRequest} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();


// This function triggers when a new user is created
exports.createUserDocument = functions.auth.user().onCreate((user) => {
  // Get a reference to the user's document in Firestore
  const userDocRef = admin.firestore().collection('users').doc(user.uid);

  // Create a new document for the user
  return userDocRef.set({
    'username': user.displayName, // Set the username to the user's display name
    'healthPoints': 0, // Set the initial health points to 0
    // Add any other initial properties here
  });
});




//
// // This function triggers when a user records something
// exports.updateLeaderboard = functions.https.onCall((data, context) => {
//   // Verify that the user is authenticated
//   if (!context.auth) {
//     throw new functions.https.HttpsError('unauthenticated', 'The function must be called while authenticated.');
//   }
//
//   // Calculate the points (replace this with your actual calculation logic)
//   const points = calculatePoints(data);
//
//   // Get a reference to the user's document in the leaderboard collection
//   const docRef = admin.firestore().collection('leaderboard').doc(context.auth.uid);
//
//   // Update the user's points in Firestore
//   return docRef.update({ points: admin.firestore.FieldValue.increment(points) });
// });
//
// // Replace this function with your actual calculation logic
// function calculatePoints(data: any): number {
//   // Calculate the points based on the data
//   let points = 0;
//   // ... calculation logic here ...
//   return points;
// }






// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
