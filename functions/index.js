var serviceAccount = require("./saver-app-2ae53-firebase-adminsdk-fbsvc-a817628f88.json");
const { onRequest, runWith } = require("firebase-functions/v2/https");
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const express = require("express");
const dotenv = require("dotenv");
const { v4: uuidv4 } = require("uuid");
const bodyParser = require("body-parser");
const cors = require("cors");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const generateProteinPlan = require("./Ai/generateProteinPlan");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
dotenv.config();
const db = admin.firestore();
const app = express();
app.use(bodyParser.json());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors({ origin: true }));

app.post("/generate-protein-plan", generateProteinPlan);
app.post("/addKitchenItem", async (req, res) => {
  const { uid, item } = req.body;
  if (!uid || !item) {
    return res
      .status(400)
      .json({ message: "Missing uid or item data", success: false });
  }
  try {
    const userDocRef = db.collection("users").doc(uid);
    const userDoc = await userDocRef.get();
    const currentCount = userDoc.exists
      ? userDoc.data().addedItemQuantityCount || 0
      : 0;
    const itemQuantityCount = parseInt(item.quantity) || 0;
    const newTotal = currentCount + itemQuantityCount;
    const itemId = uuidv4();
    item.id = itemId;
    await userDocRef.update({
      kitchenItems: admin.firestore.FieldValue.arrayUnion(item),
      addedItemQuantityCount: newTotal,
    });
    res.status(200).json({ success: true });
  } catch (error) {
    console.error("Error adding item:", error);
    res.status(500).json({ message: "Error adding item", success: false });
  }
});
app.post("/deleteKitchenItem", async (req, res) => {
  const { uid, itemId, isExpaired = false, noOfQuantity = 0 } = req.body;
  if (!uid || !itemId) {
    return res
      .status(400)
      .json({ message: "Missing uid or item id", success: false });
  }
  try {
    const userDocRef = db.collection("users").doc(uid);
    await db.runTransaction(async (transaction) => {
      const userDoc = await transaction.get(userDocRef);
      if (!userDoc.exists) {
        throw new Error("User not found");
      }
      const kitchenItems = userDoc.data().kitchenItems || [];
      const filteredItems = kitchenItems.filter((item) => item.id !== itemId);
      const updateData = { kitchenItems: filteredItems };
      if (!isExpaired) {
        const currentQuantity = userDoc.data().noOfQuantityRemoved || 0;
        const newQuantity = currentQuantity + noOfQuantity;
        updateData.noOfQuantityRemoved = newQuantity;
      }
      transaction.update(userDocRef, updateData);
    });
    res.status(200).json({ success: true });
  } catch (error) {
    console.error("Error deleting item:", error);
    res.status(500).json({ message: "Error deleting item", success: false });
  }
});
exports.resetMonthlyStatsScheduler = onSchedule("0 0 1 * *", async (event) => {
  await resetMonthlyStats();
});

const resetMonthlyStats = async () => {
  try {
    const usersSnapshot = await db.collection("users").get();

    for (const userDoc of usersSnapshot.docs) {
      const userDocRef = db.collection("users").doc(userDoc.id);

      await userDocRef.update({
        addedItemCount: 0,
        addedItemQuantityCount: 0,
      });
    }
    console.log("✅ Monthly stats reset successfully");
  } catch (error) {
    console.error("❌ Error resetting monthly stats:", error);
    throw new Error("Failed to reset monthly stats");
  }
};
exports.api = onRequest({ timeoutSeconds: 300, memory: "512MB" }, app);;
