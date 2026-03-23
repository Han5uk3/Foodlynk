import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'dart:io';
import 'dart:math' show sqrt, min, max;

class FoodDetectionService {
  /// Loads image from either local file path or URL
  static Future<img.Image?> _loadImageFromUrl(String imagePath) async {
    try {
      // Check if it's a local file path or URL
      if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
        // Download from URL
        final response = await http.get(Uri.parse(imagePath)).timeout(
              const Duration(seconds: 15),
              onTimeout: () => throw Exception('Image download timeout'),
            );

        if (response.statusCode != 200) {
          if (kDebugMode) {
            print('[FoodDetection] Failed to download image: ${response.statusCode}');
          }
          return null;
        }

        final image = img.decodeImage(response.bodyBytes);
        if (image == null) {
          if (kDebugMode) print('[FoodDetection] Failed to decode image');
          return null;
        }

        if (kDebugMode) print('[FoodDetection] Image loaded from URL: ${image.width}x${image.height}');
        return image;
      } else {
        // Load from local file
        final file = File(imagePath);
        if (!file.existsSync()) {
          if (kDebugMode) print('[FoodDetection] Local file not found: $imagePath');
          return null;
        }

        final bytes = await file.readAsBytes();
        final image = img.decodeImage(bytes);
        if (image == null) {
          if (kDebugMode) print('[FoodDetection] Failed to decode local image');
          return null;
        }

        if (kDebugMode) print('[FoodDetection] Image loaded from file: ${image.width}x${image.height}');
        return image;
      }
    } catch (e) {
      if (kDebugMode) print('[FoodDetection] Error loading image: $e');
      return null;
    }
  }

  /// Detects plate (circular/elliptical/rectangular) and analyzes food coverage
  static Future<bool> classifyFoodImage(String imageUrl) async {
    try {
      final image = await _loadImageFromUrl(imageUrl);
      if (image == null) return false;

      final plateRegion = _detectPlateRegion(image);
      
      late Map<String, double> plateAnalysis;
      
      if (plateRegion != null) {
        if (kDebugMode) {
          print('[FoodDetection] Plate detected: ${plateRegion['type']} '
              'center=(${plateRegion['centerX']},${plateRegion['centerY']}) '
              'size=${plateRegion['radiusX']}x${plateRegion['radiusY']}');
        }
        plateAnalysis = _analyzeFoodOnPlate(image, plateRegion);
      } else {
        if (kDebugMode) print('[FoodDetection] Plate detection failed, using center-crop fallback');
        plateAnalysis = _analyzeFoodCenterCropFallback(image);
      }

      final foodCoverage = plateAnalysis['foodCoverage']!;
      final textureDensity = plateAnalysis['textureDensity'] ?? 0.0;

      if (kDebugMode) {
        print('[FoodDetection] Food coverage: ${(foodCoverage * 100).toStringAsFixed(1)}%');
        print('[FoodDetection] Texture density: ${(textureDensity * 100).toStringAsFixed(1)}%');
      }

      final foodConcentration = plateAnalysis['foodConcentration'] ?? 1.0;
      final foodBrightnessStdDev = plateAnalysis['foodBrightnessStdDev'] ?? 0.0;

      if (kDebugMode) {
        print('[FoodDetection] Food concentration: ${(foodConcentration * 100).toStringAsFixed(1)}%');
        print('[FoodDetection] Food brightness std dev: ${foodBrightnessStdDev.toStringAsFixed(1)}');
      }

      // Accept if high food coverage by color (45%+ is clearly food)
      if (foodCoverage >= 0.45) {
        if (kDebugMode) print('[FoodDetection] Accepted: High food coverage ${(foodCoverage * 100).toStringAsFixed(1)}%');
        return true;
      }

      // For moderate food coverage (20-45%), apply additional checks:
      // - Reject if food is scattered (stain-like)
      // - Reject if food brightness is too uniform (flat stains vs 3D food)
      if (foodCoverage >= 0.20) {
        if (foodConcentration < 0.25) {
          if (kDebugMode) print('[FoodDetection] Rejected: Food appears scattered/stain-like (concentration=${(foodConcentration * 100).toStringAsFixed(1)}%)');
          return false;
        }
        if (foodBrightnessStdDev < 20.0) {
          if (kDebugMode) print('[FoodDetection] Rejected: Food brightness too uniform (stdDev=${foodBrightnessStdDev.toStringAsFixed(1)}) - likely stains not food');
          return false;
        }
        if (kDebugMode) print('[FoodDetection] Accepted: Food coverage ${(foodCoverage * 100).toStringAsFixed(1)}% with good variance');
        return true;
      }

      // Accept if high texture density (same-color food like white rice on white plate)
      // Texture density >= 12% indicates genuinely bumpy/textured surface = food present
      if (textureDensity >= 0.12) {
        if (kDebugMode) print('[FoodDetection] Accepted: High texture density ${(textureDensity * 100).toStringAsFixed(1)}% (same-color food detected)');
        return true;
      }
      
      if (kDebugMode) print('[FoodDetection] Rejected: Insufficient food coverage (${(foodCoverage * 100).toStringAsFixed(1)}%) and texture (${(textureDensity * 100).toStringAsFixed(1)}%)');
      return false;
    } catch (e) {
      if (kDebugMode) print('[FoodDetection] Error in classifyFoodImage: $e');
      return false;
    }
  }

  /// Classifies two images (before and after)
  static Future<bool> compareTwoPlates(String beforeImageUrl, String afterImageUrl) async {
    try {
      // Check before image (should have food)
      final beforeImage = await _loadImageFromUrl(beforeImageUrl);
      if (beforeImage == null) return false;

      final beforePlate = _detectPlateRegion(beforeImage);
      late Map<String, double> beforeAnalysis;
      
      if (beforePlate != null) {
        beforeAnalysis = _analyzeFoodOnPlate(beforeImage, beforePlate);
      } else {
        beforeAnalysis = _analyzeFoodCenterCropFallback(beforeImage);
      }
      
      final beforeFoodCoverage = beforeAnalysis['foodCoverage']!;
      final beforeTexture = beforeAnalysis['textureDensity'] ?? 0.0;

      final beforeConcentration = beforeAnalysis['foodConcentration'] ?? 1.0;
      final beforeBrightnessStdDev = beforeAnalysis['foodBrightnessStdDev'] ?? 0.0;

      // Before image must have food: either by color difference OR texture
      bool beforeValid;
      if (beforeFoodCoverage >= 0.45) {
        beforeValid = true; // High coverage = clearly food
      } else if (beforeFoodCoverage >= 0.20) {
        // Moderate coverage: check for stains
        if (beforeConcentration < 0.25) {
          beforeValid = false; // Scattered stains
        } else if (beforeBrightnessStdDev < 20.0) {
          beforeValid = false; // Flat stains (uniform brightness)
        } else {
          beforeValid = true;
        }
      } else {
        beforeValid = beforeTexture >= 0.12; // Same-color food via texture
      }

      if (kDebugMode) {
        print('[FoodDetection] Before image - Food: ${(beforeFoodCoverage * 100).toStringAsFixed(1)}%, Texture: ${(beforeTexture * 100).toStringAsFixed(1)}%, Valid: $beforeValid');
      }

      if (!beforeValid) return false;

      // Check after image (should be empty/eaten)
      final afterImage = await _loadImageFromUrl(afterImageUrl);
      if (afterImage == null) return false;

      final afterPlate = _detectPlateRegion(afterImage);
      late Map<String, double> afterAnalysis;
      
      if (afterPlate != null) {
        afterAnalysis = _analyzeFoodOnPlate(afterImage, afterPlate);
      } else {
        afterAnalysis = _analyzeFoodCenterCropFallback(afterImage);
      }
      
      final afterFoodCoverage = afterAnalysis['foodCoverage']!;
      final afterTexture = afterAnalysis['textureDensity'] ?? 0.0;

      // After image must show a CLEAN plate.
      // Use texture density as the primary indicator:
      // - Clean plate (any color/finish) = smooth surface = texture < 10%
      //   (glossy plates can have up to 7-8% from reflections)
      // - Plate with food remnants/crumbs = bumpy = texture > 10%
      // Food coverage is unreliable for colored plates (highlights/rim get flagged),
      // so we don't rely on it for the after check.
      bool afterValid = afterTexture < 0.10;

      if (kDebugMode) {
        print('[FoodDetection] After image - Food: ${(afterFoodCoverage * 100).toStringAsFixed(1)}%, Texture: ${(afterTexture * 100).toStringAsFixed(1)}%, Valid: $afterValid');
      }

      return beforeValid && afterValid;
    } catch (e) {
      if (kDebugMode) print('[FoodDetection] Error in compareTwoPlates: $e');
      return false;
    }
  }

  // ============================================================
  //  PLATE DETECTION
  // ============================================================

  /// Main plate detection: tries multiple approaches
  static Map<String, dynamic>? _detectPlateRegion(img.Image image) {
    // Strategy 1: Color-based region detection (most reliable for colored plates)
    final colorPlate = _detectPlateByColor(image);
    if (colorPlate != null) {
      if (kDebugMode) print('[FoodDetection] Plate found via color clustering');
      return colorPlate;
    }

    // Strategy 2: Edge-based circle detection (Hough-like)
    final gray = _toGrayscale(image);
    final blurred = img.gaussianBlur(gray, radius: 4);
    final edgePlate = _detectPlateByEdges(blurred, image);
    if (edgePlate != null) {
      if (kDebugMode) print('[FoodDetection] Plate found via edge detection');
      return edgePlate;
    }

    return null;
  }

  /// Detect plate by finding a large uniform-color region
  /// Works well for colored plates (yellow, blue, white, etc.)
  static Map<String, dynamic>? _detectPlateByColor(img.Image image) {
    final w = image.width;
    final h = image.height;

    // Step 1: Build a color histogram using buckets (bucket size = 25)
    // Use a sampling grid for speed
    const bucketSize = 25;
    final Map<String, _ColorBucket> buckets = {};
    const step = 3;

    for (int y = 0; y < h; y += step) {
      for (int x = 0; x < w; x += step) {
        final pixel = image.getPixelSafe(x, y);
        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();

        final key = '${r ~/ bucketSize},${g ~/ bucketSize},${b ~/ bucketSize}';
        final bucket = buckets.putIfAbsent(key, () => _ColorBucket(
          ((r ~/ bucketSize) * bucketSize + bucketSize ~/ 2).clamp(0, 255),
          ((g ~/ bucketSize) * bucketSize + bucketSize ~/ 2).clamp(0, 255),
          ((b ~/ bucketSize) * bucketSize + bucketSize ~/ 2).clamp(0, 255),
        ));
        bucket.count++;
        bucket.sumX += x;
        bucket.sumY += y;
      }
    }

    // Step 2: Sort buckets by size, find the largest ones
    final sortedBuckets = buckets.values.toList()
      ..sort((a, b) => b.count.compareTo(a.count));

    if (sortedBuckets.isEmpty) return null;

    final totalSamples = sortedBuckets.fold<int>(0, (sum, b) => sum + b.count);

    // Step 3: Evaluate top color clusters as potential plate candidates
    // Score each by plate-likeness (fill ratio, centrality, size) and pick the best
    Map<String, dynamic>? bestPlate;
    double bestScore = -1;

    for (int i = 0; i < min(6, sortedBuckets.length); i++) {
      final candidate = sortedBuckets[i];
      final ratio = candidate.count / totalSamples;

      // Plate color should be at least 5% of image but not more than 75%
      if (ratio < 0.05 || ratio > 0.75) continue;

      // Skip very dark colors (shadows / black background)
      if (candidate.r < 30 && candidate.g < 30 && candidate.b < 30) continue;

      // Try to find the region of this color
      final region = _findColorRegion(image, candidate.r, candidate.g, candidate.b, bucketSize + 10);
      if (region == null) continue;

      final regionW = region['maxX']! - region['minX']!;
      final regionH = region['maxY']! - region['minY']!;
      if (regionW < 1 || regionH < 1) continue;

      final regionArea = region['pixelCount']!;
      final imageArea = w * h;
      if (regionArea < imageArea * 0.05) continue;

      final bboxArea = regionW * regionH;
      final fillRatio = regionArea / bboxArea;
      if (fillRatio < 0.35) continue;

      // Reject if bounding box spans too much of the image
      final widthCoverage = regionW / w;
      final heightCoverage = regionH / h;
      // If BOTH dimensions > 85%, definitely background
      if (widthCoverage > 0.85 && heightCoverage > 0.85) continue;
      // If EITHER dimension > 70%, require high fill ratio (compact plate)
      // This catches cases where plate detection includes table/background items
      if ((widthCoverage > 0.70 || heightCoverage > 0.70) && fillRatio < 0.60) continue;

      final aspect = regionW > regionH
          ? regionW / regionH
          : regionH / regionW;
      if (aspect > 3.0) continue;

      // Calculate plate-likeness score
      // Higher fill ratio = more plate-like (plates are compact shapes)
      final fillScore = fillRatio; // 0.35 to 1.0

      // Centrality: prefer regions centered in the image
      final regionCenterX = (region['minX']! + region['maxX']!) / 2;
      final regionCenterY = (region['minY']! + region['maxY']!) / 2;
      final distFromCenter = sqrt(
        ((regionCenterX - w / 2) * (regionCenterX - w / 2) +
         (regionCenterY - h / 2) * (regionCenterY - h / 2)) / 
        (w * w / 4 + h * h / 4)
      );
      final centralityScore = 1.0 - distFromCenter.clamp(0.0, 1.0);

      // Size: moderate sizes are better (10-60% of image area)
      final sizeRatio = regionArea / imageArea;
      double sizeScore;
      if (sizeRatio < 0.10) {
        sizeScore = sizeRatio / 0.10; // ramp up to 10%
      } else if (sizeRatio <= 0.60) {
        sizeScore = 1.0; // sweet spot
      } else {
        sizeScore = max(0.0, 1.0 - (sizeRatio - 0.60) / 0.30); // penalize very large
      }

      final totalScore = fillScore * 0.5 + centralityScore * 0.3 + sizeScore * 0.2;

      if (kDebugMode) {
        print('[FoodDetection] Color plate candidate #$i: RGB(${candidate.r},${candidate.g},${candidate.b}) '
            'ratio=${(ratio * 100).toStringAsFixed(1)}% fill=${(fillRatio * 100).toStringAsFixed(1)}% '
            'aspect=${aspect.toStringAsFixed(2)} score=${totalScore.toStringAsFixed(3)} '
            'imgCoverage=${(widthCoverage * 100).toStringAsFixed(0)}%x${(heightCoverage * 100).toStringAsFixed(0)}%');
      }

      if (totalScore > bestScore) {
        bestScore = totalScore;

        final centerX = (region['minX']! + region['maxX']!) ~/ 2;
        final centerY = (region['minY']! + region['maxY']!) ~/ 2;
        final radiusX = regionW ~/ 2;
        final radiusY = regionH ~/ 2;

        final type = fillRatio > 0.7 ? 'circle' : 'rectangle';

        bestPlate = {
          'type': type,
          'centerX': centerX,
          'centerY': centerY,
          'radiusX': radiusX,
          'radiusY': radiusY,
          'minX': region['minX']!,
          'maxX': region['maxX']!,
          'minY': region['minY']!,
          'maxY': region['maxY']!,
          'plateR': candidate.r,
          'plateG': candidate.g,
          'plateB': candidate.b,
          'plateTolerance': bucketSize + 10,
        };
      }
    }

    return bestPlate;
  }

  /// Find the bounding region of a specific color in the image
  static Map<String, int>? _findColorRegion(
    img.Image image, int tR, int tG, int tB, int tolerance,
  ) {
    int minX = image.width, maxX = 0, minY = image.height, maxY = 0;
    int count = 0;

    // Scan every other pixel for speed
    for (int y = 0; y < image.height; y += 2) {
      for (int x = 0; x < image.width; x += 2) {
        final pixel = image.getPixelSafe(x, y);
        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();

        if ((r - tR).abs() <= tolerance &&
            (g - tG).abs() <= tolerance &&
            (b - tB).abs() <= tolerance) {
          if (x < minX) minX = x;
          if (x > maxX) maxX = x;
          if (y < minY) minY = y;
          if (y > maxY) maxY = y;
          count++;
        }
      }
    }

    // Multiply count by 4 since we sampled every other pixel in each dimension
    count *= 4;

    if (count < 100) return null;

    return {
      'minX': minX,
      'maxX': maxX,
      'minY': minY,
      'maxY': maxY,
      'pixelCount': count,
    };
  }

  /// Edge-based plate detection using improved Hough circle transform
  static Map<String, dynamic>? _detectPlateByEdges(img.Image gray, img.Image original) {
    final w = gray.width;
    final h = gray.height;
    final edges = _sobelEdges(gray);

    // Collect strong edge pixels
    final edgePixels = <(int, int)>[];
    for (int y = 5; y < h - 5; y += 2) {
      for (int x = 5; x < w - 5; x += 2) {
        final pixel = edges.getPixelSafe(x, y);
        if (pixel.r.toInt() > 80) {
          edgePixels.add((x, y));
        }
      }
    }

    if (edgePixels.length < 30) return null;

    // Hough circle search
    final minR = min(w, h) ~/ 8;
    final maxR = min(w, h) ~/ 2;
    
    int bestCx = 0, bestCy = 0, bestR = 0;
    int bestVotes = 0;

    // Coarse pass
    for (int r = minR; r <= maxR; r += max(10, (maxR - minR) ~/ 15)) {
      for (int cy = h ~/ 5; cy < 4 * h ~/ 5; cy += max(10, h ~/ 30)) {
        for (int cx = w ~/ 5; cx < 4 * w ~/ 5; cx += max(10, w ~/ 30)) {
          int votes = 0;
          for (final (ex, ey) in edgePixels) {
            final dx = (ex - cx).toDouble();
            final dy = (ey - cy).toDouble();
            final dist = sqrt(dx * dx + dy * dy);
            if ((dist - r).abs() < max(15, r * 0.08)) votes++;
          }
          if (votes > bestVotes) {
            bestVotes = votes;
            bestCx = cx;
            bestCy = cy;
            bestR = r;
          }
        }
      }
    }

    // Refine around best candidate
    final refineR = max(10, (maxR - minR) ~/ 15);
    final refineStep = max(3, refineR ~/ 5);
    for (int r = max(minR, bestR - refineR); r <= min(maxR, bestR + refineR); r += refineStep) {
      final refineXY = max(5, max(w, h) ~/ 30);
      for (int cy = bestCy - refineXY; cy <= bestCy + refineXY; cy += max(2, refineXY ~/ 5)) {
        for (int cx = bestCx - refineXY; cx <= bestCx + refineXY; cx += max(2, refineXY ~/ 5)) {
          int votes = 0;
          for (final (ex, ey) in edgePixels) {
            final dx = (ex - cx).toDouble();
            final dy = (ey - cy).toDouble();
            final dist = sqrt(dx * dx + dy * dy);
            if ((dist - r).abs() < max(10, r * 0.06)) votes++;
          }
          if (votes > bestVotes) {
            bestVotes = votes;
            bestCx = cx;
            bestCy = cy;
            bestR = r;
          }
        }
      }
    }

    // Accept if enough edge pixels agree
    final requiredVotes = edgePixels.length ~/ 8;
    if (bestVotes < requiredVotes || bestR < minR) return null;

    if (kDebugMode) {
      print('[FoodDetection] Edge circle: center=($bestCx,$bestCy) r=$bestR votes=$bestVotes/${edgePixels.length}');
    }

    // Detect the plate color from the detected region
    final plateColor = _detectPlateColorInCircle(original, bestCx, bestCy, bestR);

    // Shrink radius by 8% for analysis — edge detection finds the outer edge,
    // so the actual plate surface is slightly inside. This excludes items
    // (napkins, decorations, etc.) right at the plate border.
    final analysisR = (bestR * 0.92).toInt();

    return {
      'type': 'circle',
      'centerX': bestCx,
      'centerY': bestCy,
      'radiusX': analysisR,
      'radiusY': analysisR,
      'minX': max(0, bestCx - analysisR),
      'maxX': min(w - 1, bestCx + analysisR),
      'minY': max(0, bestCy - analysisR),
      'maxY': min(h - 1, bestCy + analysisR),
      'plateR': plateColor[0],
      'plateG': plateColor[1],
      'plateB': plateColor[2],
      'plateTolerance': 35,
    };
  }

  /// Detect the dominant color of the plate surface inside a circle
  static List<int> _detectPlateColorInCircle(img.Image image, int cx, int cy, int r) {
    // Sample pixels in an annular ring near the plate edge (where food is less likely)
    // This ring from 0.7*r to 0.95*r is typically plate surface
    final innerR = (r * 0.7).toInt();
    final outerR = (r * 0.95).toInt();

    final Map<String, _ColorBucket> buckets = {};
    const bucketSize = 25;

    for (int y = cy - outerR; y <= cy + outerR; y += 3) {
      for (int x = cx - outerR; x <= cx + outerR; x += 3) {
        if (y < 0 || y >= image.height || x < 0 || x >= image.width) continue;
        final dx = x - cx;
        final dy = y - cy;
        final distSq = dx * dx + dy * dy;
        if (distSq < innerR * innerR || distSq > outerR * outerR) continue;

        final pixel = image.getPixelSafe(x, y);
        final rv = pixel.r.toInt();
        final gv = pixel.g.toInt();
        final bv = pixel.b.toInt();

        final key = '${rv ~/ bucketSize},${gv ~/ bucketSize},${bv ~/ bucketSize}';
        final bucket = buckets.putIfAbsent(key, () => _ColorBucket(
          ((rv ~/ bucketSize) * bucketSize + bucketSize ~/ 2).clamp(0, 255),
          ((gv ~/ bucketSize) * bucketSize + bucketSize ~/ 2).clamp(0, 255),
          ((bv ~/ bucketSize) * bucketSize + bucketSize ~/ 2).clamp(0, 255),
        ));
        bucket.count++;
      }
    }

    if (buckets.isEmpty) return [200, 200, 200]; // default to gray

    final sorted = buckets.values.toList()..sort((a, b) => b.count.compareTo(a.count));
    return [sorted.first.r, sorted.first.g, sorted.first.b];
  }

  // ============================================================
  //  FOOD ANALYSIS ON DETECTED PLATE
  // ============================================================

  /// Analyze food coverage on a detected plate
  /// Uses both color difference AND texture (edge density) to detect food
  static Map<String, double> _analyzeFoodOnPlate(
    img.Image image,
    Map<String, dynamic> plate,
  ) {
    final centerX = plate['centerX'] as int;
    final centerY = plate['centerY'] as int;
    final radiusX = plate['radiusX'] as int;
    final radiusY = plate['radiusY'] as int;
    final plateR = plate['plateR'] as int;
    final plateG = plate['plateG'] as int;
    final plateB = plate['plateB'] as int;
    final plateTol = plate['plateTolerance'] as int;
    final plateType = plate['type'] as String;
    final isElliptical = plateType == 'circle' || plateType == 'oval';

    int totalPlatePixels = 0;
    int foodPixels = 0;
    int plateColorPixels = 0;
    int whitePixels = 0;
    int blackPixels = 0;
    // For food brightness variance (detects flat stains vs 3D food)
    double foodLumSum = 0;
    double foodLumSqSum = 0;
    int foodLumCount = 0;

    // Iterate over the plate region bounding box
    for (int y = centerY - radiusY; y <= centerY + radiusY; y++) {
      for (int x = centerX - radiusX; x <= centerX + radiusX; x++) {
        if (y < 0 || y >= image.height || x < 0 || x >= image.width) continue;

        // For circular/oval plates, apply ellipse mask
        // For rectangular/square/squircle plates, use full bounding box
        if (isElliptical) {
          final dx = (x - centerX) / radiusX.toDouble();
          final dy = (y - centerY) / radiusY.toDouble();
          if (dx * dx + dy * dy > 1.0) continue;
        }

        final pixel = image.getPixelSafe(x, y);
        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();

        // Skip near-white (specular highlights on plate)
        if (r >= 240 && g >= 240 && b >= 240) {
          whitePixels++;
          continue;
        }

        // Skip very dark (shadows)
        if (r <= 25 && g <= 25 && b <= 25) {
          blackPixels++;
          continue;
        }

        totalPlatePixels++;

        // Check if pixel matches plate color
        final diffR = (r - plateR).abs();
        final diffG = (g - plateG).abs();
        final diffB = (b - plateB).abs();
        final colorDist = diffR + diffG + diffB;

        if (diffR <= plateTol && diffG <= plateTol && diffB <= plateTol) {
          // This pixel is the plate surface color
          plateColorPixels++;
        } else if (colorDist > plateTol * 1.5) {
          // This pixel differs significantly from plate → likely food
          foodPixels++;
          // Track luminance for brightness variance
          final lum = 0.299 * r + 0.587 * g + 0.114 * b;
          foodLumSum += lum;
          foodLumSqSum += lum * lum;
          foodLumCount++;
        }
      }
    }

    final foodCoverage = totalPlatePixels > 0 ? foodPixels / totalPlatePixels : 0.0;
    final plateColorRatio = totalPlatePixels > 0 ? plateColorPixels / totalPlatePixels : 0.0;

    // Compute food brightness standard deviation
    // High std dev = 3D food with shadows/highlights. Low std dev = flat stains.
    double foodBrightnessStdDev = 0.0;
    if (foodLumCount > 10) {
      final mean = foodLumSum / foodLumCount;
      final variance = (foodLumSqSum / foodLumCount) - (mean * mean);
      foodBrightnessStdDev = sqrt(variance.clamp(0, double.infinity));
    }

    // ---- Texture analysis (edge density) ----
    // Detects food that has similar color to the plate (e.g. white rice on white plate)
    // by measuring how "bumpy" the surface is inside the plate.
    // Food creates many small edges (shadows between pieces); empty plate is smooth.
    final textureDensity = _computeTextureDensity(
      image, centerX, centerY, radiusX, radiusY, isElliptical,
    );

    // ---- Food concentration analysis ----
    // Checks if food pixels are clustered (real food) or scattered (stains)
    // Uses a 5x5 grid: high max-cell density = concentrated food, low = scattered stains
    final foodConcentration = _computeFoodConcentration(
      image, centerX, centerY, radiusX, radiusY, isElliptical,
      plateR, plateG, plateB, plateTol,
    );

    if (kDebugMode) {
      print('[FoodDetection] Plate analysis:');
      print('[FoodDetection]   Plate color: RGB($plateR,$plateG,$plateB) tolerance=$plateTol');
      print('[FoodDetection]   Total plate pixels: $totalPlatePixels');
      print('[FoodDetection]   Plate-color pixels: $plateColorPixels (${(plateColorRatio * 100).toStringAsFixed(1)}%)');
      print('[FoodDetection]   Food pixels: $foodPixels (${(foodCoverage * 100).toStringAsFixed(1)}%)');
      print('[FoodDetection]   Food brightness std dev: ${foodBrightnessStdDev.toStringAsFixed(1)}');
      print('[FoodDetection]   Texture density: ${(textureDensity * 100).toStringAsFixed(1)}%');
      print('[FoodDetection]   Food concentration: ${(foodConcentration * 100).toStringAsFixed(1)}%');
      print('[FoodDetection]   Skipped: white=$whitePixels, black=$blackPixels');
    }

    return {
      'foodCoverage': foodCoverage,
      'plateColorRatio': plateColorRatio,
      'textureDensity': textureDensity,
      'foodConcentration': foodConcentration,
      'foodBrightnessStdDev': foodBrightnessStdDev,
    };
  }

  /// Compute edge density inside the plate region (inner 85% to avoid rim edges)
  /// High density = textured food present; Low density = smooth empty plate
  static double _computeTextureDensity(
    img.Image image,
    int centerX, int centerY, int radiusX, int radiusY,
    bool isElliptical,
  ) {
    // Work on the inner 85% of the plate to exclude rim edges
    final innerRX = (radiusX * 0.85).toInt();
    final innerRY = (radiusY * 0.85).toInt();

    // Convert to grayscale luminance for edge detection
    int edgePixels = 0;
    int totalPixels = 0;
    const edgeThreshold = 40; // Sobel magnitude threshold for "edge" (40 filters soft gradients/reflections)

    for (int y = centerY - innerRY + 1; y < centerY + innerRY - 1; y++) {
      for (int x = centerX - innerRX + 1; x < centerX + innerRX - 1; x++) {
        if (y < 1 || y >= image.height - 1 || x < 1 || x >= image.width - 1) continue;

        // Shape mask
        if (isElliptical) {
          final dx = (x - centerX) / innerRX.toDouble();
          final dy = (y - centerY) / innerRY.toDouble();
          if (dx * dx + dy * dy > 1.0) continue;
        }

        totalPixels++;

        // Inline Sobel on luminance (avoids creating a full grayscale image)
        int gx = 0, gy = 0;
        for (int ky = -1; ky <= 1; ky++) {
          for (int kx = -1; kx <= 1; kx++) {
            final p = image.getPixelSafe(x + kx, y + ky);
            final lum = (0.299 * p.r.toInt() + 0.587 * p.g.toInt() + 0.114 * p.b.toInt()).toInt();
            // Sobel kernels
            const sx = [[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]];
            const sy = [[-1, -2, -1], [0, 0, 0], [1, 2, 1]];
            gx += sx[ky + 1][kx + 1] * lum;
            gy += sy[ky + 1][kx + 1] * lum;
          }
        }

        final magnitude = sqrt((gx * gx + gy * gy).toDouble());
        if (magnitude > edgeThreshold) {
          edgePixels++;
        }
      }
    }

    return totalPixels > 0 ? edgePixels / totalPixels : 0.0;
  }

  /// Compute food concentration: divides plate into 5x5 grid, returns max cell food ratio.
  /// High value = food concentrated in one area (real food piled up).
  /// Low value = food pixels spread thinly across many cells (scattered stains).
  static double _computeFoodConcentration(
    img.Image image,
    int centerX, int centerY, int radiusX, int radiusY,
    bool isElliptical,
    int plateR, int plateG, int plateB, int plateTol,
  ) {
    const gridSize = 5;
    final cellFoodPixels = List.filled(gridSize * gridSize, 0);
    final cellTotalPixels = List.filled(gridSize * gridSize, 0);

    final left = centerX - radiusX;
    final top = centerY - radiusY;
    final cellW = (radiusX * 2) / gridSize;
    final cellH = (radiusY * 2) / gridSize;

    // Sample every 2nd pixel for speed
    for (int y = top; y <= centerY + radiusY; y += 2) {
      for (int x = left; x <= centerX + radiusX; x += 2) {
        if (y < 0 || y >= image.height || x < 0 || x >= image.width) continue;

        if (isElliptical) {
          final dx = (x - centerX) / radiusX.toDouble();
          final dy = (y - centerY) / radiusY.toDouble();
          if (dx * dx + dy * dy > 1.0) continue;
        }

        // Determine grid cell
        final cellX = ((x - left) / cellW).floor().clamp(0, gridSize - 1);
        final cellY = ((y - top) / cellH).floor().clamp(0, gridSize - 1);
        final cellIdx = cellY * gridSize + cellX;

        final pixel = image.getPixelSafe(x, y);
        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();

        // Skip white/black
        if (r >= 240 && g >= 240 && b >= 240) continue;
        if (r <= 25 && g <= 25 && b <= 25) continue;

        cellTotalPixels[cellIdx]++;

        // Check if food (differs from plate color)
        final diffR = (r - plateR).abs();
        final diffG = (g - plateG).abs();
        final diffB = (b - plateB).abs();
        final colorDist = diffR + diffG + diffB;

        if (colorDist > plateTol * 1.5) {
          cellFoodPixels[cellIdx]++;
        }
      }
    }

    // Find the max food ratio in any cell
    double maxCellRatio = 0.0;
    for (int i = 0; i < gridSize * gridSize; i++) {
      if (cellTotalPixels[i] > 10) {
        final ratio = cellFoodPixels[i] / cellTotalPixels[i];
        if (ratio > maxCellRatio) maxCellRatio = ratio;
      }
    }

    return maxCellRatio;
  }

  /// Fallback when no plate is detected: analyze center 60% of image
  static Map<String, double> _analyzeFoodCenterCropFallback(img.Image image) {
    final w = image.width;
    final h = image.height;
    
    // Use center 60% of the image
    final startX = (w * 0.2).toInt();
    final endX = (w * 0.8).toInt();
    final startY = (h * 0.2).toInt();
    final endY = (h * 0.8).toInt();

    if (kDebugMode) {
      print('[FoodDetection] Center-crop fallback: ($startX,$startY)-($endX,$endY)');
    }

    // Step 1: Find the dominant color in this region (likely plate or background)
    final Map<String, _ColorBucket> buckets = {};
    const bucketSize = 25;

    for (int y = startY; y < endY; y += 4) {
      for (int x = startX; x < endX; x += 4) {
        final pixel = image.getPixelSafe(x, y);
        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();

        if (r >= 240 && g >= 240 && b >= 240) continue;
        if (r <= 25 && g <= 25 && b <= 25) continue;

        final key = '${r ~/ bucketSize},${g ~/ bucketSize},${b ~/ bucketSize}';
        final bucket = buckets.putIfAbsent(key, () => _ColorBucket(
          (r ~/ bucketSize) * bucketSize + bucketSize ~/ 2,
          (g ~/ bucketSize) * bucketSize + bucketSize ~/ 2,
          (b ~/ bucketSize) * bucketSize + bucketSize ~/ 2,
        ));
        bucket.count++;
      }
    }

    // Get top 2 dominant colors (background + plate)
    final sorted = buckets.values.toList()..sort((a, b) => b.count.compareTo(a.count));
    
    // Treat top 2 dominant colors as "not food" (background + plate surface)
    final dominantColors = sorted.take(min(2, sorted.length)).toList();

    int totalPixels = 0;
    int foodPixels = 0;
    const tolerance = 35;

    for (int y = startY; y < endY; y++) {
      for (int x = startX; x < endX; x++) {
        final pixel = image.getPixelSafe(x, y);
        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();

        if (r >= 240 && g >= 240 && b >= 240) continue;
        if (r <= 25 && g <= 25 && b <= 25) continue;

        totalPixels++;

        // Check if matches any dominant color (background or plate)
        bool isDominant = false;
        for (final dc in dominantColors) {
          if ((r - dc.r).abs() <= tolerance &&
              (g - dc.g).abs() <= tolerance &&
              (b - dc.b).abs() <= tolerance) {
            isDominant = true;
            break;
          }
        }

        if (!isDominant) {
          foodPixels++;
        }
      }
    }

    final foodCoverage = totalPixels > 0 ? foodPixels / totalPixels : 0.0;

    if (kDebugMode) {
      print('[FoodDetection] Fallback analysis:');
      for (int i = 0; i < dominantColors.length; i++) {
        final dc = dominantColors[i];
        print('[FoodDetection]   Dominant color #$i: RGB(${dc.r},${dc.g},${dc.b}) count=${dc.count}');
      }
      print('[FoodDetection]   Total: $totalPixels, Food: $foodPixels, Coverage: ${(foodCoverage * 100).toStringAsFixed(1)}%');
    }

    return {
      'foodCoverage': foodCoverage,
      'plateColorRatio': 0.0,
    };
  }

  // ============================================================
  //  UTILITY
  // ============================================================

  /// Convert image to grayscale
  static img.Image _toGrayscale(img.Image image) {
    final grayscale = img.Image(width: image.width, height: image.height);

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixelSafe(x, y);
        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();

        // Standard luminance formula
        final gray = (0.299 * r + 0.587 * g + 0.114 * b).toInt().clamp(0, 255);
        grayscale.setPixelRgba(x, y, gray, gray, gray, 255);
      }
    }

    return grayscale;
  }

  /// Detect edges using Sobel operator
  static img.Image _sobelEdges(img.Image gray) {
    final width = gray.width;
    final height = gray.height;
    final edges = img.Image(width: width, height: height);

    const sobX = [
      [-1, 0, 1],
      [-2, 0, 2],
      [-1, 0, 1]
    ];

    const sobY = [
      [-1, -2, -1],
      [0, 0, 0],
      [1, 2, 1]
    ];

    for (int y = 1; y < height - 1; y++) {
      for (int x = 1; x < width - 1; x++) {
        int gx = 0, gy = 0;

        for (int ky = 0; ky < 3; ky++) {
          for (int kx = 0; kx < 3; kx++) {
            final pixel = gray.getPixelSafe(x + kx - 1, y + ky - 1);
            final intensity = pixel.r.toInt();
            gx += sobX[ky][kx] * intensity;
            gy += sobY[ky][kx] * intensity;
          }
        }

        final magnitude = (sqrt((gx * gx + gy * gy).toDouble())).toInt().clamp(0, 255);
        edges.setPixelRgba(x, y, magnitude, magnitude, magnitude, 255);
      }
    }

    return edges;
  }
}

/// Helper class for color bucketing
class _ColorBucket {
  final int r, g, b;
  int count = 0;
  int sumX = 0;
  int sumY = 0;

  _ColorBucket(this.r, this.g, this.b);
}
