/// ثوابت التطبيق
class AppConstants {
  // معلومات التطبيق
  static const String appName = 'كاتب';
  static const String appDescription = 'منصة إنتاجية وكتابة ونشر ذكية للمستندات والكتب الإلكترونية';
  static const String appVersion = '1.0.0';
  
  // حدود التطبيق
  static const int maxLibraryItems = 1000;
  static const int maxProjectCount = 50;
  static const int maxFileSizeMB = 50;
  static const int maxExtractionResults = 100;
  static const int maxExportSizeMB = 100;
  
  // حدود النسخة المجانية
  static const int freeTierMaxFiles = 20;
  static const int freeTierMaxProjects = 5;
  static const int freeTierMaxExtractions = 10;
  
  // أنواع الملفات المدعومة
  static const List<String> supportedDocumentExtensions = [
    '.pdf',
    '.docx',
    '.doc',
    '.txt',
    '.rtf',
    '.odt',
    '.epub',
    '.xlsx',
    '.xls',
    '.csv',
    '.pptx',
    '.ppt',
  ];
  
  // أنواع الصور المدعومة
  static const List<String> supportedImageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.webp',
    '.tiff',
  ];
  
  // صيغ التصدير المدعومة
  static const List<String> supportedExportFormats = [
    'pdf',
    'docx',
    'epub',
    'pptx',
    'txt',
    'html',
    'jpg',
    'png',
  ];
  
  // أنواع المشاريع
  static const List<String> projectTypes = [
    'ebook',
    'research',
    'scientific_research',
    'academic_research',
    'practical_research',
    'presentation',
    'childrens_book',
    'magazine',
    'novel',
    'text_document',
    'cookbook',
    'brochure',
    'cv',
    'training_guide',
    'diwan',
    'biography',
    'custom',
  ];
  
  // أنماط القراءة
  static const List<String> readingModes = [
    'single_page',
    'dual_page',
    'vertical_scroll',
    'horizontal_scroll',
  ];
  
  // أنماط الترقيم
  static const List<String> paginationStyles = [
    'arabic',
    'arabic_eastern',
    'roman',
    'alphabetic',
    'decorative_line',
    'circle',
    'islamic_ornament',
    'page_x_of_y',
    'custom',
  ];
  
  // أحجام الصفحات
  static const Map<String, Size> pageSizes = {
    'A4': Size(210, 297),
    'A5': Size(148, 210),
    'B5': Size(176, 250),
    'Letter': Size(216, 279),
    'Custom': Size(210, 297),
  };
  
  // ألوان الصفحات
  static const List<Color> pageColors = [
    Color(0xFFFFFFFF), // أبيض
    Color(0xFFF5F5DC), // كريمي
    Color(0xFFFDF5E6), // بيج
    Color(0xFFE6F3FF), // أزرق فاتح
    Color(0xFFE6FFE6), // أخضر فاتح
    Color(0xFFF0F0F0), // رمادي
  ];
  
  // الثيمات
  static const List<String> themeNames = [
    'warm_sunset',
    'natural_calm',
    'calm_sky',
  ];
  
  // المشاعر
  static const List<String> emotionTypes = [
    'warmth',
    'tenderness',
    'mystery',
    'facts',
    'science',
    'romance',
    'motivation',
    'positive_energy',
    'sadness',
    'enthusiasm',
    'calm',
    'hope',
    'inspiration',
  ];
  
  // لغات OCR المدعومة
  static const List<String> supportedOCRLanguages = [
    'ar', // العربية
    'en', // الإنجليزية
    'fr', // الفرنسية
    'tr', // التركية
    'ur', // الأردية
    'es', // الإسبانية
  ];
  
  // إعدادات الافتراضية
  static const String defaultFont = 'Cairo';
  static const String defaultTheme = 'warm_sunset';
  static const String defaultLanguage = 'ar';
  static const String defaultPageSize = 'A4';
  static const String defaultReadingMode = 'single_page';
  
  // رسائل النظام
  static const String welcomeMessage = 'مرحبًا بك في كاتب';
  static const String appSlogan = 'منصة متكاملة لإدارة المعرفة وكتابة الكتب';
  
  // روابط الدعم
  static const String supportEmail = 'support@katib.app';
  static const String documentationUrl = 'https://docs.katib.app';
  static const String privacyPolicyUrl = 'https://katib.app/privacy';
  static const String termsOfServiceUrl = 'https://katib.app/terms';
  
  // مفاتيح التخزين
  static const String storageKeyUserPreferences = 'user_preferences';
  static const String storageKeyLibraryData = 'library_data';
  static const String storageKeyProjectsData = 'projects_data';
  static const String storageKeySessionData = 'session_data';
  
  // مفاتيح API (سيتم تعيينة في بيئة التنفيذ)
  static const String apiKeyFirebase = 'FIREBASE_API_KEY';
  static const String apiKeyGoogleML = 'GOOGLE_ML_API_KEY';
}

/// حجم الصفحة
class Size {
  final double width;
  final double height;
  
  const Size(this.width, this.height);
}

/// لون
class Color {
  final int value;
  
  const Color(this.value);
  
  @override
  bool operator ==(Object other) => 
      identical(this, other) || 
      other is Color && other.value == value;
  
  @override
  int get hashCode => value.hashCode;
}
