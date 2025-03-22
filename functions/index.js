var serviceAccount = require("./saver-app-2ae53-firebase-adminsdk-fbsvc-a817628f88.json");
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const express = require("express");
const { v4: uuidv4 } = require("uuid");
const bodyParser = require("body-parser");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
const db = admin.firestore();
const app = express();
app.use(bodyParser.json());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.post("/addKitchenItem", async (req, res) => {
  const { uid, item } = req.body;
  if (!uid || !item) {
    return res
      .status(400)
      .json({ message: "Missing uid or item data", success: false });
  }
  try {
    const userDocRef = db.collection("users").doc(uid);
    const itemId = uuidv4();
    item.id = itemId;
    await userDocRef.update({
      kitchenItems: admin.firestore.FieldValue.arrayUnion(item),
      addedItemCount: admin.firestore.FieldValue.increment(1),
    });
    res.status(200).json({ success: true });
  } catch (error) {
    console.error("Error adding item:", error);
    res.status(500).json({ message: "Error adding item", success: false });
  }
});
app.post("/deleteKitchenItem", async (req, res) => {
  const { uid, itemId ,} = req.body;
  if (!uid || !itemId) {
    return res
      .status(400)
      .json({ message: "Missing uid or item id", success: false });
  }
  try {
    const userDocRef = db.collection("users").doc(uid);
    const userDoc = await userDocRef.get();
    console.log(userDoc.data());
    if (!userDoc.exists) {
      return res
        .status(404)
        .json({ message: "User not found", success: false });
    }

    const kitchenItems = userDoc.data().kitchenItems || [];
    const filteredItems = kitchenItems.filter((item) => item.id !== itemId);
    await userDocRef.update({ kitchenItems: filteredItems });
    res.status(200).json({ success: true });
  } catch (error) {
    console.error("Error deleting item:", error);
    res.status(500).json({ message: "Error deleting item", success: false });
  }
});
// exports.api = functions.https.onRequest(app);

// FUNCTIONS

app.listen(3000, (_) => console.log("3000"));
