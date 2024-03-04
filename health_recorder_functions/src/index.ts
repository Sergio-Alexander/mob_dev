
// import {onRequest} from "firebase-functions/v2/https";
// import * as logger from "firebase-functions/logger";
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

exports.createUserDocument = functions.auth.user().onCreate((user) => {
  const userDocRef = admin.firestore().collection("users").doc(user.uid);

  return userDocRef.set({
    "username": user.displayName || "Anonymous",
    "healthPoints": 0,
    // Add any other initial properties here
  });
});

