const admin = require("firebase-admin");
const dotenv = require("dotenv");
dotenv.config();

// Use default Firebase credentials when running in Cloud Functions
// Only use service account file if it exists (for local development)
let credentialConfig;

try {
  credentialConfig = require("./saver-app-2ae53-firebase-adminsdk-fbsvc-a817628f88.json");
} catch (e) {
  // Service account file not found, will use default credentials
  console.log("Using default Firebase credentials from Cloud Functions environment");
  credentialConfig = undefined;
}

if (!admin.apps.length) {
  if (credentialConfig) {
    admin.initializeApp({
      credential: admin.credential.cert(credentialConfig),
    });
  } else {
    // Use default credentials (Application Default Credentials)
    admin.initializeApp();
  }
}

const db = admin.firestore();
const FieldValue = admin.firestore.FieldValue;

module.exports = { admin, db, FieldValue };