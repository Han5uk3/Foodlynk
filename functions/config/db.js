const admin = require("firebase-admin");
const serviceAccount = require("./saver-app-2ae53-firebase-adminsdk-fbsvc-a817628f88.json");

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
}

const db = admin.firestore();
const FieldValue = admin.firestore.FieldValue;

module.exports = { admin, db, FieldValue };