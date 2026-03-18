const GeminiAIService = require("../Ai/Gemini_Ai");
require("dotenv").config();

exports.generateSmartShoppingList = async (req, res) => {
  const { recipeName, noServings } = req.body;
  const apiKey = process.env.GEMINI_API_KEY;

  if (!apiKey) {
    return res.status(401).json({ error: "Gemini API key not configured" });
  }

  if (!recipeName || !noServings) {
    return res
      .status(400)
      .json({ error: "Missing recipeName or noServings" });
  }

  try {
    const prompt = `
You are a helpful shopping list assistant. I need to prepare "${recipeName}" for ${noServings} people.

Generate a comprehensive shopping list with ingredients needed for this recipe. Return the data in JSON format with **this exact structure**:

{
  "success": true,
  "data": {
    "ingredients": [
      {
        "name": "Ingredient Name",
        "quantity": "Quantity needed"
      }
    ]
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

    res.status(200).json(jsonData);
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({
      success: false,
      error: "Failed to generate shopping list",
      details: error.message,
    });
  }
};
