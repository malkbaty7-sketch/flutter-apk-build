import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:katib/core/utils/constants.dart';

/// الهيكل الرئيسي للتطبيق
class MainScaffold extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainScaffold({
    super.key,
    required this.child,
    this.currentIndex = 0,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppConstants.appName,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          // زر البحث
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              // TODO: فتح شاشة البحث
            },
          ),
          // زر الإشعارات
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              // TODO: فتح شاشة الإشعارات
            },
          ),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
          
          // التوجيه حسب الفهرس
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/library');
              break;
            case 2:
              context.go('/projects');
              break;
            case 3:
              context.go('/extraction');
              break;
            case 4:
              context.go('/settings');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_books_outlined),
            selectedIcon: Icon(Icons.library_books_rounded),
            label: 'المكتبة',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder_rounded),
            label: 'المشاريع',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'الاستخراج',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'الإعدادات',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // فتح قائمة الإجراءات السريعة
          showModalBottomSheet(
            context: context,
            builder: (context) => _buildQuickActionsSheet(context),
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
      drawer: _buildDrawer(context),
    );
  }

  /// بناء قائمة الإجراءات السريعة
  Widget _buildQuickActionsSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'إجراءات سريعة',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // إضافة مصدر جديد
          ListTile(
            leading: const Icon(Icons.upload_file_rounded),
            title: const Text('إضافة مصدر'),
            subtitle: const Text('استيراد ملف أو تصوير كتاب'),
            onTap: () {
              Navigator.pop(context);
              context.go('/library');
            },
          ),
          
          // إنشاء مشروع جديد
          ListTile(
            leading: const Icon(Icons.create_new_folder_rounded),
            title: const Text('إنشاء مشروع'),
            subtitle: const Text('بدء مشروع كتابة جديد'),
            onTap: () {
              Navigator.pop(context);
              context.go('/projects');
            },
          ),
          
          // الاستخراج من المصادر
          ListTile(
            leading: const Icon(Icons.find_in_page_rounded),
            title: const Text('استخراج معلومات'),
            subtitle: const Text('البحث في المصادر واستخراج المحتوى'),
            onTap: () {
              Navigator.pop(context);
              context.go('/extraction');
            },
          ),
          
          const SizedBox(height: 8),
          
          // زر الإلغاء
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  /// بناء الدراور (القائمة الجانبية)
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // رأس الدراور
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primaryContainer,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person_rounded,
                    size: 40,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'مستخدم ضيف',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'support@katib.app',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          
          // قائمة الروابط
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // الرئيسية
                ListTile(
                  leading: const Icon(Icons.home_rounded),
                  title: const Text('الرئيسية'),
                  selected: _currentIndex == 0,
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/home');
                  },
                ),
                
                // المكتبة
                ListTile(
                  leading: const Icon(Icons.library_books_rounded),
                  title: const Text('المكتبة'),
                  selected: _currentIndex == 1,
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/library');
                  },
                ),
                
                // المشاريع
                ListTile(
                  leading: const Icon(Icons.folder_rounded),
                  title: const Text('المشاريع'),
                  selected: _currentIndex == 2,
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/projects');
                  },
                ),
                
                // الاستخراج
                ListTile(
                  leading: const Icon(Icons.search_rounded),
                  title: const Text('الاستخراج'),
                  selected: _currentIndex == 3,
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/extraction');
                  },
                ),
                
                const Divider(),
                
                // الإعدادات
                ListTile(
                  leading: const Icon(Icons.settings_rounded),
                  title: const Text('الإعدادات'),
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/settings');
                  },
                ),
                
                // المساعدة
                ListTile(
                  leading: const Icon(Icons.help_outline_rounded),
                  title: const Text('المساعدة'),
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/help');
                  },
                ),
                
                // حول التطبيق
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text('حول التطبيق'),
                  onTap: () {
                    Navigator.pop(context);
                    _showAboutDialog(context);
                  },
                ),
              ],
            ),
          ),
          
          // أسفل الدراور
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  AppConstants.appVersion,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// عرض مربع حوار حول التطبيق
  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: AppConstants.appVersion,
      applicationIcon: const Icon(Icons.menu_book_rounded, size: 48),
      children: [
        const SizedBox(height: 16),
        Text(
          AppConstants.appDescription,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          '© 2024 كاتب. جميع الحقوق محفوظة.',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
