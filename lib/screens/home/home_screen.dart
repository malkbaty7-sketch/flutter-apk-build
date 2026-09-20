import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:katib/core/utils/constants.dart';
import 'package:katib/widgets/feature_card.dart';
import 'package:katib/widgets/quick_action_button.dart';
import 'package:katib/widgets/recent_item_card.dart';

/// شاشة الرئيسية
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // قسم الترحيب
          _buildWelcomeSection(context),
          
          const SizedBox(height: 24),
          
          // أزرار الإجراءات السريعة
          _buildQuickActions(context),
          
          const SizedBox(height: 24),
          
          // قسم المشاريع الأخيرة
          _buildRecentSection(context, 'المشاريع الأخيرة', '/projects'),
          
          const SizedBox(height: 16),
          
          // قسم الملفات الأخيرة
          _buildRecentSection(context, 'الملفات الأخيرة', '/library'),
          
          const SizedBox(height: 24),
          
          // قسم الميزات الرئيسية
          _buildFeaturesSection(context),
          
          const SizedBox(height: 24),
          
          // قسم الإحصائيات
          _buildStatsSection(context),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// بناء قسم الترحيب
  Widget _buildWelcomeSection(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مرحبًا بك في',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      Text(
                        AppConstants.appName,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              AppConstants.appSlogan,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء أزرار الإجراءات السريعة
  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'إجراءات سريعة',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: QuickActionButton(
                icon: Icons.upload_file_rounded,
                label: 'إضافة مصدر',
                color: Theme.of(context).colorScheme.primary,
                onTap: () => context.go('/library'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QuickActionButton(
                icon: Icons.create_new_folder_rounded,
                label: 'مشروع جديد',
                color: Theme.of(context).colorScheme.secondary,
                onTap: () => context.go('/projects'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QuickActionButton(
                icon: Icons.find_in_page_rounded,
                label: 'استخراج',
                color: Theme.of(context).colorScheme.tertiary,
                onTap: () => context.go('/extraction'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// بناء قسم العناصر الأخيرة
  Widget _buildRecentSection(BuildContext context, String title, String route) {
    // بيانات تجريبية
    final recentItems = [
      RecentItem(
        title: 'كتاب الطاقة المتجددة',
        subtitle: 'PDF - 245 صفحة',
        icon: Icons.picture_as_pdf_rounded,
        color: Colors.red,
        date: 'أمس',
      ),
      RecentItem(
        title: 'بحث في الذكاء الاصطناعي',
        subtitle: 'DOCX - 45 صفحة',
        icon: Icons.description_rounded,
        color: Colors.blue,
        date: 'قبل يومين',
      ),
      RecentItem(
        title: 'ملخص رواية',
        subtitle: 'TXT - 12 صفحة',
        icon: Icons.text_snippet_rounded,
        color: Colors.green,
        date: 'قبل أسبوع',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () => context.go(route),
              child: Text(
                'عرض الكل',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...recentItems.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: RecentItemCard(item: item),
        )),
      ],
    );
  }

  /// بناء قسم الميزات الرئيسية
  Widget _buildFeaturesSection(BuildContext context) {
    final features = [
      Feature(
        icon: Icons.library_books_rounded,
        title: 'إدارة المعرفة',
        description: 'حفظ وتنظيم الكتب والمستندات في مكتبة شخصية',
        color: Colors.orange,
      ),
      Feature(
        icon: Icons.search_rounded,
        title: 'استخراج ذكي',
        description: 'البحث الدلالي واستخراج المعلومات من مصادر متعددة',
        color: Colors.blue,
      ),
      Feature(
        icon: Icons.auto_awesome_rounded,
        title: 'مساعد كتابة',
        description: 'اقتراحات ذكية لتحسين كتابتك مع الحفاظ على السيطرة',
        color: Colors.green,
      ),
      Feature(
        icon: Icons.export_rounded,
        title: 'تصدير احترافي',
        description: 'تصدير المشاريع إلى PDF, DOCX, EPUB وصيغ أخرى',
        color: Colors.purple,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'ميزاتنا الرئيسية',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) => FeatureCard(feature: features[index]),
        ),
      ],
    );
  }

  /// بناء قسم الإحصائيات
  Widget _buildStatsSection(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'إحصائياتك',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(context, '24', 'مصدر'),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
                Expanded(
                  child: _buildStatItem(context, '8', 'مشروع'),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
                Expanded(
                  child: _buildStatItem(context, '156', 'صفحة'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// بناء عنصر إحصائي
  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// نموذج لبطاقة العنصر الأخير
class RecentItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String date;

  RecentItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.date,
  });
}

/// نموذج للميزة
class Feature {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  Feature({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
