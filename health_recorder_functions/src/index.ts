
// import {onRequest} from "firebase-functions/v2/https";
// import * as logger from "firebase-functions/logger";
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

interface Data {
  points?: number;
  increment?: number;
  decrement?: number;
}

exports.createUserDocument = functions.auth.user().onCreate((user) => {
  const userDocRef = admin.firestore().collection("users").doc(user.uid);

  return userDocRef.set({
    "username": user.displayName || "Anonymous",
    "points": 0,
    // Add any other initial properties here
  });
});

exports.updatePoints = functions.https.onCall((data: Data, context) => {
  // Verify that the user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Please sign in");
  }

  // Calculate the points (replace this with your actual calculation logic)
  const points = calculatePoints(data);

  // Get a reference to the user's document in Firestore
  const userDocRef =
  admin.firestore().collection("users").doc(context.auth.uid);

  if (data.increment) {
    return userDocRef.update({
      points: admin.firestore.FieldValue.increment(points),
    });
  } else if (data.decrement) {
    return userDocRef.update({
      points: admin.firestore.FieldValue.increment(-points),
    });
  }
  return null;
});

/**
 * Calculates the points based on the data.
 *
 * @param {Record<string, unknown>} data - The data.
 * @return {number} The calculated points.
 */
function calculatePoints(data: Data): number {
  // Calculate the points based on the data
  let points = 0;
  if (data.increment) {
    points = data.increment as number;
  }
  if (data.decrement) {
    points = data.decrement as number;
    if (data.points !== undefined && data.points <= 0) {
      points = 0;
    }
  }
  return points;
}

exports.deleteUserData = functions.https.onCall(async (data, context) => {
  // Ensure the user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Sign in first");
  }

  const userId = context.auth.uid;

  // Delete user documents from Firestore
  // Example: Delete a document in 'users' collection. Adapt as needed.
  await admin.firestore().collection("users").doc(userId).delete();

  // Delete the user from Firebase Auth
  await admin.auth().deleteUser(userId);

  return {success: true};
});

