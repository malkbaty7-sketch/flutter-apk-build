import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:katib/core/utils/constants.dart';
import 'package:katib/widgets/project_card.dart';

/// شاشة المشاريع
class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'جميع المشاريع';
  String _selectedSort = 'آخر تعديل';

  // قائمة المشاريع (بيانات تجريبية)
  final List<Project> _projects = [
    Project(
      id: '1',
      title: 'كتاب الطاقة المتجددة',
      type: 'كتاب إلكتروني',
      status: 'قيد العمل',
      progress: 0.65,
      lastModified: '2024-01-18',
      pages: 120,
      words: 45000,
      icon: Icons.menu_book_rounded,
      color: Colors.orange,
      isFavorite: true,
      tags: ['طاقة', 'بيئة', 'علوم'],
    ),
    Project(
      id: '2',
      title: 'بحث في الذكاء الاصطناعي',
      type: 'بحث علمي',
      status: 'مكتمل',
      progress: 1.0,
      lastModified: '2024-01-15',
      pages: 85,
      words: 25000,
      icon: Icons.science_rounded,
      color: Colors.blue,
      isFavorite: true,
      tags: ['تقنية', 'ذكاء اصطناعي', 'برمجة'],
    ),
    Project(
      id: '3',
      title: 'عرض تقديمي للمشروع',
      type: 'عرض تقديمي',
      status: 'قيد المراجعة',
      progress: 0.8,
      lastModified: '2024-01-12',
      pages: 32,
      words: 8000,
      icon: Icons.slideshow_rounded,
      color: Colors.purple,
      isFavorite: false,
      tags: ['مشاريع', 'عروض', 'عمل'],
    ),
    Project(
      id: '4',
      title: 'رواية الأيقاظ',
      type: 'رواية',
      status: 'مسودة',
      progress: 0.3,
      lastModified: '2024-01-10',
      pages: 250,
      words: 75000,
      icon: Icons.auto_stories_rounded,
      color: Colors.brown,
      isFavorite: false,
      tags: ['أدب', 'رواية', 'إبداع'],
    ),
    Project(
      id: '5',
      title: 'دليل تدريبي',
      type: 'دليل تدريبي',
      status: 'قيد العمل',
      progress: 0.45,
      lastModified: '2024-01-08',
      pages: 60,
      words: 18000,
      icon: Icons.school_rounded,
      color: Colors.green,
      isFavorite: true,
      tags: ['تدريب', 'تعليم', 'تطوير'],
    ),
  ];

  // قائمة المشاريع المفلترة
  List<Project> get _filteredProjects {
    List<Project> filtered = _projects;
    
    // تصفية حسب الاستعلامات
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((project) {
        return project.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               project.type.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               project.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      }).toList();
    }
    
    // تصفية حسب الحالة
    if (_selectedFilter != 'جميع المشاريع') {
      filtered = filtered.where((project) => project.status == _selectedFilter).toList();
    }
    
    // ترتيب
    switch (_selectedSort) {
      case 'الأقدم':
        filtered.sort((a, b) => a.lastModified.compareTo(b.lastModified));
        break;
      case 'الاسم':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'التقدم':
        filtered.sort((a, b) => b.progress.compareTo(a.progress));
        break;
      default: // آخر تعديل
        filtered.sort((a, b) => b.lastModified.compareTo(a.lastModified));
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
              hintText: 'بحث في المشاريع...',
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
              // تصفية حسب الحالة
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedFilter,
                  items: [
                    'جميع المشاريع',
                    'قيد العمل',
                    'مكتمل',
                    'قيد المراجعة',
                    'مسودة',
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
                    labelText: 'الحالة',
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
                    'آخر تعديل',
                    'الأقدم',
                    'الاسم',
                    'التقدم',
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
            '${_filteredProjects.length} مشروعًا',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // قائمة المشاريع
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filteredProjects.length,
            itemBuilder: (context, index) {
              final project = _filteredProjects[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ProjectCard(
                  project: project,
                  onTap: () {
                    // فتح المشروع
                    context.go('/editor/${project.id}');
                  },
                  onFavoriteTap: () {
                    // تبديل المفضل
                    setState(() {
                      project.isFavorite = !project.isFavorite;
                    });
                  },
                ),
              );
            },
          ),
        ),
        
        // زر إنشاء مشروع جديد
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () {
              // إنشاء مشروع جديد
              _showNewProjectDialog(context);
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('إنشاء مشروع جديد'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// عرض مربع حوار مشروع جديد
  void _showNewProjectDialog(BuildContext context) {
    final titleController = TextEditingController();
    String selectedType = 'كتاب إلكتروني';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إنشاء مشروع جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'عنوان المشروع',
                  hintText: 'ادخل عنوان المشروع',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: AppConstants.projectTypes.map((type) {
                  String displayName;
                  switch (type) {
                    case 'ebook':
                      displayName = 'كتاب إلكتروني';
                      break;
                    case 'research':
                      displayName = 'بحث عام';
                      break;
                    case 'scientific_research':
                      displayName = 'بحث علمي';
                      break;
                    case 'academic_research':
                      displayName = 'بحث جامعي';
                      break;
                    case 'practical_research':
                      displayName = 'بحث عملي';
                      break;
                    case 'presentation':
                      displayName = 'عرض تقديمي';
                      break;
                    case 'childrens_book':
                      displayName = 'قصة أطفال مصورة';
                      break;
                    case 'magazine':
                      displayName = 'مجلة';
                      break;
                    case 'novel':
                      displayName = 'رواية';
                      break;
                    case 'text_document':
                      displayName = 'مستند نصي';
                      break;
                    case 'cookbook':
                      displayName = 'كتاب طبخ';
                      break;
                    case 'brochure':
                      displayName = 'بروشور';
                      break;
                    case 'cv':
                      displayName = 'سيرة ذاتية';
                      break;
                    case 'training_guide':
                      displayName = 'دليل تدريبي';
                      break;
                    case 'diwan':
                      displayName = 'ديوان';
                      break;
                    case 'biography':
                      displayName = 'سيرة شخصية';
                      break;
                    case 'custom':
                      displayName = 'مشروع فارغ';
                      break;
                    default:
                      displayName = type;
                  }
                  return DropdownMenuItem(
                    value: type,
                    child: Text(displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedType = value;
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'نوع المشروع',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                // إنشاء المشروع
                final newProject = Project(
                  id: '${_projects.length + 1}',
                  title: titleController.text,
                  type: _getTypeDisplayName(selectedType),
                  status: 'مسودة',
                  progress: 0.0,
                  lastModified: DateTime.now().toString(),
                  pages: 0,
                  words: 0,
                  icon: _getTypeIcon(selectedType),
                  color: _getTypeColor(selectedType),
                  isFavorite: false,
                  tags: [],
                );
                
                setState(() {
                  _projects.add(newProject);
                });
                
                Navigator.pop(context);
                
                // فتح المشروع الجديد
                context.go('/editor/${newProject.id}');
              }
            },
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );
  }

  /// الحصول على اسم نوع المشروع
  String _getTypeDisplayName(String type) {
    switch (type) {
      case 'ebook':
        return 'كتاب إلكتروني';
      case 'research':
        return 'بحث عام';
      case 'scientific_research':
        return 'بحث علمي';
      case 'academic_research':
        return 'بحث جامعي';
      case 'practical_research':
        return 'بحث عملي';
      case 'presentation':
        return 'عرض تقديمي';
      case 'childrens_book':
        return 'قصة أطفال مصورة';
      case 'magazine':
        return 'مجلة';
      case 'novel':
        return 'رواية';
      case 'text_document':
        return 'مستند نصي';
      case 'cookbook':
        return 'كتاب طبخ';
      case 'brochure':
        return 'بروشور';
      case 'cv':
        return 'سيرة ذاتية';
      case 'training_guide':
        return 'دليل تدريبي';
      case 'diwan':
        return 'ديوان';
      case 'biography':
        return 'سيرة شخصية';
      case 'custom':
        return 'مشروع فارغ';
      default:
        return type;
    }
  }

  /// الحصول على أيقونة نوع المشروع
  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'ebook':
        return Icons.menu_book_rounded;
      case 'research':
      case 'scientific_research':
      case 'academic_research':
      case 'practical_research':
        return Icons.science_rounded;
      case 'presentation':
        return Icons.slideshow_rounded;
      case 'childrens_book':
        return Icons.child_friendly_rounded;
      case 'magazine':
        return Icons.article_rounded;
      case 'novel':
        return Icons.auto_stories_rounded;
      case 'text_document':
        return Icons.description_rounded;
      case 'cookbook':
        return Icons.restaurant_menu_rounded;
      case 'brochure':
        return Icons.brochure_rounded;
      case 'cv':
        return Icons.person_rounded;
      case 'training_guide':
        return Icons.school_rounded;
      case 'diwan':
        return Icons.menu_book_rounded;
      case 'biography':
        return Icons.person_search_rounded;
      case 'custom':
        return Icons.create_new_folder_rounded;
      default:
        return Icons.folder_rounded;
    }
  }

  /// الحصول على لون نوع المشروع
  Color _getTypeColor(String type) {
    switch (type) {
      case 'ebook':
        return Colors.orange;
      case 'research':
      case 'scientific_research':
        return Colors.blue;
      case 'academic_research':
        return Colors.indigo;
      case 'practical_research':
        return Colors.cyan;
      case 'presentation':
        return Colors.purple;
      case 'childrens_book':
        return Colors.pink;
      case 'magazine':
        return Colors.brown;
      case 'novel':
        return Colors.deepOrange;
      case 'text_document':
        return Colors.grey;
      case 'cookbook':
        return Colors.red;
      case 'brochure':
        return Colors.teal;
      case 'cv':
        return Colors.blueGrey;
      case 'training_guide':
        return Colors.green;
      case 'diwan':
        return Colors.amber;
      case 'biography':
        return Colors.deepPurple;
      case 'custom':
        return Colors.lightBlue;
      default:
        return Colors.blue;
    }
  }
}

/// نموذج للمشروع
class Project {
  final String id;
  String title;
  String type;
  String status;
  double progress;
  String lastModified;
  int pages;
  int words;
  final IconData icon;
  final Color color;
  bool isFavorite;
  final List<String> tags;

  Project({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.progress,
    required this.lastModified,
    required this.pages,
    required this.words,
    required this.icon,
    required this.color,
    required this.isFavorite,
    required this.tags,
  });
}
