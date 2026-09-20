import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:katib/core/utils/constants.dart';

/// شاشة المحرر
class EditorScreen extends StatefulWidget {
  final String projectId;

  const EditorScreen({super.key, required this.projectId});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  String _projectTitle = 'مشروع غير معنون';
  String _selectedFont = AppConstants.defaultFont;
  double _fontSize = 16.0;
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  String _textDirection = 'rtl';
  final TextEditingController _contentController = TextEditingController();

  // قائمة الخطوط العربية
  final List<String> _arabicFonts = [
    'Cairo',
    'Tajawal',
    'NotoNaskhArabic',
    'Almarai',
    'IBM Plex Sans Arabic',
  ];

  // قائمة الخطوط الإنجليزية
  final List<String> _englishFonts = [
    'Roboto',
    'OpenSans',
    'Poppins',
    'Merriweather',
    'Lato',
  ];

  @override
  void initState() {
    super.initState();
    // تحميل معلومات المشروع
    _loadProjectInfo();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  /// تحميل معلومات المشروع
  void _loadProjectInfo() {
    // في تطبيق حقيقي، سيتم تحميل البيانات من قاعدة البيانات
    // هنا نستخدم بيانات تجريبية
    switch (widget.projectId) {
      case '1':
        _projectTitle = 'كتاب الطاقة المتجددة';
        _contentController.text = 'الفصل الأول: مقدمة عن الطاقة المتجددة

الطاقة المتجددة هي الطاقة المستمدة من الموارد الطبيعية التي تتجدد أو لا تنفد. تشمل هذه الموارد الطاقة الشمسية، وطاقة الرياح، وطاقة المياه، والطاقة الحرارية الأرضية، والطاقة الحيوية.

في هذا الكتاب، سنستعرض مختلف أنواع الطاقة المتجددة، ومزاياها، وعيوبها، وتطبيقاتها العملية.';
        break;
      case '2':
        _projectTitle = 'بحث في الذكاء الاصطناعي';
        _contentController.text = 'الملخص

الذكاء الاصطناعي هو أحد أهم المجالات التكنولوجية في القرن الحادي والعشرين. يتم استخدامه في العديد من التطبيقات مثل التعرف على الصور، ومعالجة اللغة الطبيعية، وأنظمة التوصية.

في هذا البحث، سنناقش تطورات الذكاء الاصطناعي، وتطبيقاته، والتحديات التي تواجهه.';
        break;
      default:
        _projectTitle = 'مشروع جديد';
        _contentController.text = 'ابدأ بكتابة محتواك هنا...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_projectTitle),
        actions: [
          // زر الحفظ
          IconButton(
            icon: const Icon(Icons.save_rounded),
            onPressed: _saveProject,
            tooltip: 'حفظ المشروع',
          ),
          // زر المعاينة
          IconButton(
            icon: const Icon(Icons.preview_rounded),
            onPressed: () {
              // فتح شاشة المعاينة
              _showPreviewDialog(context);
            },
            tooltip: 'معاينة المشروع',
          ),
          // زر التصدير
          IconButton(
            icon: const Icon(Icons.export_rounded),
            onPressed: () {
              // فتح قائمة التصدير
              _showExportMenu(context);
            },
            tooltip: 'تصدير المشروع',
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط أدوات المحرر
          _buildToolbar(context),
          
          // شريط التنسيق
          _buildFormatToolbar(context),
          
          // منطقة الكتابة
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _contentController,
                style: TextStyle(
                  fontFamily: _selectedFont,
                  fontSize: _fontSize,
                  fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                  decoration: _isUnderline ? TextDecoration.underline : TextDecoration.none,
                ),
                textDirection: _textDirection == 'rtl' ? TextDirection.rtl : TextDirection.ltr,
                textAlign: _textDirection == 'rtl' ? TextAlign.right : TextAlign.left,
                maxLines: null,
                expands: false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'ابدأ بكتابة محتواك هنا...',
                ),
                onChanged: (value) {
                  // تحديث الحفظ التلقائي
                  _autoSave();
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildStatusBar(context),
    );
  }

  /// بناء شريط أدوات المحرر
  Widget _buildToolbar(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            // زر التراجع
            IconButton(
              icon: const Icon(Icons.undo_rounded),
              onPressed: () {
                // التراجع
                if (_contentController.text.isNotEmpty) {
                  _contentController.text = _contentController.text.substring(
                    0,
                    _contentController.text.length - 1,
                  );
                }
              },
              tooltip: 'تراجع',
            ),
            
            // زر إعادة
            IconButton(
              icon: const Icon(Icons.redo_rounded),
              onPressed: () {
                // إعادة
              },
              tooltip: 'إعادة',
            ),
            
            // خط فاصل
            const VerticalDivider(),
            
            // زر نسخ
            IconButton(
              icon: const Icon(Icons.copy_rounded),
              onPressed: () {
                // نسخ
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم نسخ النص')),
                );
              },
              tooltip: 'نسخ',
            ),
            
            // زر قص
            IconButton(
              icon: const Icon(Icons.cut_rounded),
              onPressed: () {
                // قص
              },
              tooltip: 'قص',
            ),
            
            // زر لصق
            IconButton(
              icon: const Icon(Icons.paste_rounded),
              onPressed: () {
                // لصق
              },
              tooltip: 'لصق',
            ),
            
            // خط فاصل
            const VerticalDivider(),
            
            // زر البحث
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () {
                // البحث
              },
              tooltip: 'بحث',
            ),
            
            // زر الاستبدال
            IconButton(
              icon: const Icon(Icons.replace_rounded),
              onPressed: () {
                // الاستبدال
              },
              tooltip: 'استبدال',
            ),
          ],
        ),
      ),
    );
  }

  /// بناء شريط التنسيق
  Widget _buildFormatToolbar(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // قائمة الخطوط
              DropdownButton<String>(
                value: _selectedFont,
                items: [..._arabicFonts, ..._englishFonts].map((font) => DropdownMenuItem(
                  value: font,
                  child: Text(
                    font,
                    style: TextStyle(fontFamily: font),
                  ),
                )).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedFont = value);
                  }
                },
                underline: Container(),
              ),
              
              // حجم الخط
              IconButton(
                icon: const Icon(Icons.text_increase_rounded),
                onPressed: () {
                  setState(() => _fontSize = (_fontSize + 2).clamp(8.0, 32.0));
                },
                tooltip: 'زيادة حجم الخط',
              ),
              
              IconButton(
                icon: const Icon(Icons.text_decrease_rounded),
                onPressed: () {
                  setState(() => _fontSize = (_fontSize - 2).clamp(8.0, 32.0));
                },
                tooltip: 'تقليل حجم الخط',
              ),
              
              // خط فاصل
              const VerticalDivider(),
              
              // تنسيق النص
              ToggleButtons(
                isSelected: [_isBold, _isItalic, _isUnderline],
                onPressed: (index) {
                  setState(() {
                    switch (index) {
                      case 0:
                        _isBold = !_isBold;
                        break;
                      case 1:
                        _isItalic = !_isItalic;
                        break;
                      case 2:
                        _isUnderline = !_isUnderline;
                        break;
                    }
                  });
                },
                children: const [
                  Icon(Icons.format_bold_rounded),
                  Icon(Icons.format_italic_rounded),
                  Icon(Icons.format_underline_rounded),
                ],
              ),
              
              // خط فاصل
              const VerticalDivider(),
              
              // اتجاه النص
              ToggleButtons(
                isSelected: [_textDirection == 'rtl', _textDirection == 'ltr'],
                onPressed: (index) {
                  setState(() {
                    _textDirection = index == 0 ? 'rtl' : 'ltr';
                  });
                },
                children: const [
                  Text('RTL'),
                  Text('LTR'),
                ],
              ),
              
              // خط فاصل
              const VerticalDivider(),
              
              // ألوان النص
              IconButton(
                icon: const Icon(Icons.format_color_text_rounded),
                onPressed: () {
                  // اختيار لون النص
                },
                tooltip: 'لون النص',
              ),
              
              // لون الخلفية
              IconButton(
                icon: const Icon(Icons.format_color_fill_rounded),
                onPressed: () {
                  // اختيار لون الخلفية
                },
                tooltip: 'لون الخلفية',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// بناء شريط الحالة
  Widget _buildStatusBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // عدد الكلمات
          Text(
            '${_contentController.text.split(' ').length} كلمة',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          
          // عدد الأحرف
          Text(
            '${_contentController.text.length} حرف',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          
          // حالة الحفظ
          Text(
            'تم الحفظ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  /// حفظ المشروع
  void _saveProject() {
    // في تطبيق حقيقي، سيتم حفظ البيانات في قاعدة البيانات
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ المشروع')),
    );
  }

  /// الحفظ التلقائي
  void _autoSave() {
    // في تطبيق حقيقي، سيتم حفظ البيانات تلقائيًا
    // هنا نكتفي بعرض رسالة
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('جاري الحفظ التلقائي...')),
    // );
  }

  /// عرض مربع حوار المعاينة
  void _showPreviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('معاينة: $_projectTitle'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              _contentController.text,
              style: TextStyle(
                fontFamily: _selectedFont,
                fontSize: _fontSize,
                fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                decoration: _isUnderline ? TextDecoration.underline : TextDecoration.none,
              ),
              textDirection: _textDirection == 'rtl' ? TextDirection.rtl : TextDirection.ltr,
              textAlign: _textDirection == 'rtl' ? TextAlign.right : TextAlign.left,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // التصدير
              _showExportMenu(context);
            },
            child: const Text('تصدير'),
          ),
        ],
      ),
    );
  }

  /// عرض قائمة التصدير
  void _showExportMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'تصدير المشروع',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            // خيارات التصدير
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_rounded, color: Colors.red),
              title: const Text('PDF'),
              subtitle: const Text('تصدير إلى ملف PDF'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('جاري تصدير المشروع إلى PDF')),
                );
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.description_rounded, color: Colors.blue),
              title: const Text('DOCX'),
              subtitle: const Text('تصدير إلى ملف Word'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('جاري تصدير المشروع إلى DOCX')),
                );
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.menu_book_rounded, color: Colors.brown),
              title: const Text('EPUB'),
              subtitle: const Text('تصدير إلى كتاب إلكتروني'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('جاري تصدير المشروع إلى EPUB')),
                );
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.slideshow_rounded, color: Colors.orange),
              title: const Text('PPTX'),
              subtitle: const Text('تصدير إلى عرض تقديمي'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('جاري تصدير المشروع إلى PPTX')),
                );
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.text_snippet_rounded, color: Colors.green),
              title: const Text('TXT'),
              subtitle: const Text('تصدير إلى نص عادي'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('جاري تصدير المشروع إلى TXT')),
                );
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
      ),
    );
  }
}
