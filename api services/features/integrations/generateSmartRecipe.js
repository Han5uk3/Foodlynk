const GeminiAIService = require("../Ai/Gemini_Ai");
require("dotenv").config();

exports.generateSmartRecipe = async (req, res) => {
  const { ingredients } = req.body;
  const apiKey = process.env.GEMINI_API_KEY;

  if (!apiKey) {
    return res.status(401).json({ error: "Gemini API key not configured" });
  }

  if (!ingredients || !Array.isArray(ingredients) || ingredients.length === 0) {
    return res
      .status(400)
      .json({ error: "Missing or invalid ingredients array" });
  }

  try {
    const prompt = `
You are a professional recipe chef. Given the following ingredients: ${ingredients.join(", ")}.

Generate 3 creative recipes that can be made with these ingredients. For each recipe, provide the details in JSON format with **this exact structure**:

{
  "success": true,
  "data": {
    "recipes": [
      {
        "foodName": "Recipe Name",
        "cookingTime": "20 minutes",
        "steps": [
          {
            "step": 1,
            "instruction": "Step 1 instruction"
          },
          {
            "step": 2,
            "instruction": "Step 2 instruction"
          }
        ],
        "imageUrl": "https://via.placeholder.com/300"
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
      error: "Failed to generate recipes",
      details: error.message,
    });
  }
};
