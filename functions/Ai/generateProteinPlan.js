const express = require("express");
const dotenv = require("dotenv");
const cors = require("cors");
const functions = require("firebase-functions");
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors({ origin: true }));
const GeminiAIService = require("./Gemini_Ai");

async function generateProteinPlan(req, res) {
  const {
    whatAreYouCooking,
    toWhomAreYouCooking,
    numberOfServings,
    dietaryPreferences,
    ingredients,
  } = req.body;

  const apiKey = req.headers["x-api-key"];

  if (!apiKey) {
    return res.status(401).json({ error: "API key missing" });
  }

  if (
    !whatAreYouCooking ||
    !toWhomAreYouCooking ||
    !numberOfServings ||
    !dietaryPreferences ||
    !ingredients ||
    ingredients.length === 0
  ) {
    return res
      .status(400)
      .json({ error: "Missing or invalid required fields" });
  }

  try {
    const prompt = `
You are a helpful recipe assistant. 
I am cooking ${whatAreYouCooking} for ${toWhomAreYouCooking}. 
Number of people: ${numberOfServings}. 
Dietary preferences: ${dietaryPreferences}.
Ingredients available: ${ingredients.join(", ")}.

Please provide the following details in JSON format with **this exact structure**:
{
  "recipe": {
    "name": "Recipe Name",
    "ingredients": [
      { "item": "Ingredient Name", "quantity": "Quantity" },
      { "item": "Ingredient Name", "quantity": "Quantity" }
    ],
    "nutrition_per_serving": {
      "calories": "Calories",
      "protein": "Protein",
      "carbs": "Carbs"
    }
  }
}
Only return the JSON response without any other text or explanation.
`;
    const geminiService = new GeminiAIService(apiKey);
    const response = await geminiService.generateText(prompt);

    const jsonString = response.replace(/```json|```/g, "").trim();

    let jsonData;
    try {
      jsonData = JSON.parse(jsonString);
    } catch (parseError) {
      console.error("Failed to parse JSON:", parseError);
      return res.status(500).json({
        success: false,
        error: "Invalid JSON format received from Gemini.",
      });
    }

    const recipeData = jsonData.recipe || jsonData.breakfast;

    if (!recipeData) {
      return res.status(500).json({
        success: false,
        error: "Unexpected JSON structure. Missing recipe data.",
      });
    }

    const cleanNutritionalInfo = {
      calories:
        recipeData.nutrition_per_serving?.calories?.replace(
          /Approximately\s*/i,
          ""
        ) || "N/A",
      protein:
        recipeData.nutrition_per_serving?.protein?.replace(
          /Approximately\s*/i,
          ""
        ) || "N/A",
      carbs:
        recipeData.nutrition_per_serving?.carbs?.replace(
          /Approximately\s*/i,
          ""
        ) || "N/A",
    };

    const formattedIngredients = recipeData.ingredients
      ? recipeData.ingredients.map((ingredient) => ({
          name: ingredient.item || "Unknown Ingredient",
          quantity: ingredient.quantity || "N/A",
        }))
      : [];

    res.status(200).json({
      success: true,
      data: {
        recipeName: recipeData.name || "Unknown Recipe",
        noOfServings: numberOfServings,
        itemsFromKitchen: ingredients,
        ingredients: formattedIngredients,
        nutritionalInfo: cleanNutritionalInfo,
      },
    });
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({
      success: false,
      error: "Failed to generate text",
      details: error.message,
    });
  }
}

module.exports = generateProteinPlan;
