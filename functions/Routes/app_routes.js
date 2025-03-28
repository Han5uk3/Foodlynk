const express = require("express");
const router = express.Router();
const api_controllers = require("../features/apis/add_item_to_kitchen");
const sendNotification_controller = require("../features/integrations/notifications");
const gemini_ai_controller = require("../features/integrations/generateProteinPlan");

router.post("/api-local/addItemToKitchen", api_controllers.addKitchenItem);
router.post("/api-local/removeItemFromKitchen", api_controllers.removeItem);
router.post("/api-features/sendNotification", sendNotification_controller.sendNotification);
router.post("/api-features/generate-protein-plan", gemini_ai_controller.generateProteinPlan);


module.exports = router;
