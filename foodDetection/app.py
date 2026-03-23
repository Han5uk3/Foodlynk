from flask import Flask, request, jsonify
import cv2
import numpy as np
import requests
import traceback

app = Flask(__name__)

def classify_food_image(image_url):
    try:
        print(f"[DEBUG] Classifying image: {image_url}", flush=True)
        
        response = requests.get(image_url, stream=True, timeout=15)
        if response.status_code != 200:
            print(f"[ERROR] Failed to fetch image. Status: {response.status_code}", flush=True)
            return {"status": False, "message": "Unable to fetch image!"}

        image_array = np.array(bytearray(response.content), dtype=np.uint8)
        image = cv2.imdecode(image_array, cv2.IMREAD_COLOR)
        if image is None:
            print("[ERROR] Image decoding failed!", flush=True)
            return {"status": False, "message": "Image decoding failed!"}

        print(f"[DEBUG] Image shape: {image.shape}", flush=True)
        
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        blurred = cv2.GaussianBlur(gray, (9, 9), 2)
        circles = cv2.HoughCircles(blurred, cv2.HOUGH_GRADIENT, dp=1.2, minDist=50,
                                   param1=100, param2=30, minRadius=50, maxRadius=350)

        if circles is None:
            print("[DEBUG] No plate detected", flush=True)
            return {"status": False, "message": "No Plate Detected"}

        circles = np.uint16(np.around(circles))
        (x, y, r) = circles[0][0]
        print(f"[DEBUG] Plate detected at ({x}, {y}) with radius {r}", flush=True)

        plate_mask = np.zeros_like(gray)
        cv2.circle(plate_mask, (x, y), r, 255, -1)
        plate_area = cv2.bitwise_and(image, image, mask=plate_mask)

        hsv = cv2.cvtColor(plate_area, cv2.COLOR_BGR2HSV)

        lower_food = np.array([5, 50, 50])
        upper_food = np.array([35, 255, 255])
        food_mask = cv2.inRange(hsv, lower_food, upper_food)

        plate_pixel_count = np.sum(plate_mask > 0)
        food_pixel_count = np.sum(food_mask > 0)
        food_coverage = food_pixel_count / plate_pixel_count if plate_pixel_count > 0 else 0

        lower_yellow = np.array([20, 100, 100])
        upper_yellow = np.array([30, 255, 255])
        yellow_mask = cv2.inRange(hsv, lower_yellow, upper_yellow)
        yellow_coverage = np.sum(yellow_mask > 0) / plate_pixel_count if plate_pixel_count > 0 else 0

        print(f"[DEBUG] Food coverage: {food_coverage:.2%}, Yellow coverage: {yellow_coverage:.2%}", flush=True)

        if yellow_coverage > 0.5:
            print("[DEBUG] Rejected: Too much yellow (likely empty plate)", flush=True)
            return {"status": False, "message": "Too much yellow detected"}

        if food_coverage > 0.2:
            print("[DEBUG] Accepted: Sufficient food coverage", flush=True)
            return {"status": True, "message": "Food detected"}
        else:
            print("[DEBUG] Rejected: Insufficient food coverage", flush=True)
            return {"status": False, "message": "Insufficient food coverage"}
    
    except Exception as e:
        error_msg = traceback.format_exc()
        print(f"[ERROR] Exception in classify_food_image: {error_msg}", flush=True)
        return {"status": False, "message": str(e), "error": "Exception occurred"}



@app.route('/classify', methods=['POST'])
def classify():
    try:
        data = request.json
        if not data:
            print("[ERROR] No JSON data provided", flush=True)
            return jsonify({"status": False, "message": "No JSON data"}), 400
        
        image_url = data.get("image_url")
        
        if not image_url:
            print("[ERROR] Image URL not provided", flush=True)
            return jsonify({"status": False, "message": "Image URL is required"}), 400

        print(f"[INFO] Processing classify request for: {image_url}", flush=True)
        result = classify_food_image(image_url)
        return jsonify(result)
    
    except Exception as e:
        error_msg = traceback.format_exc()
        print(f"[ERROR] Exception in /classify endpoint: {error_msg}", flush=True)
        return jsonify({"status": False, "message": "Internal server error", "error": str(e)}), 500