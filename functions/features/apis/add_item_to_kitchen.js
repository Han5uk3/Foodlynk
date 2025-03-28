const { v4: uuidv4 } = require("uuid");
const { admin, db } = require("../../config/db");
exports.addKitchenItem = async (req, res) => {
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
};

exports.removeItem = async (req, res) => {
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
};
