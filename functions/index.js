const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const app = express();
app.use(express.json());

const generateOTP = () => {
  return Math.floor(1000 + Math.random() * 9000).toString();
};

app.post("/send-otp", async (req, res) => {
  try {
    const { phoneNumber } = req.body;
    if (!phoneNumber) {
      return res.status(400).json({ error: "Phone number is required" });
    }
    const otp = generateOTP();
    try {
      const otpRef = admin.firestore().collection("otps").doc(phoneNumber);
      await otpRef.set({
        otp,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        // Five minutes to Expires the OTP
        expiresAt: admin.firestore.Timestamp.fromDate(
          new Date(Date.now() + 5 * 60 * 1000)
        ),
      });
      return res.status(200).json({
        message: "OTP sent successfully",
        otp: otp,
      });
    } catch (error) {
      console.log(`Error on Firebase API: ${error}`);
      res.status(500).json({ error: "Internal server error" });
    }
  } catch (error) {
    console.log(`Error on API: ${error}`);
    res.status(500).json({ error: "Internal server error" });
  }
});

app.post("/verify-otp", async (req, res) => {
  try {
    const { otp, phoneNumber } = req.body;
    if (!phoneNumber || !otp) {
      return res
        .status(400)
        .json({ error: "Phone number and OTP are required" });
    }
    try {
      const otpDoc = await admin
        .firestore()
        .collection("otps")
        .doc(phoneNumber)
        .get();
      if (!otpDoc.exists) {
        return res.status(404).json({ error: "OTP not found" });
      }
      const otpData = otpDoc.data();
      const currentTime = admin.firestore.Timestamp.now().toDate();
      const expiresAt = otpData.expiresAt.toDate();
      if (otpData.otp === otp && currentTime < expiresAt) {
        await otpDoc.ref.delete();
        return res.status(200).send({ message: "OTP verified successfully" });
      } else {
        return res.status(400).send({ error: "Invalid or expired OTP" });
      }
    } catch (error) {
      console.log(`Error on Firebase: ${error.message}`);
      res.status(500).json({ error: "Internal server error" });
    }
  } catch (error) {
    console.log(`Error on API: ${error}`);
    res.status(500).json({ error: "Internal server error" });
  }
});

exports.api = functions.https.onRequest(app);
