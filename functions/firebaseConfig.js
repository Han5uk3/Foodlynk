const admin = require("firebase-admin");
const serviceAccount = require("./saver-app-2ae53-firebase-adminsdk-fbsvc-7b8f13575b.json")
  // "/opt/render/project/src/saver-app-2ae53-firebase-adminsdk-fbsvc-7b8f13575b.json");  // Render's path

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://saver-app-2ae53-default-rtdb.firebaseio.com",
});

const db = admin.firestore();
const FieldValue = admin.firestore.FieldValue;

module.exports = { admin, db, FieldValue }; 