import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Helpers {
  // ============ STRING HELPERS ============
  
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
  
  static String capitalizeArabic(String text) {
    if (text.isEmpty) return text;
    // Arabic doesn't have uppercase/lowercase, but we can ensure proper formatting
    return text.trim();
  }
  
  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - suffix.length) + suffix;
  }
  
  static String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }
  
  static String formatDate(DateTime date, {String? locale, bool showTime = false}) {
    if (locale == 'ar') {
      return _formatArabicDate(date, showTime);
    }
    
    final dateFormatter = DateFormat.yMMMd(locale);
    final timeFormatter = DateFormat.jm(locale);
    
    final dateStr = dateFormatter.format(date);
    if (showTime) {
      return '$dateStr ${timeFormatter.format(date)}';
    }
    return dateStr;
  }
  
  static String _formatArabicDate(DateTime date, bool showTime) {
    final arabicMonths = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    
    final day = date.day;
    final month = arabicMonths[date.month - 1];
    final year = date.year;
    
    String dateStr = '$day $month $year';
    
    if (showTime) {
      final hour = date.hour;
      final minute = date.minute;
      final period = hour < 12 ? 'ص' : 'م';
      final hour12 = hour % 12 == 0 ? 12 : hour % 12;
      dateStr += ' $hour12:$minute $period';
    }
    
    return dateStr;
  }
  
  static String formatFileSize(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    int size = bytes;
    int index = 0;
    
    while (size >= 1024 && index < suffixes.length - 1) {
      size ~/= 1024;
      index++;
    }
    
    return '$size ${suffixes[index]}';
  }
  
  static String getFileExtension(String filePath) {
    return filePath.split('.').last.toLowerCase();
  }
  
  static String getFileNameWithoutExtension(String filePath) {
    final parts = filePath.split('/');
    final fileName = parts.last;
    final extension = getFileExtension(fileName);
    return fileName.replaceAll('.$extension', '');
  }
  
  // ============ ARABIC TEXT HELPERS ============
  
  static bool isArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]');
    return arabicRegex.hasMatch(text);
  }
  
  static bool isMixedText(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]');
    final englishRegex = RegExp(r'[a-zA-Z]');
    
    final hasArabic = arabicRegex.hasMatch(text);
    final hasEnglish = englishRegex.hasMatch(text);
    
    return hasArabic && hasEnglish;
  }
  
  static String normalizeArabicText(String text) {
    // Normalize different forms of Arabic characters
    final normalizations = {
      'أ': 'ا',  // Alef with hamza to plain Alef
      'إ': 'ا',  // Alef with hamza below
      'آ': 'ا',  // Alef with madda
      'ة': 'ه',  // Ta marbuta to Ha
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
  
  static String removeDiacritics(String text) {
    // Remove Arabic diacritics (tashkeel)
    return text.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');
  }
  
  // ============ VALIDATION HELPERS ============
  
  static bool isValidEmail(String email) {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(email);
  }
  
  static bool isValidPhone(String phone) {
    // Simple phone validation
    return RegExp(r'^\+?[0-9]{10,15}$').hasMatch(phone);
  }
  
  static bool isValidPassword(String password) {
    // At least 8 characters, with letters and numbers
    return RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(password);
  }
  
  static bool isValidName(String name) {
    // At least 2 characters, only letters and spaces
    return RegExp(r'^[A-Za-z\s\u0600-\u06FF]{2,}$').hasMatch(name);
  }
  
  // ============ FILE HELPERS ============
  
  static Future<String> getAppDocumentsPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  
  static Future<String> getAppCachePath() async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }
  
  static Future<String> createTempFile(String content, {String? extension}) async {
    final tempDir = await getTemporaryDirectory();
    final fileName = 'temp_${DateTime.now().millisecondsSinceEpoch}${extension ?? ''}';
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsString(content);
    return file.path;
  }
  
  static Future<Uint8List> readFileBytes(String filePath) async {
    final file = File(filePath);
    return await file.readAsBytes();
  }
  
  static Future<String> readFileText(String filePath) async {
    final file = File(filePath);
    return await file.readAsString();
  }
  
  static Future<bool> fileExists(String filePath) async {
    final file = File(filePath);
    return await file.exists();
  }
  
  static Future<void> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
  
  static String getMimeType(String filePath) {
    final extension = getFileExtension(filePath).toLowerCase();
    
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'doc':
        return 'application/msword';
      case 'txt':
        return 'text/plain';
      case 'rtf':
        return 'application/rtf';
      case 'odt':
        return 'application/vnd.oasis.opendocument.text';
      case 'epub':
        return 'application/epub+zip';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'csv':
        return 'text/csv';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'tiff':
        return 'image/tiff';
      case 'gif':
        return 'image/gif';
      default:
        return 'application/octet-stream';
    }
  }
  
  // ============ IMAGE HELPERS ============
  
  static Future<ui.Image> loadImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }
  
  static Future<Uint8List> imageToBytes(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
  
  static Future<Uint8List> compressImage(Uint8List imageBytes, {int quality = 85}) async {
    final codec = await ui.instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    
    // Compress and convert to bytes
    final byteData = await image.toByteData(format: ui.ImageByteFormat.jpeg, quality: quality);
    return byteData!.buffer.asUint8List();
  }
  
  static Future<Size> getImageDimensions(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        return Size.zero;
      }
      
      final bytes = await file.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      return Size(frame.image.width.toDouble(), frame.image.height.toDouble());
    } catch (e) {
      return Size.zero;
    }
  }
  
  // ============ SHARE & LAUNCH HELPERS ============
  
  static Future<void> shareText(String text, {String? subject}) async {
    await Share.share(text, subject: subject);
  }
  
  static Future<void> shareFile(String filePath, {String? subject, String? text}) async {
    await Share.shareFiles(
      [filePath],
      subject: subject,
      text: text,
    );
  }
  
  static Future<void> shareFiles(List<String> filePaths, {String? subject, String? text}) async {
    await Share.shareFiles(
      filePaths,
      subject: subject,
      text: text,
    );
  }
  
  static Future<void> launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  
  static Future<void> launchEmail(String email, {String? subject, String? body}) async {
    final url = 'mailto:$email?subject=${Uri.encodeComponent(subject ?? '')}&body=${Uri.encodeComponent(body ?? '')}';
    await launchUrl(url);
  }
  
  static Future<void> launchPhone(String phone) async {
    final url = 'tel:$phone';
    await launchUrl(url);
  }
  
  // ============ COLOR HELPERS ============
  
  static Color parseColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('0xFF$hex'));
      } else if (hex.length == 8) {
        return Color(int.parse('0x$hex'));
      }
    } catch (e) {
      // Return default color
    }
    return Colors.grey;
  }
  
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }
  
  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }
  
  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
  
  static Color withAlpha(Color color, double alpha) {
    return color.withAlpha((alpha * 255).round());
  }
  
  // ============ RANDOM HELPERS ============
  
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        (1000 + (DateTime.now().microsecondsSinceEpoch % 1000)).toString();
  }
  
  static String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }
  
  static int generateRandomNumber(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }
  
  // ============ TIME HELPERS ============
  
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else if (minutes > 0) {
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '$seconds ث';
    }
  }
  
  static String formatTimeOfDay(DateTime date) {
    final hour = date.hour;
    final minute = date.minute;
    final period = hour < 12 ? 'ص' : 'م';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return '$hour12:$minute $period';
  }
  
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inSeconds < 60) {
      return 'منذ ${difference.inSeconds} ث';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} د';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} س';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} ي';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'منذ $weeks أسابيع';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'منذ $months أشهر';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'منذ $years سنوات';
    }
  }
  
  // ============ DEVICE HELPERS ============
  
  static bool isMobile(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide < 600;
  }
  
  static bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600 && shortestSide < 1200;
  }
  
  static bool isDesktop(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 1200;
  }
  
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }
  
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }
  
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
  
  static bool hasNotch(BuildContext context) {
    return MediaQuery.of(context).viewPadding.top > 0;
  }
  
  // ============ RTL HELPERS ============
  
  static bool isRTL(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }
  
  static TextDirection getTextDirection(String text) {
    return isArabic(text) ? TextDirection.rtl : TextDirection.ltr;
  }
  
  static Alignment getAlignmentForRTL(Alignment alignment, BuildContext context) {
    if (!isRTL(context)) return alignment;
    
    // Flip horizontal alignment for RTL
    final x = alignment.x * -1;
    return Alignment(x, alignment.y);
  }
  
  static EdgeInsets getEdgeInsetsForRTL(EdgeInsets edgeInsets, BuildContext context) {
    if (!isRTL(context)) return edgeInsets;
    
    return EdgeInsets.fromLTRB(
      edgeInsets.right,
      edgeInsets.top,
      edgeInsets.left,
      edgeInsets.bottom,
    );
  }
}
