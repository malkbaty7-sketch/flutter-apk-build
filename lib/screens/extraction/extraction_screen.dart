import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:katib/core/utils/constants.dart';

/// شاشة الاستخراج
class ExtractionScreen extends StatefulWidget {
  const ExtractionScreen({super.key});

  @override
  State<ExtractionScreen> createState() => _ExtractionScreenState();
}

class _ExtractionScreenState extends State<ExtractionScreen> {
  String _searchQuery = '';
  String _selectedExtractionType = 'استخراج حرفي';
  final List<String> _selectedSources = [];
  bool _isExtracting = false;
  double _extractionProgress = 0.0;
  final List<ExtractionResult> _results = [];

  // قائمة المصادر المتاحة (بيانات تجريبية)
  final List<Source> _availableSources = [
    Source(
      id: '1',
      title: 'كتاب الطاقة المتجددة',
      author: 'د. أحمد محمد',
      type: 'PDF',
      pages: 245,
      selected: false,
    ),
    Source(
      id: '2',
      title: 'بحث في الذكاء الاصطناعي',
      author: 'م. سارة علي',
      type: 'DOCX',
      pages: 45,
      selected: false,
    ),
    Source(
      id: '3',
      title: 'ملخص رواية الأيقاظ',
      author: 'إياد جميل',
      type: 'TXT',
      pages: 12,
      selected: false,
    ),
    Source(
      id: '4',
      title: 'عرض تقديمي للمشروع',
      author: 'فريق العمل',
      type: 'PPTX',
      pages: 32,
      selected: false,
    ),
  ];

  // أنواع الاستخراج
  final List<String> _extractionTypes = [
    'استخراج حرفي',
    'استخراج دلالي',
    'إجابة عن سؤال',
    'تلخيص',
    'مقارنة',
    'استخراج تعريفات',
    'استخراج أرقام',
    'استخراج حجج',
    'استخراج اقتباسات',
    'مخطط معرفي',
    'أسئلة وأجوبة',
    'بطاقات تعليمية',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // عنوان الصفحة
          Text(
            'استخراج المعلومات',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // وصف قصير
          Text(
            'اختر المصادر وكتابة الموضوع لاستخراج المعلومات ذات الصلة',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // حقل الموضوع
          TextField(
            decoration: InputDecoration(
              labelText: 'الموضوع أو السؤال',
              hintText: 'مثال: استخرج كل ما يتعلق بالطاقة المتجددة',
              prefixIcon: const Icon(Icons.search_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
          
          const SizedBox(height: 16),
          
          // نوع الاستخراج
          DropdownButtonFormField<String>(
            value: _selectedExtractionType,
            items: _extractionTypes.map((type) => DropdownMenuItem(
              value: type,
              child: Text(type),
            )).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedExtractionType = value);
              }
            },
            decoration: InputDecoration(
              labelText: 'نوع الاستخراج',
              prefixIcon: const Icon(Icons.filter_list_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // قسم اختيار المصادر
          Text(
            'اختر المصادر',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          
          const SizedBox(height: 8),
          
          // زر اختيار جميع المصادر
          TextButton.icon(
            onPressed: () {
              setState(() {
                final allSelected = _availableSources.every((s) => s.selected);
                for (var source in _availableSources) {
                  source.selected = !allSelected;
                }
              });
            },
            icon: const Icon(Icons.select_all_rounded),
            label: Text(
              _availableSources.every((s) => s.selected) 
                  ? 'إلغاء اختيار الكل' 
                  : 'اختيار الكل',
            ),
          ),
          
          const SizedBox(height: 8),
          
          // قائمة المصادر
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _availableSources.map((source) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CheckboxListTile(
                    value: source.selected,
                    onChanged: (value) {
                      setState(() => source.selected = value ?? false);
                    },
                    title: Text(source.title),
                    subtitle: Text('${source.author} - ${source.type} - ${source.pages} صفحة'),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getSourceColor(source.type).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getSourceIcon(source.type),
                        color: _getSourceColor(source.type),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                )).toList(),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // زر بدء الاستخراج
          ElevatedButton.icon(
            onPressed: _isExtracting ? null : _startExtraction,
            icon: _isExtracting 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: _extractionProgress,
                    ),
                  )
                : const Icon(Icons.find_in_page_rounded),
            label: Text(
              _isExtracting ? 'جاري الاستخراج...' : 'بدء الاستخراج',
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // قسم النتائج
          if (_isExtracting || _results.isNotEmpty) ...[
            Text(
              'النتائج',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            
            const SizedBox(height: 8),
            
            if (_isExtracting) ...[
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        value: _extractionProgress,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'جاري البحث واستخراج المعلومات...',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(_extractionProgress * 100).toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // قائمة النتائج
              ..._results.map((result) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildResultCard(context, result),
              )),
              
              // زر حفظ النتائج
              if (_results.isNotEmpty) ...[
                ElevatedButton.icon(
                  onPressed: () {
                    // حفظ النتائج في مشروع
                    _showSaveResultsDialog(context);
                  },
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('حفظ النتائج'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ],
          ],
        ],
      ),
    );
  }

  /// بدء عملية الاستخراج
  void _startExtraction() {
    if (_searchQuery.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى كتابة موضوع أو سؤال للبحث'),
        ),
      );
      return;
    }
    
    final selectedSources = _availableSources.where((s) => s.selected).toList();
    if (selectedSources.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار مصدر واحد على الأقل'),
        ),
      );
      return;
    }
    
    setState(() {
      _isExtracting = true;
      _extractionProgress = 0.0;
      _results.clear();
    });
    
    // محاكاة عملية الاستخراج
    _simulateExtraction(selectedSources);
  }

  /// محاكاة عملية الاستخراج
  void _simulateExtraction(List<Source> sources) {
    // إضافة نتائج تجريبية
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _extractionProgress = 0.3;
      });
      
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _extractionProgress = 0.6;
          _results.addAll([
            ExtractionResult(
              text: 'الطاقة المتجددة هي الطاقة المستمدة من الموارد الطبيعية التي تتجدد أو لا تنفد، مثل الطاقة الشمسية وطاقة الرياح وطاقة المياه.',
              source: sources[0].title,
              page: 15,
              relevance: 0.95,
              type: 'نص أصلي',
            ),
            ExtractionResult(
              text: 'تعتبر الطاقة الشمسية من أهم مصادر الطاقة المتجددة، حيث يمكن استخدامها لتوليد الكهرباء وتسخين المياه.',
              source: sources[0].title,
              page: 23,
              relevance: 0.92,
              type: 'نص أصلي',
            ),
            ExtractionResult(
              text: 'تم تطوير تقنيات جديدة لتحسين كفاءة الألواح الشمسية، مما يساهم في خفض تكلفة إنتاج الطاقة الشمسية.',
              source: sources[1].title,
              page: 8,
              relevance: 0.88,
              type: 'نص أصلي',
            ),
          ]);
        });
        
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _extractionProgress = 1.0;
            _isExtracting = false;
            _results.addAll([
              ExtractionResult(
                text: 'الطاقة المتجددة لها تأثير إيجابي على البيئة من خلال تقليل الانبعاثات الكربونية.',
                source: sources[2].title,
                page: 5,
                relevance: 0.85,
                type: 'نص أصلي',
              ),
            ]);
          });
        });
      });
    });
  }

  /// بناء بطاقة النتيجة
  Widget _buildResultCard(BuildContext context, ExtractionResult result) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // النص
            Text(
              result.text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            
            const SizedBox(height: 12),
            
            // معلومات المصدر
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    result.source,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'صفحة ${result.page}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                // شريط درجة الصلة
                Expanded(
                  child: LinearProgressIndicator(
                    value: result.relevance,
                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getRelevanceColor(result.relevance),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(result.relevance * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // نوع النتيجة
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                result.type,
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // أزرار الإجراءات
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.copy_rounded),
                  tooltip: 'نسخ النص',
                  onPressed: () {
                    // نسخ النص
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم نسخ النص'),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_border_rounded),
                  tooltip: 'حفظ في المفضلة',
                  onPressed: () {
                    // حفظ في المفضلة
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  tooltip: 'حذف النتيجة',
                  onPressed: () {
                    setState(() {
                      _results.remove(result);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// عرض مربع حوار حفظ النتائج
  void _showSaveResultsDialog(BuildContext context) {
    final projectNameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حفظ النتائج'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: projectNameController,
              decoration: const InputDecoration(
                labelText: 'اسم المشروع',
                hintText: 'ادخل اسم المشروع',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'سيتم حفظ ${_results.length} نتيجة في المشروع',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (projectNameController.text.isNotEmpty) {
                // حفظ النتائج
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم حفظ ${_results.length} نتيجة في المشروع "${projectNameController.text}"'),
                  ),
                );
                
                // الانتقال إلى المشاريع
                context.go('/projects');
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  /// الحصول على لون المصدر
  Color _getSourceColor(String type) {
    switch (type) {
      case 'PDF':
        return Colors.red;
      case 'DOCX':
        return Colors.blue;
      case 'TXT':
        return Colors.green;
      case 'PPTX':
        return Colors.orange;
      case 'XLSX':
        return Colors.purple;
      case 'EPUB':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  /// الحصول على أيقونة المصدر
  IconData _getSourceIcon(String type) {
    switch (type) {
      case 'PDF':
        return Icons.picture_as_pdf_rounded;
      case 'DOCX':
        return Icons.description_rounded;
      case 'TXT':
        return Icons.text_snippet_rounded;
      case 'PPTX':
        return Icons.slideshow_rounded;
      case 'XLSX':
        return Icons.table_chart_rounded;
      case 'EPUB':
        return Icons.menu_book_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  /// الحصول على لون درجة الصلة
  Color _getRelevanceColor(double relevance) {
    if (relevance >= 0.8) {
      return Colors.green;
    } else if (relevance >= 0.6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}

/// نموذج للمصدر
class Source {
  final String id;
  final String title;
  final String author;
  final String type;
  final int pages;
  bool selected;

  Source({
    required this.id,
    required this.title,
    required this.author,
    required this.type,
    required this.pages,
    this.selected = false,
  });
}

/// نموذج لنتيجة الاستخراج
class ExtractionResult {
  final String text;
  final String source;
  final int page;
  final double relevance;
  final String type;

  ExtractionResult({
    required this.text,
    required this.source,
    required this.page,
    required this.relevance,
    required this.type,
  });
}
