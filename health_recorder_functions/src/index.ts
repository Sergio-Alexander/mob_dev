
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
  });
});

exports.updatePoints = functions.https.onCall(async (data: Data, context) => {
  // Verify that the user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Please sign in");
  }

  // Get a reference to the user's document in Firestore
  const userDocRef =
  admin.firestore().collection("users").doc(context.auth.uid);

  // First, get the current points from the user's document
  const doc = await userDocRef.get();
  if (!doc.exists) {
    throw new functions.https.HttpsError("not-found", "User does not exist");
  }

  const currentUserPoints = doc.data()?.points || 0;

  // Calculate the points (replace this with your actual calculation logic)
  let pointsToUpdate = calculatePoints(data);

  // Check if the operation is a decrement and adjust if current points are <= 0
  if (data.decrement) {
    // Prevent decrement if points are 0 or would become negative
    if (currentUserPoints <= 0 || (currentUserPoints - pointsToUpdate) < 0) {
      pointsToUpdate = 0; // Or adjust as necessary for your logic
    } else {
      pointsToUpdate = -pointsToUpdate;
    }
  }

  // Update the user's points if we have a valid operation to perform
  if (pointsToUpdate !== 0) {
    return userDocRef.update({
      points: admin.firestore.FieldValue.increment(pointsToUpdate),
    });
  } else {
    // Return some message or indication that no operation was performed
    return {message: "No points update needed"};
  }
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
  await admin.firestore().collection("users").doc(userId).delete();

  // Delete the user from Firebase Auth
  await admin.auth().deleteUser(userId);

  return {success: true};
});

