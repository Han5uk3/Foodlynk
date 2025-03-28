const { SecretManagerServiceClient } = require("@google-cloud/secret-manager");
const admin = require("firebase-admin");

async function getSecret() {
  const client = new SecretManagerServiceClient();
  const [version] = await client.accessSecretVersion({
    name: "projects/saver-app-2ae53/secrets/firebase-admin-key/versions/latest",
  });

  const serviceAccount = JSON.parse(version.payload.data.toString());

  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://saver-app-2ae53-default-rtdb.firebaseio.com",
  });

  const db = admin.firestore();
  const FieldValue = admin.firestore.FieldValue;

  module.exports = { admin, db, FieldValue };
}

getSecret().catch(console.error);
