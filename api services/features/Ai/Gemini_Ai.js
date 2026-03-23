const { GoogleGenerativeAI } = require("@google/generative-ai");
const dotenv = require("dotenv");
const functions = require("firebase-functions");
dotenv.config();

class GeminiAIService {
  constructor(apiKey) {
    if (!apiKey) {
      throw new Error("API key missing or invalid");
    }
    this.genAI = new GoogleGenerativeAI(apiKey);
  }

  async generateText(prompt) {
    try {
      if (!prompt || prompt.trim() === "") {
        throw new Error("Prompt cannot be empty");
      }

      const model = this.genAI.getGenerativeModel({
        model: "gemini-1.5-flash",
      });

      const generationConfig = {
        temperature: 0.7,
        topK: 40,
        topP: 0.9,
        responseMimeType: "application/json",
      };

      const request = {
        contents: [
          {
            role: "user",
            parts: [{ text: prompt }],
          },
        ],
        generationConfig,
      };

      const result = await model.generateContent(request);

      return this.parseResponse(result);
    } catch (error) {
      console.error("Gemini AI Error:", error);

      if (error.message.includes("Invalid or empty AI response")) {
        console.error("Possible causes:");
        console.error("1. API key might be invalid");
        console.error("2. Network connectivity issues");
        console.error("3. Gemini service might be temporarily unavailable");
      }

      throw error;
    }
  }

  parseResponse(result) {
    if (!result || !result.response) {
      throw new Error("Invalid or empty AI response");
    }

    const response = result.response.text();

    if (!response) {
      throw new Error("No text content in AI response");
    }

    return response;
  }
}

module.exports = GeminiAIService;
