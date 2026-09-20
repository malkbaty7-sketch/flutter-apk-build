import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:katib/core/utils/constants.dart';

/// شاشة المساعدة
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // عنوان الصفحة
          Text(
            'المساعدة',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // وصف قصير
          Text(
            'مركز المساعدة لتطبيق كاتب',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // شريط البحث
          TextField(
            decoration: InputDecoration(
              hintText: 'بحث في الأسئلة الشائعة...',
              prefixIcon: const Icon(Icons.search_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              // البحث في الأسئلة
            },
          ),
          
          const SizedBox(height: 24),
          
          // قسم البدء السريع
          _buildHelpSection(
            context,
            'البدء السريع',
            Icons.rocket_launch_rounded,
            [
              HelpItem(
                question: 'كيف أبدأ باستخدام تطبيق كاتب؟',
                answer: 'يمكنك البدء بفتح التطبيق ثم اختيار "الدخول كضيف" أو تسجيل الدخول. بعد ذلك، يمكنك إضافة مصادر إلى المكتبة أو إنشاء مشروع جديد.',
              ),
              HelpItem(
                question: 'كيف أضيف ملفًا إلى المكتبة؟',
                answer: 'اذهب إلى شاشة المكتبة ثم انقر على زر "إضافة مصدر". يمكنك اختيار ملف من جهازك أو التصوير باستخدام الكاميرا.',
              ),
              HelpItem(
                question: 'كيف أنشئ مشروعًا جديدًا؟',
                answer: 'اذهب إلى شاشة المشاريع ثم انقر على زر "إنشاء مشروع جديد". اختر نوع المشروع ثم اكتب عنوانًا له.',
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // قسم الاستخراج
          _buildHelpSection(
            context,
            'الاستخراج',
            Icons.find_in_page_rounded,
            [
              HelpItem(
                question: 'كيف أستخرج معلومات من ملف؟',
                answer: 'اذهب إلى شاشة الاستخراج، اختر الملف أو الملفات، اكتب الموضوع الذي تريد استخراجه، ثم انقر على "بدء الاستخراج".',
              ),
              HelpItem(
                question: 'ما هي أنواع الاستخراج المتاحة؟',
                answer: 'يدعم التطبيق استخراج حرفي، استخراج دلالي، إجابة عن سؤال، تلخيص، مقارنة، واستخراج تعريفات وأرقام وحجج واقتباسات.',
              ),
              HelpItem(
                question: 'كيف أحفظ نتائج الاستخراج؟',
                answer: 'بعد الانتهاء من الاستخراج، يمكنك حفظ النتائج في مشروع جديد أو إضافة النتائج إلى مشروع موجود.',
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // قسم المحرر
          _buildHelpSection(
            context,
            'المحرر',
            Icons.edit_rounded,
            [
              HelpItem(
                question: 'كيف أغير الخط؟',
                answer: 'في شريط أدوات المحرر، يمكنك اختيار الخط من قائمة الخطوط المتاحة مثل Cairo, Tajawal, Roboto وغيرها.',
              ),
              HelpItem(
                question: 'كيف أغير اتجاه النص؟',
                answer: 'يمكنك تبديل اتجاه النص بين RTL (من اليمين إلى اليسار) وLTR (من اليسار إلى اليمين) باستخدام زر اتجاه النص في شريط الأدوات.',
              ),
              HelpItem(
                question: 'هل يدعم التطبيق الحفظ التلقائي؟',
                answer: 'نعم، يمكنك تفعيل الحفظ التلقائي من إعدادات التطبيق. سيتم حفظ تغييراتك تلقائيًا أثناء الكتابة.',
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // قسم التصدير
          _buildHelpSection(
            context,
            'التصدير',
            Icons.export_rounded,
            [
              HelpItem(
                question: 'ما هي صيغ التصدير المدعومة؟',
                answer: 'يدعم التطبيق تصدير المشاريع إلى PDF, DOCX, EPUB, PPTX, TXT, HTML, JPG, PNG.',
              ),
              HelpItem(
                question: 'كيف أصدر مشروعًا إلى PDF؟',
                answer: 'افتح المشروع في المحرر، ثم انقر على زر التصدير واختر PDF. سيتم إنشاء ملف PDF يمكن مشاركته أو طباعته.',
              ),
              HelpItem(
                question: 'هل يحفظ التصدير إلى PDF اتجاه النص العربي؟',
                answer: 'نعم، يحافظ التطبيق على اتجاه النص العربي (RTL) عند التصدير إلى PDF أو أي صيغة أخرى.',
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // قسم الحساب
          _buildHelpSection(
            context,
            'الحساب',
            Icons.account_circle_rounded,
            [
              HelpItem(
                question: 'كيف أنشئ حسابًا؟',
                answer: 'يمكنك إنشاء حساب باستخدام البريد الإلكتروني، رقم الهاتف، أو حساب Google من شاشة تسجيل الدخول.',
              ),
              HelpItem(
                question: 'ما هي مزايا الحساب المدفوع؟',
                answer: 'الحساب المدفوع يوفر مساحة تخزين أكبر، عدد غير محدود من المشاريع، استخراج غير محدود، ومزايا إضافية مثل المزامنة السحابية.',
              ),
              HelpItem(
                question: 'كيف أغير كلمة المرور؟',
                answer: 'يمكنك تغيير كلمة المرور من إعدادات الحساب أو من خلال رابط "نسيت كلمة المرور" في شاشة تسجيل الدخول.',
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // قسم الاتصال
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'لم تجد ما تبحث عنه؟',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'يمكنك التواصل معنا عبر القنوات التالية:',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // زر البريد الإلكتروني
                  ElevatedButton.icon(
                    onPressed: () {
                      // فتح تطبيق البريد
                    },
                    icon: const Icon(Icons.email_rounded),
                    label: Text(AppConstants.supportEmail),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // زر الوثائق
                  OutlinedButton.icon(
                    onPressed: () {
                      // فتح الوثائق
                    },
                    icon: const Icon(Icons.description_rounded),
                    label: const Text('توثيق التطبيق'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // زر الإبلاغ عن مشكلة
                  OutlinedButton.icon(
                    onPressed: () {
                      // فتح نموذج الإبلاغ
                    },
                    icon: const Icon(Icons.bug_report_rounded),
                    label: const Text('الإبلاغ عن مشكلة'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// بناء قسم المساعدة
  Widget _buildHelpSection(
    BuildContext context,
    String title,
    IconData icon,
    List<HelpItem> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // عنوان القسم
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // الأسئلة الشائعة
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ExpansionTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                  title: Text(
                    item.question,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Text(
                        item.answer,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

/// نموذج لعنصر المساعدة
class HelpItem {
  final String question;
  final String answer;

  HelpItem({
    required this.question,
    required this.answer,
  });
}
