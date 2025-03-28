const axios = require("axios");
exports.compareOnePlate = async (req, res) => {
  try {
    const { imageUrl } = req.body;
    if (!imageUrl) {
      return res.status(400).json({ status: false });
    }
    const response = await axios.post(
      "https://food-detector-first.onrender.com/classify",
      { image_url: imageUrl }
    );
    return res.json(response.data);
  } catch (error) {
    return res.status(500).json({ status: false });
  }
};
