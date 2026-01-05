const express = require("express");
const router = express.Router();
const api_controllers = require("../features/apis/add_item_to_kitchen");
const sendNotification_controller = require("../features/integrations/notifications");
const generateProteinPlan_controller = require("../features/integrations/generateProteinPlan");
const generateSmartRecipe_controller = require("../features/integrations/generateSmartRecipe");
const generateSmartShoppingList_controller = require("../features/integrations/generateSmartShoppingList");

router.post("/api-local/addItemToKitchen", api_controllers.addKitchenItem);
router.post("/api-local/removeItemFromKitchen", api_controllers.removeItem);
router.post("/api-features/sendNotification", sendNotification_controller.sendNotification);
router.post("/api-features/generate-protein-plan", generateProteinPlan_controller.generateProteinPlan);
router.post("/api-features/generate-smart-recipe", generateSmartRecipe_controller.generateSmartRecipe);
router.post("/api-features/generate-smart-shopping-list", generateSmartShoppingList_controller.generateSmartShoppingList);


module.exports = router;
