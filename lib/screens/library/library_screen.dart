import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../widgets/main_scaffold.dart';
import '../../widgets/library_item_card.dart';
import '../../core/utils/constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/providers.dart';
import '../../core/models/file_model.dart';

/// شاشة المكتبة
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  List<String> _selectedFiles = [];
  String _searchQuery = '';
  String _sortBy = 'name';
  bool _sortDescending = false;
  String _filterBy = 'all';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _requestStoragePermission();
  }

  Future<void> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (status.isDenied) {
        // Show explanation
        await Permission.storage.request();
      }
    }
  }

  Future<void> _refreshFiles() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _isLoading = false);
  }

  Future<void> _importFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: AppConstants.supportedFileExtensions,
        allowMultiple: true,
      );

      if (result != null) {
        setState(() => _isLoading = true);
        
        for (final file in result.files) {
          if (file.path != null) {
            await ref.read(importFileProvider(file.path!));
          }
        }
        
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم استيراد ${result.files.length} ملف(ات)')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في استيراد الملف: $e')),
      );
    }
  }

  Future<void> _importFromCamera() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() => _isLoading = true);
        
        final filePath = result.files.first.path!;
        await ref.read(importFileProvider(filePath));
        
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم استيراد الصورة ومعالجتها باستخدام OCR')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في استيراد الصورة: $e')),
      );
    }
  }

  Future<void> _importFromText() async {
    final text = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة نص جديد'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'ادخل النص هنا...',
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'text'),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );

    if (text != null && text.isNotEmpty) {
      // Create a text file model
      final fileModel = FileModel(
        id: '',
        name: 'نص جديد ${DateTime.now().millisecondsSinceEpoch}',
        path: '',
        type: FileType.txt.name,
        size: text.length,
        wordCount: text.split(RegExp(r'\s+')).length,
        mimeType: 'text/plain',
        language: 'ar',
      );
      
      await ref.read(addFileProvider(fileModel));
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إضافة النص الجديد')),
      );
    }
  }

  void _showAddFileDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'استيراد ملف',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.upload_file),
                title: const Text('استيراد من الملفات'),
                subtitle: const Text('PDF, DOCX, TXT, EPUB, PPTX, XLSX, صور'),
                onTap: () {
                  Navigator.pop(context);
                  _importFile();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('التقاط من الكاميرا'),
                subtitle: const Text('تصوير مستند واستخراج النص'),
                onTap: () {
                  Navigator.pop(context);
                  _importFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.text_fields),
                title: const Text('إضافة نص جديد'),
                subtitle: const Text('كتابة نص مباشرة'),
                onTap: () {
                  Navigator.pop(context);
                  _importFromText();
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFileOptions(BuildContext context, FileModel file) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'خيارات الملف',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(
                  file.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: file.isFavorite ? Colors.red : null,
                ),
                title: Text(
                  file.isFavorite ? 'إزالة من المفضلة' : 'إضافة إلى المفضلة',
                ),
                onTap: () {
                  Navigator.pop(context);
                  ref.read(toggleFavoriteProvider(file.id));
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('تحرير المعلومات'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditFileDialog(file);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('حذف الملف'),
                textColor: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(file);
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditFileDialog(FileModel file) {
    final nameController = TextEditingController(text: file.name);
    final authorController = TextEditingController(text: file.author ?? '');
    final tagsController = TextEditingController(text: file.tags.join(', '));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تحرير معلومات الملف'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم الملف',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: authorController,
                decoration: const InputDecoration(
                  labelText: 'المؤلف',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: tagsController,
                decoration: const InputDecoration(
                  labelText: 'الوسوم (مفصولة بفواصل)',
                  border: OutlineInputBorder(),
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
          TextButton(
            onPressed: () {
              final updatedFile = file.copyWith(
                name: nameController.text,
                author: authorController.text.isEmpty ? null : authorController.text,
                tags: tagsController.text
                    .split(',')
                    .map((t) => t.trim())
                    .where((t) => t.isNotEmpty)
                    .toList(),
              );
              ref.read(updateFileProvider(updatedFile));
              Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(FileModel file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف ملف "${file.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              ref.read(deleteFileProvider(file.id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم حذف الملف: ${file.name}')),
              );
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'بحث في المكتبة...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: (value) => setState(() => _searchQuery = value),
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget _buildFilterControls(ColorScheme colorScheme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip('جميع الملفات', 'all', colorScheme),
          const SizedBox(width: 8),
          _buildFilterChip('PDF', FileType.pdf.name, colorScheme),
          const SizedBox(width: 8),
          _buildFilterChip('DOCX', FileType.docx.name, colorScheme),
          const SizedBox(width: 8),
          _buildFilterChip('صور', FileType.image.name, colorScheme),
          const SizedBox(width: 8),
          _buildFilterChip('المفضلة', 'favorite', colorScheme),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, ColorScheme colorScheme) {
    final isSelected = _filterBy == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _filterBy = selected ? value : 'all');
      },
      backgroundColor: colorScheme.surfaceContainerHighest,
      selectedColor: colorScheme.primaryContainer,
      checkmarkColor: colorScheme.onPrimaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildFileList(ColorScheme colorScheme) {
    final filesAsync = ref.watch(allFilesProvider);
    
    return filesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('خطأ في تحميل الملفات: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshFiles,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
      data: (files) {
        // Filter files
        List<FileModel> filteredFiles = files;
        
        if (_filterBy != 'all') {
          if (_filterBy == 'favorite') {
            filteredFiles = filteredFiles.where((f) => f.isFavorite).toList();
          } else {
            filteredFiles = filteredFiles.where((f) => f.type == _filterBy).toList();
          }
        }
        
        // Search
        if (_searchQuery.isNotEmpty) {
          final queryLower = _searchQuery.toLowerCase();
          filteredFiles = filteredFiles
              .where((f) => 
                  f.name.toLowerCase().contains(queryLower) ||
                  (f.author?.toLowerCase().contains(queryLower) ?? false) ||
                  f.tags.any((t) => t.toLowerCase().contains(queryLower))
              )
              .toList();
        }
        
        // Sort
        switch (_sortBy) {
          case 'name':
            filteredFiles.sort((a, b) => _sortDescending 
                ? b.name.compareTo(a.name) 
                : a.name.compareTo(b.name));
            break;
          case 'date':
            filteredFiles.sort((a, b) => _sortDescending 
                ? b.createdAt.compareTo(a.createdAt) 
                : a.createdAt.compareTo(b.createdAt));
            break;
          case 'size':
            filteredFiles.sort((a, b) => _sortDescending 
                ? b.size.compareTo(a.size) 
                : a.size.compareTo(b.size));
            break;
          case 'type':
            filteredFiles.sort((a, b) => _sortDescending 
                ? b.type.compareTo(a.type) 
                : a.type.compareTo(b.type));
            break;
        }
        
        if (filteredFiles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_open,
                  size: 64,
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'لا يوجد ملفات',
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'اضغط على زر الإضافة لاستيراد ملفات جديدة',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        
        return RefreshIndicator(
          onRefresh: _refreshFiles,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredFiles.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (_isLoading && index == filteredFiles.length) {
                return const Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              
              final file = filteredFiles[index];
              return LibraryItemCard(
                file: file,
                onTap: () => _navigateToFileDetail(file),
                onLongPress: () => _showFileOptions(context, file),
                onFavoriteTap: () => ref.read(toggleFavoriteProvider(file.id)),
                isSelected: _selectedFiles.contains(file.id),
              );
            },
          ),
        );
      },
    );
  }

  void _navigateToFileDetail(FileModel file) {
    // Navigate to file detail screen
    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('فتح الملف: ${file.name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return MainScaffold(
      title: 'المكتبة',
      showFloatingActionButton: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFileDialog(context),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          _buildSearchBar(colorScheme),
          _buildFilterControls(colorScheme),
          const SizedBox(height: 16),
          Expanded(child: _buildFileList(colorScheme)),
        ],
      ),
    );
  }
}
