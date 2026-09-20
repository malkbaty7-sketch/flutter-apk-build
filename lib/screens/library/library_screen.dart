import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:katib/core/utils/constants.dart';
import 'package:katib/widgets/library_item_card.dart';

/// شاشة المكتبة
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'جميع الملفات';
  String _selectedSort = 'آخر إضافة';

  // قائمة الملفات (بيانات تجريبية)
  final List<LibraryItem> _libraryItems = [
    LibraryItem(
      id: '1',
      title: 'كتاب الطاقة المتجددة',
      author: 'د. أحمد محمد',
      type: 'PDF',
      size: '12.5 MB',
      pages: 245,
      date: '2024-01-15',
      icon: Icons.picture_as_pdf_rounded,
      color: Colors.red,
      isFavorite: true,
      tags: ['طاقة', 'بيئة', 'علوم'],
    ),
    LibraryItem(
      id: '2',
      title: 'بحث في الذكاء الاصطناعي',
      author: 'م. سارة علي',
      type: 'DOCX',
      size: '2.3 MB',
      pages: 45,
      date: '2024-01-10',
      icon: Icons.description_rounded,
      color: Colors.blue,
      isFavorite: false,
      tags: ['تقنية', 'ذكاء اصطناعي', 'برمجة'],
    ),
    LibraryItem(
      id: '3',
      title: 'ملخص رواية الأيقاظ',
      author: 'إياد جميل',
      type: 'TXT',
      size: '120 KB',
      pages: 12,
      date: '2024-01-05',
      icon: Icons.text_snippet_rounded,
      color: Colors.green,
      isFavorite: true,
      tags: ['أدب', 'رواية', 'ملخص'],
    ),
    LibraryItem(
      id: '4',
      title: 'عرض تقديمي للمشروع',
      author: 'فريق العمل',
      type: 'PPTX',
      size: '8.7 MB',
      pages: 32,
      date: '2024-01-01',
      icon: Icons.slideshow_rounded,
      color: Colors.orange,
      isFavorite: false,
      tags: ['مشاريع', 'عروض', 'عمل'],
    ),
    LibraryItem(
      id: '5',
      title: 'جدول بيانات مبيعات',
      author: 'إدارة المبيعات',
      type: 'XLSX',
      size: '1.8 MB',
      pages: 5,
      date: '2023-12-28',
      icon: Icons.table_chart_rounded,
      color: Colors.purple,
      isFavorite: false,
      tags: ['بيانات', 'مبيعات', 'إحصائيات'],
    ),
    LibraryItem(
      id: '6',
      title: 'كتاب الطبخ العربي',
      author: 'شيف مها',
      type: 'EPUB',
      size: '15.2 MB',
      pages: 180,
      date: '2023-12-20',
      icon: Icons.menu_book_rounded,
      color: Colors.brown,
      isFavorite: true,
      tags: ['طبخ', 'وصفات', 'طعام'],
    ),
  ];

  // قائمة الملفات المفلترة
  List<LibraryItem> get _filteredItems {
    List<LibraryItem> filtered = _libraryItems;
    
    // تصفية حسب الاستعلامات
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               item.author.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               item.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      }).toList();
    }
    
    // تصفية حسب النوع
    if (_selectedFilter != 'جميع الملفات') {
      filtered = filtered.where((item) => item.type == _selectedFilter).toList();
    }
    
    // ترتيب
    switch (_selectedSort) {
      case 'الأقدم':
        filtered.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 'الاسم':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'الحجم':
        // ترتيب حسب الحجم (مؤقت - يجب تحويل الحجم إلى رقم)
        break;
      default: // آخر إضافة
        filtered.sort((a, b) => b.date.compareTo(a.date));
        break;
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // شريط البحث
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'بحث في المكتبة...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
        ),
        
        // شريط التصفية والترتيب
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // تصفية حسب النوع
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedFilter,
                  items: [
                    'جميع الملفات',
                    'PDF',
                    'DOCX',
                    'TXT',
                    'PPTX',
                    'XLSX',
                    'EPUB',
                  ].map((filter) => DropdownMenuItem(
                    value: filter,
                    child: Text(filter),
                  )).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedFilter = value);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'تصفية',
                    prefixIcon: const Icon(Icons.filter_list_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // ترتيب
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedSort,
                  items: [
                    'آخر إضافة',
                    'الأقدم',
                    'الاسم',
                    'الحجم',
                  ].map((sort) => DropdownMenuItem(
                    value: sort,
                    child: Text(sort),
                  )).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedSort = value);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'ترتيب',
                    prefixIcon: const Icon(Icons.sort_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // عدد النتائج
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${_filteredItems.length} ملفًا',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // قائمة الملفات
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              final item = _filteredItems[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: LibraryItemCard(
                  item: item,
                  onTap: () {
                    // فتح الملف
                    _showFileOptions(context, item);
                  },
                  onFavoriteTap: () {
                    // تبديل المفضل
                    setState(() {
                      item.isFavorite = !item.isFavorite;
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// عرض خيارات الملف
  void _showFileOptions(BuildContext context, LibraryItem item) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              item.title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            // قراءة الملف
            ListTile(
              leading: const Icon(Icons.remove_red_eye_rounded),
              title: const Text('قراءة الملف'),
              subtitle: const Text('فتح الملف في قارئ التطبيق'),
              onTap: () {
                Navigator.pop(context);
                // فتح القارئ
                // TODO: تنفيذ فتح القارئ
              },
            ),
            
            // استخراج المعلومات
            ListTile(
              leading: const Icon(Icons.find_in_page_rounded),
              title: const Text('استخراج معلومات'),
              subtitle: const Text('البحث واستخراج المحتوى من الملف'),
              onTap: () {
                Navigator.pop(context);
                context.go('/extraction');
              },
            ),
            
            // مشاركة الملف
            ListTile(
              leading: const Icon(Icons.share_rounded),
              title: const Text('مشاركة الملف'),
              subtitle: const Text('مشاركة الملف مع الآخرين'),
              onTap: () {
                Navigator.pop(context);
                // مشاركة الملف
                // TODO: تنفيذ مشاركة الملف
              },
            ),
            
            // إعادة التسمية
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: const Text('إعادة التسمية'),
              subtitle: const Text('تغيير اسم الملف'),
              onTap: () {
                Navigator.pop(context);
                _showRenameDialog(context, item);
              },
            ),
            
            // حذف الملف
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded),
              title: const Text('حذف الملف'),
              subtitle: const Text('حذف الملف من المكتبة'),
              textColor: Theme.of(context).colorScheme.error,
              onTap: () {
                Navigator.pop(context);
                _showDeleteDialog(context, item);
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

  /// عرض مربع حوار إعادة التسمية
  void _showRenameDialog(BuildContext context, LibraryItem item) {
    final controller = TextEditingController(text: item.title);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إعادة التسمية'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'ادخل الاسم الجديد',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              // تحديث اسم الملف
              setState(() {
                item.title = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  /// عرض مربع حوار الحذف
  void _showDeleteDialog(BuildContext context, LibraryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الملف'),
        content: Text('هل أنت متأكد من حذف الملف "${item.title}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              // حذف الملف
              setState(() {
                _libraryItems.remove(item);
              });
              Navigator.pop(context);
              
              // عرض رسالة نجاح
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم حذف الملف "${item.title}"'),
                  action: SnackBarAction(
                    label: 'تراجع',
                    onPressed: () {
                      // استعادة الملف
                      setState(() {
                        _libraryItems.add(item);
                      });
                    },
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}

/// نموذج لعنصر المكتبة
class LibraryItem {
  final String id;
  String title;
  final String author;
  final String type;
  final String size;
  final int pages;
  final String date;
  final IconData icon;
  final Color color;
  bool isFavorite;
  final List<String> tags;

  LibraryItem({
    required this.id,
    required this.title,
    required this.author,
    required this.type,
    required this.size,
    required this.pages,
    required this.date,
    required this.icon,
    required this.color,
    required this.isFavorite,
    required this.tags,
  });
}
