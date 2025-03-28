const { onRequest, runWith } = require("firebase-functions/v2/https");
const express = require("express");
const dotenv = require("dotenv");
const bodyParser = require("body-parser");
const cors = require("cors");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const AppRouter = require("./Routes/app_routes");
const db = require("./config/db");
dotenv.config();
const app = express();
app.use(bodyParser.json());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors({ origin: true }));
app.use(AppRouter)
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
exports.api = onRequest({ timeoutSeconds: 300, memory: "512MB" }, app);