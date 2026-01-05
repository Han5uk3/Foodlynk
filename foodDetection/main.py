from flask import Flask, request, jsonify
import os
import sys
import traceback

print("Starting main.py", flush=True)

try:
    from app import classify_food_image as classify_single_image
    print("Imported classify_single_image", flush=True)
except Exception as e:
    print(f"Error importing classify_single_image: {e}", flush=True)
    print(traceback.format_exc(), flush=True)
    classify_single_image = None

try:
    from food_detection_api import classify_food_image as classify_for_comparison
    print("Imported classify_for_comparison", flush=True)
except Exception as e:
    print(f"Error importing classify_for_comparison: {e}", flush=True)
    print(traceback.format_exc(), flush=True)
    classify_for_comparison = None

main_app = Flask(__name__)

@main_app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "healthy"}), 200

@main_app.route("/classify", methods=["POST"])
def classify():
    if not classify_single_image:
        return jsonify({"error": "Service not initialized"}), 500
    
    data = request.json
    image_url = data.get("image_url")
    
    if not image_url:
        return jsonify({"status": "Error", "message": "Image URL is required"}), 400

    result = classify_single_image(image_url)
    return jsonify(result)

@main_app.route("/compare", methods=["POST"])
def compare():
    if not classify_for_comparison:
        return jsonify({"error": "Service not initialized"}), 500
    
    try:
        data = request.get_json()
        if not data or "image_url1" not in data or "image_url2" not in data:
            return jsonify({"error": "Invalid input. Both image URLs are required."}), 400

        image_url1 = data["image_url1"]
        image_url2 = data["image_url2"]

        first_result = classify_for_comparison(image_url1)
        second_result = classify_for_comparison(image_url2, is_second_image=True)

        final_result = first_result and second_result

        return jsonify({
            "status": bool(final_result),
        })

    except Exception as e:
        print(f"Error in compare: {e}", flush=True)
        print(traceback.format_exc(), flush=True)
        return jsonify({"error": "Internal Server Error", "details": str(e)}), 500

if __name__ == "__main__":
    from waitress import serve
    port = int(os.environ.get("PORT", 8080))
    print(f"Starting server on port {port}", flush=True)
    serve(main_app, host="0.0.0.0", port=port)
