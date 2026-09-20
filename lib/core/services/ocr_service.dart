import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class OCRService {
  final TextRecognizer _textRecognizer;
  
  static final OCRService _instance = OCRService._internal();
  
  factory OCRService() => _instance;
  
  OCRService._internal() : _textRecognizer = TextRecognizer();
  
  bool _isProcessing = false;
  
  Future<String> processImageFile(String imagePath, {String language = 'ar'}) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('File not found: $imagePath');
      }
      
      final bytes = await file.readAsBytes();
      return await processImageBytes(bytes, language: language);
    } catch (e) {
      throw Exception('Failed to process image file: $e');
    }
  }
  
  Future<String> processImageBytes(Uint8List bytes, {String language = 'ar'}) async {
    if (_isProcessing) {
      throw Exception('OCR is already processing. Please wait.');
    }
    
    _isProcessing = true;
    
    try {
      // Preprocess image for better OCR results
      final processedBytes = await _preprocessImage(bytes);
      
      final inputImage = InputImage.fromBytes(
        bytes: processedBytes,
        inputImageFormat: InputImageFormat.nv21,
      );
      
      final recognizedText = await _textRecognizer.processImage(inputImage);
      
      String extractedText = recognizedText.text;
      
      // Post-process text for Arabic
      if (language == 'ar') {
        extractedText = _postProcessArabicText(extractedText);
      }
      
      return extractedText;
    } catch (e) {
      throw Exception('Failed to process image: $e');
    } finally {
      _isProcessing = false;
    }
  }
  
  Future<Uint8List> _preprocessImage(Uint8List bytes) async {
    try {
      // Decode image
      final image = img.decodeImage(bytes);
      if (image == null) {
        return bytes;
      }
      
      // Convert to grayscale for better OCR
      final grayscale = img.grayscale(image);
      
      // Apply threshold to binarize
      final threshold = img.threshold(grayscale, 128);
      
      // Enhance contrast
      final enhanced = img.adjustColor(threshold, contrast: 1.5);
      
      // Rotate if needed (auto-detection would be here)
      // For now, we'll assume the image is correctly oriented
      
      return Uint8List.fromList(img.encodePng(enhanced));
    } catch (e) {
      // If preprocessing fails, return original
      return bytes;
    }
  }
  
  String _postProcessArabicText(String text) {
    // Clean up Arabic text
    // Remove extra spaces
    String cleaned = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    // Fix common OCR issues with Arabic
    // Connect separated Arabic characters (simple heuristic)
    cleaned = _fixArabicConnections(cleaned);
    
    // Normalize Arabic characters
    cleaned = _normalizeArabic(cleaned);
    
    return cleaned;
  }
  
  String _fixArabicConnections(String text) {
    // This is a simple heuristic to connect separated Arabic letters
    // In a real implementation, you'd use a proper Arabic text normalization library
    
    // Common Arabic character combinations that might be separated
    final separations = [
      r'(ا)ل', r'(ب)ا', r'(ت)ا', r'(ث)ا', r'(ج)ا', r'(ح)ا', r'(خ)ا',
      r'(د)ا', r'(ذ)ا', r'(ر)ا', r'(ز)ا', r'(س)ا', r'(ش)ا',
      r'(ص)ا', r'(ض)ا', r'(ط)ا', r'(ظ)ا', r'(ع)ا', r'(غ)ا',
      r'(ف)ا', r'(ق)ا', r'(ك)ا', r'(ل)ا', r'(م)ا', r'(ن)ا',
      r'(ه)ا', r'(و)ا', r'(ي)ا',
    ];
    
    String result = text;
    for (final sep in separations) {
      result = result.replaceAll(RegExp(sep), sep.replaceAll(')', ''));
    }
    
    return result;
  }
  
  String _normalizeArabic(String text) {
    // Normalize different forms of Arabic characters
    // Replace isolated forms with connected forms where appropriate
    
    // This is a simplified version - a real implementation would use
    // proper Arabic text normalization rules
    
    final normalizations = {
      'أ': 'ا',  // Alef with hamza to plain Alef (context dependent)
      'إ': 'ا',  // Alef with hamza below
      'آ': 'ا',  // Alef with madda
      'ة': 'ه',  // Ta marbuta to Ha (context dependent)
      'گ': 'ك',  // Persian kaf to Arabic kaf
      'پ': 'ب',  // Persian pe to Arabic ba
      'چ': 'ج',  // Persian che to Arabic jeem
      'ژ': 'ز',  // Persian zhe to Arabic zay
    };
    
    String result = text;
    for (final entry in normalizations.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    
    return result;
  }
  
  Future<List<RecognizedText>> processMultipleImages(List<String> imagePaths) async {
    final results = <RecognizedText>[];
    
    for (final path in imagePaths) {
      try {
        final inputImage = InputImage.fromFilePath(path);
        final recognizedText = await _textRecognizer.processImage(inputImage);
        results.add(recognizedText);
      } catch (e) {
        // Skip failed images
        continue;
      }
    }
    
    return results;
  }
  
  Future<List<String>> extractTextFromPdfPages(List<Uint8List> pageImages) async {
    final texts = <String>[];
    
    for (final pageImage in pageImages) {
      try {
        final text = await processImageBytes(pageImage, language: 'ar');
        texts.add(text);
      } catch (e) {
        texts.add('');
      }
    }
    
    return texts;
  }
  
  Future<double> getOCRConfidence(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      
      // Simple confidence calculation based on text length and block count
      final text = recognizedText.text;
      final blocks = recognizedText.blocks.length;
      
      if (text.isEmpty) return 0.0;
      
      // Calculate average confidence per block
      double totalConfidence = 0.0;
      int validBlocks = 0;
      
      for (final block in recognizedText.blocks) {
        for (final line in block.lines) {
          for (final element in line.elements) {
            if (element.text.isNotEmpty) {
              totalConfidence += 1.0; // Simple heuristic
              validBlocks++;
            }
          }
        }
      }
      
      if (validBlocks == 0) return 0.0;
      
      final avgConfidence = totalConfidence / validBlocks;
      
      // Scale based on text length (longer text = potentially more accurate)
      final lengthFactor = text.length > 100 ? 1.0 : text.length / 100;
      
      return (avgConfidence * lengthFactor).clamp(0.0, 1.0);
    } catch (e) {
      return 0.0;
    }
  }
  
  Future<Size> getImageDimensions(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        return Size.zero;
      }
      
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      
      if (image != null) {
        return Size(image.width.toDouble(), image.height.toDouble());
      }
      
      // Fallback using Flutter's image decoding
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      return Size(
        frame.image.width.toDouble(),
        frame.image.height.toDouble(),
      );
    } catch (e) {
      return Size.zero;
    }
  }
  
  Future<void> close() async {
    await _textRecognizer.close();
  }
  
  // Singleton disposal
  static Future<void> dispose() async {
    await _instance.close();
  }
}
