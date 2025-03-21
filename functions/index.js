const functions = require("firebase-functions");
const admin = require("firebase-admin");
const express = require("express");
const multer = require("multer");
const sharp = require("sharp");
const fs = require("fs");
const pixelmatch = require("pixelmatch");
const PNG = require("pngjs").PNG;
const os = require("os");
const path = require("path");

admin.initializeApp();
const app = express();
app.use(express.json());

const upload = multer({ dest: os.tmpdir() });

/**
 * Image Comparison with threshold logic
 * 
 * Compares "before" (food-filled plate) and "after" (possibly empty plate) images
 * Returns true if the plate is empty after eating (high difference percentage)
 * Returns false if there's still food on the plate (low difference percentage)
 */
async function compareImages(beforePath, afterPath) {
  try {
    console.log("🟢 Starting image comparison...");

    const beforePngPath = path.join(os.tmpdir(), `before_${Date.now()}.png`);
    const afterPngPath = path.join(os.tmpdir(), `after_${Date.now()}.png`);

    console.log(`📷 Converting images to PNG with consistent resolution...`);

    // Resize both images to 600x600 for accuracy
    await Promise.all([
      sharp(beforePath).resize(600, 600).png().toFile(beforePngPath),
      sharp(afterPath).resize(600, 600).png().toFile(afterPngPath),
    ]);

    console.log("🔍 Running pixelmatch comparison...");

    const img1 = PNG.sync.read(fs.readFileSync(beforePngPath));
    const img2 = PNG.sync.read(fs.readFileSync(afterPngPath));

    const { width, height } = img1;
    const diff = new PNG({ width, height });

    // Perform the pixel comparison
    const diffPixels = pixelmatch(
      img1.data,
      img2.data,
      diff.data,
      width,
      height,
      { threshold: 0.1 } // Slightly increase threshold for better detection
    );

    const totalPixels = width * height;
    const diffPercentage = (diffPixels / totalPixels) * 100;

    console.log(`✅ Difference Pixels: ${diffPixels}`);
    console.log(`📊 Difference Percentage: ${diffPercentage.toFixed(2)}%`);

    // Clean up temporary images
    console.log("🧹 Cleaning up temporary images...");
    fs.unlinkSync(beforePngPath);
    fs.unlinkSync(afterPngPath);

    // Corrected Logic:
    // - High difference percentage (>70%) means the plate changed a lot (food eaten) -> plate is empty
    // - Low difference percentage means little change between before/after -> plate still has food
    const emptyThreshold = 70; // Threshold for determining empty plate
    const plateEmpty = diffPercentage > emptyThreshold;

    console.log(`🔎 Plate is ${plateEmpty ? "empty" : "not empty"}`);
    return plateEmpty;
  } catch (error) {
    console.error("❌ Error comparing images:", error);
    throw error;
  }
}

/**
 * Single image analysis to detect food on plate
 * 
 * Returns true if the plate is empty (high brightness percentage)
 * Returns false if the plate has food (low brightness percentage)
 */
async function detectFoodOnPlate(imagePath) {
  try {
    console.log("🟢 Starting plate analysis...");

    const pngPath = path.join(os.tmpdir(), `plate_${Date.now()}.png`);

    console.log(`📷 Converting image to PNG with consistent resolution...`);

    // Resize image to 600x600 for consistency
    await sharp(imagePath).resize(600, 600).png().toFile(pngPath);

    // Load the image into a buffer
    const imgBuffer = fs.readFileSync(pngPath);
    const img = await sharp(imgBuffer)
      .raw()
      .toBuffer({ resolveWithObject: true });

    const { data, info } = img;
    const { width, height } = info;

    console.log(`📏 Image Dimensions: ${width}x${height}`);

    let foodPixelCount = 0;
    let emptyPixelCount = 0;

    // Analyze the pixels
    const pixelSize = info.channels; // RGBA format (should be 3 or 4)
    for (let i = 0; i < data.length; i += pixelSize) {
      const r = data[i];
      const g = data[i + 1];
      const b = data[i + 2];

      // Calculate brightness of the pixel
      const brightness = (r + g + b) / 3;

      // Define brightness ranges for empty vs food detection
      if (brightness > 180) {
        emptyPixelCount++; // Brighter pixels → Empty plate
      } else {
        foodPixelCount++; // Darker pixels → Food present
      }
    }

    const totalPixels = width * height;
    const emptyPercentage = (emptyPixelCount / totalPixels) * 100;

    console.log(`🍽️ Empty Pixels: ${emptyPixelCount}`);
    console.log(`🍗 Food Pixels: ${foodPixelCount}`);
    console.log(`📊 Empty Percentage: ${emptyPercentage.toFixed(2)}%`);

    // Clean up temporary image
    console.log("🧹 Cleaning up temporary image...");
    fs.unlinkSync(pngPath);

    // Logic:
    // - If > 70% empty (bright) pixels → plate is empty
    // - Otherwise → plate has food
    const emptyThreshold = 70;
    const plateEmpty = emptyPercentage > emptyThreshold;

    console.log(`🔎 Plate is ${plateEmpty ? "empty" : "not empty"}`);
    return plateEmpty;
  } catch (error) {
    console.error("❌ Error analyzing image:", error);
    throw error;
  }
}

// Endpoint to compare before and after plate images
app.post(
  "/compare",
  upload.fields([{ name: "before" }, { name: "after" }]),
  async (req, res) => {
    console.log("🟢 Received image comparison request...");

    try {
      if (!req.files.before || !req.files.after) {
        console.warn("⚠️ Missing one or both images!");
        return res.status(400).json({ error: "Both images are required" });
      }

      const beforePath = req.files.before[0].path;
      const afterPath = req.files.after[0].path;

      console.log(
        `📁 Uploaded Files: Before: ${beforePath}, After: ${afterPath}`
      );

      const plateEmpty = await compareImages(beforePath, afterPath);

      // Clean up uploaded files
      console.log("🧹 Removing uploaded files...");
      fs.unlinkSync(beforePath);
      fs.unlinkSync(afterPath);

      console.log(`✅ Comparison completed. Plate Empty: ${plateEmpty}`);
      res.status(200).json({ 
        plate_empty: plateEmpty,
        message: plateEmpty ? "Plate is empty" : "Plate still has food"
      });
    } catch (error) {
      console.error("❌ Error processing request:", error);
      res
        .status(500)
        .json({ error: "Failed to process images", message: error.message });
    }
  }
);

// Endpoint to check if a single plate image is empty
app.post("/plateIsEmpty", upload.single("plate"), async (req, res) => {
  console.log("🟢 Received plate image analysis request...");

  try {
    if (!req.file) {
      console.warn("⚠️ No image uploaded!");
      return res.status(400).json({ error: "Image is required" });
    }

    const imagePath = req.file.path;

    console.log(`📁 Uploaded File: ${imagePath}`);

    const plateEmpty = await detectFoodOnPlate(imagePath);

    // Clean up uploaded image
    console.log("🧹 Removing uploaded image...");
    fs.unlinkSync(imagePath);

    console.log(`✅ Analysis completed. Plate Empty: ${plateEmpty}`);
    res.status(200).json({
      plate_empty: plateEmpty,
      message: plateEmpty ? "Plate is empty" : "Plate has food",
    });
  } catch (error) {
    console.error("❌ Error processing request:", error);
    res
      .status(500)
      .json({ error: "Failed to process image", message: error.message });
  }
});

// Export the Express app as a Firebase function
// exports.api = functions.https.onRequest(app);

// Local Server for Testing
// if (process.env.NODE_ENV !== 'production') {
  app.listen(3000, () => console.log("🚀 Listening on http://localhost:3000"));
// }