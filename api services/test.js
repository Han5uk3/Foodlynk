const GeminiAIService = require('./features/Ai/Gemini_Ai.js');
const s = new GeminiAIService('AIzaSyAHcM9LqAYQEhvGANJZCkqF53PVuOvH4SQ');

const prompt = `You are a professional recipe chef. Given the following ingredients: apple, banana. Generate 3 creative recipes that can be made with these ingredients. For each recipe, provide the details in JSON format with **this exact structure**: { "success": true, "data": { "recipes": [ { "foodName": "Recipe Name", "cookingTime": "20 minutes", "steps": [ { "step": 1, "instruction": "Step 1" } ], "imageUrl": "https://via.placeholder.com/300" } ] } } Only return JSON without any other text.`;

s.generateText(prompt)
  .then(response => {
    try {
      const parsed = JSON.parse(response);
      console.log('IMAGES OUTPUT:', parsed.data.recipes.map(r => r.imageUrl));
    } catch (e) {
      console.error('PARSE ERROR:', e.message, "\nRAW:\n", response);
    }
  })
  .catch(e => console.error('ERROR:', e.message));
