var admin = require("firebase-admin");
const functions = require("firebase-functions/v1");
const path = require("path");
var serviceAccountProduction = require(path.join(
  __dirname,
  "saver-app-2ae53-firebase-adminsdk-fbsvc-411d629523.json"
));
admin.initializeApp();

exports.checkExpired = functions.pubsub
  .schedule("every 24 hours")
  .timeZone("Asia/Kolkata")
  .onRun(async (context) => {
    const db = admin.firestore();
    const now = new Date();
    let notificationCount = 0;
    const usersSnapshot = await db.collection("users").get();
    for (const userDoc of usersSnapshot.docs) {
      const userId = userDoc.id;
      const userData = userDoc.data();

      const fcmToken = userData.fcmToken || null;
      const kitchenItems = userData.kitchenItems || [];
      if (!fcmToken) {
        console.log(`🚫 No FCM token for user ${userId}, skipping.`);
        continue;
      }
      if (kitchenItems.length === 0) {
        console.log(`⚠️ No kitchen items found for user ${userId}`);
        continue;
      }
      for (const item of kitchenItems) {
        if (!item.expiredDate || !item.expiredDate._seconds) {
          console.log(
            `❌ Item ${item.name} has no valid expiry date, skipping.`
          );
          continue;
        }
        const expiryDate = new Date(item.expiredDate._seconds * 1000);
        const timeDiff = Math.ceil((expiryDate - now) / (1000 * 60 * 60 * 24));
        let messageBody = null;
        if (timeDiff < 0) {
          messageBody = `Your item ${item.name} has already expired!`;
        } else if (timeDiff === 3) {
          messageBody = `Reminder: Your item ${item.name} will expire in 3 days!`;
        } else if (timeDiff === 1) {
          messageBody = `Alert: Your item ${item.name} will expire tomorrow!`;
        } else if (timeDiff === 0) {
          messageBody = `Warning: Your item ${item.name} expires today!`;
        }
        if (messageBody) {
          await sendNotification(userId, fcmToken, item.name, messageBody);
          notificationCount++;
        }
      }
    }
    return null;
  });

async function sendNotification(userId, fcmToken, itemName, messageBody) {
  if (!fcmToken || fcmToken === "No FCM token") {
    console.log(`🚫 No FCM token for user ${userId}, skipping.`);
    return;
  }
  const message = {
    notification: { title: "Expiry Alert", body: messageBody },
    token: fcmToken,
  };
  try {
    await admin.messaging().send(message);
    await saveNotificationToFirestore(
      userId,
      "Expiry Alert",
      messageBody,
      "food"
    );
  } catch (error) {
    console.error(`❌ Failed to send notification to ${userId}:`, error);
  }
}

async function saveNotificationToFirestore(userId, title, body, type) {
  const db = admin.firestore();
  const notificationRef = db.collection("notifications").doc();
  const timestamp = Date.now();

  const notificationData = {
    notificationId: notificationRef.id,
    uid: userId,
    title: title,
    body: body,
    type: type,
    timestamp: timestamp,
  };

  try {
    await notificationRef.set(notificationData);
  } catch (error) {
    console.error("❌ Error saving notification to Firestore:", error);
  }
}
