import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:katib/core/utils/constants.dart';

/// شاشة الإعدادات
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedTheme = AppConstants.defaultTheme;
  String _selectedLanguage = AppConstants.defaultLanguage;
  String _selectedFont = AppConstants.defaultFont;
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _autoSaveEnabled = true;
  int _autoSaveInterval = 5;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // عنوان الصفحة
          Text(
            'الإعدادات',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // وصف قصير
          Text(
            'إدارة إعدادات التطبيق وتخصيص تجربتك',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // قسم المظهر
          _buildSectionHeader(context, 'المظهر'),
          
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // الثيم
                  ListTile(
                    leading: const Icon(Icons.palette_rounded),
                    title: const Text('الثيم'),
                    subtitle: Text(_getThemeName(_selectedTheme)),
                    trailing: DropdownButton<String>(
                      value: _selectedTheme,
                      items: AppConstants.themeNames.map((theme) => DropdownMenuItem(
                        value: theme,
                        child: Text(_getThemeName(theme)),
                      )).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedTheme = value);
                        }
                      },
                      underline: Container(),
                    ),
                    onTap: null,
                  ),
                  
                  // الوضع الداكن
                  SwitchListTile(
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() => _isDarkMode = value);
                    },
                    title: const Text('الوضع الداكن'),
                    subtitle: const Text('تبديل بين الوضع الفاتح والداكن'),
                    secondary: const Icon(Icons.dark_mode_rounded),
                  ),
                  
                  // الخط الافتراضي
                  ListTile(
                    leading: const Icon(Icons.font_download_rounded),
                    title: const Text('الخط الافتراضي'),
                    subtitle: Text(_selectedFont),
                    trailing: DropdownButton<String>(
                      value: _selectedFont,
                      items: [
                        'Cairo',
                        'Tajawal',
                        'NotoNaskhArabic',
                        'Almarai',
                        'IBM Plex Sans Arabic',
                        'Roboto',
                        'OpenSans',
                      ].map((font) => DropdownMenuItem(
                        value: font,
                        child: Text(font),
                      )).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedFont = value);
                        }
                      },
                      underline: Container(),
                    ),
                    onTap: null,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // قسم اللغة
          _buildSectionHeader(context, 'اللغة'),
          
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // اللغة
                  ListTile(
                    leading: const Icon(Icons.language_rounded),
                    title: const Text('اللغة'),
                    subtitle: Text(_selectedLanguage == 'ar' ? 'العربية' : 'English'),
                    trailing: DropdownButton<String>(
                      value: _selectedLanguage,
                      items: const [
                        DropdownMenuItem(
                          value: 'ar',
                          child: Text('العربية'),
                        ),
                        DropdownMenuItem(
                          value: 'en',
                          child: Text('English'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedLanguage = value);
                        }
                      },
                      underline: Container(),
                    ),
                    onTap: null,
                  ),
                  
                  // اتجاه النص
                  ListTile(
                    leading: const Icon(Icons.text_fields_rounded),
                    title: const Text('اتجاه النص'),
                    subtitle: Text(_selectedLanguage == 'ar' ? 'RTL (من اليمين إلى اليسار)' : 'LTR (من اليسار إلى اليمين)'),
                    onTap: null,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // قسم الحفظ
          _buildSectionHeader(context, 'الحفظ'),
          
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // الحفظ التلقائي
                  SwitchListTile(
                    value: _autoSaveEnabled,
                    onChanged: (value) {
                      setState(() => _autoSaveEnabled = value);
                    },
                    title: const Text('الحفظ التلقائي'),
                    subtitle: const Text('حفظ التغييرات تلقائيًا أثناء الكتابة'),
                    secondary: const Icon(Icons.save_rounded),
                  ),
                  
                  // فترة الحفظ التلقائي
                  if (_autoSaveEnabled) ...[
                    ListTile(
                      leading: const Icon(Icons.timer_rounded),
                      title: const Text('فترة الحفظ التلقائي'),
                      subtitle: Text('$_autoSaveInterval دقائق'),
                      trailing: DropdownButton<int>(
                        value: _autoSaveInterval,
                        items: [1, 5, 10, 15, 30].map((interval) => DropdownMenuItem(
                          value: interval,
                          child: Text('$interval دقائق'),
                        )).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _autoSaveInterval = value);
                          }
                        },
                        underline: Container(),
                      ),
                      onTap: null,
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // قسم الإشعارات
          _buildSectionHeader(context, 'الإشعارات'),
          
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SwitchListTile(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() => _notificationsEnabled = value);
                },
                title: const Text('تمكين الإشعارات'),
                subtitle: const Text('تلقي إشعارات حول التحديثات والأخبار'),
                secondary: const Icon(Icons.notifications_rounded),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // قسم التخزين
          _buildSectionHeader(context, 'التخزين'),
          
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // مسح الذاكرة المؤقتة
                  ListTile(
                    leading: const Icon(Icons.clean_hands_rounded),
                    title: const Text('مسح الذاكرة المؤقتة'),
                    subtitle: const Text('حذف الملفات المؤقتة لتحرير مساحة'),
                    onTap: () {
                      _showClearCacheDialog(context);
                    },
                  ),
                  
                  // إدارة المساحة
                  ListTile(
                    leading: const Icon(Icons.storage_rounded),
                    title: const Text('إدارة المساحة'),
                    subtitle: const Text('عرض واستخدام مساحة التخزين'),
                    onTap: () {
                      // فتح شاشة إدارة المساحة
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // قسم الخصوصية
          _buildSectionHeader(context, 'الخصوصية'),
          
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // سياسة الخصوصية
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_rounded),
                    title: const Text('سياسة الخصوصية'),
                    onTap: () {
                      // فتح سياسة الخصوصية
                    },
                  ),
                  
                  // شروط الاستخدام
                  ListTile(
                    leading: const Icon(Icons.description_rounded),
                    title: const Text('شروط الاستخدام'),
                    onTap: () {
                      // فتح شروط الاستخدام
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // قسم حول التطبيق
          _buildSectionHeader(context, 'حول التطبيق'),
          
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // حول التطبيق
                  ListTile(
                    leading: const Icon(Icons.info_rounded),
                    title: const Text('حول التطبيق'),
                    subtitle: const Text('معلومات عن التطبيق ومطوريه'),
                    onTap: () {
                      // فتح حول التطبيق
                    },
                  ),
                  
                  // الإصدارات
                  ListTile(
                    leading: const Icon(Icons.history_rounded),
                    title: const Text('سجل الإصدارات'),
                    subtitle: const Text('التحديثات والإصدارات السابقة'),
                    onTap: () {
                      // فتح سجل الإصدارات
                    },
                  ),
                  
                  // الاتصال بنا
                  ListTile(
                    leading: const Icon(Icons.contact_support_rounded),
                    title: const Text('الاتصال بنا'),
                    subtitle: const Text('تواصل معنا لأية استفسارات'),
                    onTap: () {
                      // فتح الاتصال بنا
                    },
                  ),
                  
                  // تقييم التطبيق
                  ListTile(
                    leading: const Icon(Icons.star_rounded),
                    title: const Text('تقييم التطبيق'),
                    subtitle: const Text('قم بتقييم التطبيق على المتجر'),
                    onTap: () {
                      // فتح تقييم التطبيق
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // زر تسجيل الخروج
          ElevatedButton.icon(
            onPressed: () {
              _showLogoutDialog(context);
            },
            icon: const Icon(Icons.logout_rounded),
            label: const Text('تسجيل الخروج'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // الإصدار
          Text(
            'الإصدار ${AppConstants.appVersion}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// بناء عنوان القسم
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// الحصول على اسم الثيم
  String _getThemeName(String theme) {
    switch (theme) {
      case 'warm_sunset':
        return 'الغروب الدافئ';
      case 'natural_calm':
        return 'الهدوء الطبيعي';
      case 'calm_sky':
        return 'السماء الهادئة';
      default:
        return theme;
    }
  }

  /// عرض مربع حوار مسح الذاكرة المؤقتة
  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مسح الذاكرة المؤقتة'),
        content: const Text('هل أنت متأكد من مسح الذاكرة المؤقتة؟ لا يمكن استعادة الملفات المحذوفة.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم مسح الذاكرة المؤقتة')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('مسح'),
          ),
        ],
      ),
    );
  }

  /// عرض مربع حوار تسجيل الخروج
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // تسجيل الخروج
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}
