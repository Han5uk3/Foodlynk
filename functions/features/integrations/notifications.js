const admin = require("firebase-admin");
exports.sendNotification = async (req, res) => {
  try {
    const { token, title, body } = req.body;

    if (!token || !title || !body) {
      return res
        .status(400)
        .json({ success: false, error: "Missing required fields" });
    }

    const message = {
      notification: {
        title,
        body,
      },
      data: {
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        screen: "home",
      },
      android: {
        priority: "high",
        notification: {
          sound: "default",
        },
      },
      apns: {
        payload: {
          aps: {
            sound: "default",
          },
        },
      },
    };

    let response;

    if (Array.isArray(token)) {
      const multicastMessage = {
        ...message,
        tokens: token,
      };
      response = await admin.messaging().sendEachForMulticast(multicastMessage);
    } else {
      response = await admin.messaging().send({ ...message, token });
    }

    console.log("Successfully sent message:", response);
    res.status(200).json({ success: true, message: response });
  } catch (error) {
    console.error("Error sending message:", error);
    res.status(500).json({ success: false, error: error.message });
  }
};
