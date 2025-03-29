const { onRequest } = require("firebase-functions/v2/https");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const express = require("express");
const dotenv = require("dotenv");
const bodyParser = require("body-parser");
const cors = require("cors");
const AppRouter = require("./Routes/app_routes");
const { db } = require("./firebaseConfig");  // Firebase config

dotenv.config();
const app = express();

app.use(bodyParser.json());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors({ origin: true }));

// Route for Express app
app.use(AppRouter);

// Export the Express app
exports.api = onRequest(app); 

// Scheduled Function for Monthly Stats Reset
exports.resetMonthlyStatsScheduler = onSchedule("0 0 1 * *", async () => {
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