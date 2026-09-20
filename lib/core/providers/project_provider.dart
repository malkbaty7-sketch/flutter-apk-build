import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/file_model.dart';
import '../services/services.dart';

// ============ PROJECT PROVIDERS ============

final allProjectsProvider = FutureProvider<List<ProjectModel>>((ref) async {
  final dbService = ref.watch(databaseServiceProvider);
  return await dbService.getAllProjects();
});

final recentProjectsProvider = FutureProvider<List<ProjectModel>>((ref) async {
  final dbService = ref.watch(databaseServiceProvider);
  final allProjects = await dbService.getAllProjects();
  return allProjects.take(10).toList();
});

final projectByIdProvider = FutureProvider.family<ProjectModel?, String>((ref, projectId) async {
  final dbService = ref.watch(databaseServiceProvider);
  return await dbService.getProject(projectId);
});

final projectsByStatusProvider = FutureProvider.family<List<ProjectModel>, ProjectStatus>((ref, status) async {
  final dbService = ref.watch(databaseServiceProvider);
  return await dbService.getProjectsByStatus(status);
});

final searchProjectsProvider = FutureProvider.family<List<ProjectModel>, String>((ref, query) async {
  final dbService = ref.watch(databaseServiceProvider);
  return await dbService.searchProjects(query);
});

// ============ PROJECT ACTION PROVIDERS ============

final addProjectProvider = FutureProvider.family<String, ProjectModel>((ref, project) async {
  final dbService = ref.read(databaseServiceProvider);
  return await dbService.addProject(project);
});

final updateProjectProvider = FutureProvider.family<void, ProjectModel>((ref, project) async {
  final dbService = ref.read(databaseServiceProvider);
  await dbService.updateProject(project);
});

final deleteProjectProvider = FutureProvider.family<void, String>((ref, projectId) async {
  final dbService = ref.read(databaseServiceProvider);
  await dbService.deleteProject(projectId);
});

// ============ PROJECT STATISTICS PROVIDERS ============

final totalProjectsCountProvider = FutureProvider<int>((ref) async {
  final dbService = ref.watch(databaseServiceProvider);
  return await dbService.getTotalProjectsCount();
});

// ============ EXTRACTION PROVIDERS ============

final extractionServiceProvider = Provider<ExtractionService>((ref) {
  final extractionService = ExtractionService();
  ref.onDispose(() async {
    await extractionService.close();
  });
  return extractionService;
});

final extractByQueryProvider = FutureProvider.family<List<ExtractionResult>, (String, List<String>, ExtractionType)>((ref, args) async {
  final (query, sourceFileIds, type) = args;
  final extractionService = ref.read(extractionServiceProvider);
  
  switch (type) {
    case ExtractionType.literal:
      return await extractionService.extractLiterally(query, sourceFileIds);
    case ExtractionType.semantic:
      return await extractionService.extractByQuery(query, sourceFileIds);
    case ExtractionType.definitions:
      return await extractionService.extractDefinitions(query, sourceFileIds);
    case ExtractionType.numbers:
      return await extractionService.extractNumbers(query, sourceFileIds);
    case ExtractionType.quotes:
      return await extractionService.extractQuotes(sourceFileIds);
    case ExtractionType.summary:
      final result = await extractionService.createSummary(sourceFileIds, query);
      return [result];
    default:
      return await extractionService.extractByQuery(query, sourceFileIds);
  }
});

final extractionResultsProvider = FutureProvider.family<List<ExtractionResult>, String>((ref, query) async {
  final dbService = ref.watch(databaseServiceProvider);
  return await dbService.getExtractionResults(query);
});

// ============ EXPORT PROVIDERS ============

final exportProjectToPdfProvider = FutureProvider.family<Uint8List, String>((ref, projectId) async {
  final dbService = ref.read(databaseServiceProvider);
  final docService = ref.read(documentServiceProvider);
  
  final project = await dbService.getProject(projectId);
  if (project == null) {
    throw Exception('Project not found');
  }
  
  return await docService.exportProjectToPdf(project);
});

final exportProjectProvider = FutureProvider.family<void, (String, String)>((ref, args) async {
  final (projectId, format) = args;
  final docService = ref.read(documentServiceProvider);
  final dbService = ref.read(databaseServiceProvider);
  
  final project = await dbService.getProject(projectId);
  if (project == null) {
    throw Exception('Project not found');
  }
  
  Uint8List data;
  String fileName;
  String mimeType;
  
  switch (format) {
    case 'pdf':
      data = await docService.exportProjectToPdf(project);
      fileName = '${project.name}.pdf';
      mimeType = 'application/pdf';
      break;
    case 'docx':
      data = await docService.exportProjectToDocx(project);
      fileName = '${project.name}.docx';
      mimeType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      break;
    case 'epub':
      data = await docService.exportProjectToEpub(project);
      fileName = '${project.name}.epub';
      mimeType = 'application/epub+zip';
      break;
    case 'pptx':
      data = await docService.exportProjectToPptx(project);
      fileName = '${project.name}.pptx';
      mimeType = 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      break;
    default:
      data = await docService.exportProjectToPdf(project);
      fileName = '${project.name}.pdf';
      mimeType = 'application/pdf';
  }
  
  await docService.exportToFile(data, fileName, mimeType);
});

// ============ TEMPLATE PROVIDERS ============

final projectTemplatesProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return [
    {
      'id': 'ebook',
      'name': 'كتاب إلكتروني',
      'description': 'قالب لكتابة الكتب الإلكترونية مع غلاف وفهرس وفصول',
      'icon': Icons.book,
      'sections': [
        {'title': 'الغلاف', 'type': 'cover'},
        {'title': 'حقوق الطبع', 'type': 'copyright'},
        {'title': 'فهرس المحتويات', 'type': 'toc'},
        {'title': 'مقدمة', 'type': 'introduction'},
        {'title': 'الفصل الأول', 'type': 'chapter'},
        {'title': 'الفصل الثاني', 'type': 'chapter'},
        {'title': 'الفصل الثالث', 'type': 'chapter'},
        {'title': 'الخاتمة', 'type': 'conclusion'},
        {'title': 'المصادر والمراجع', 'type': 'references'},
      ],
    },
    {
      'id': 'research_paper',
      'name': 'بحث علمي',
      'description': 'قالب للبحوث العلمية مع هيكل أكاديمي',
      'icon': Icons.science,
      'sections': [
        {'title': 'العنوان', 'type': 'title'},
        {'title': 'الملخص', 'type': 'abstract'},
        {'title': 'المقدمة', 'type': 'introduction'},
        {'title': 'الأدبيات السابقة', 'type': 'literature_review'},
        {'title': 'المنهجية', 'type': 'methodology'},
        {'title': 'النتائج', 'type': 'results'},
        {'title': 'المناقشة', 'type': 'discussion'},
        {'title': 'الخاتمة', 'type': 'conclusion'},
        {'title': 'المصادر', 'type': 'references'},
      ],
    },
    {
      'id': 'novel',
      'name': 'رواية',
      'description': 'قالب لكتابة الروايات مع شخصيات وحبكة وأحداث',
      'icon': Icons.auto_stories,
      'sections': [
        {'title': 'الغلاف', 'type': 'cover'},
        {'title': 'شخصيات الرواية', 'type': 'characters'},
        {'title': 'المقدمة', 'type': 'introduction'},
        {'title': 'الفصل الأول', 'type': 'chapter'},
        {'title': 'الفصل الثاني', 'type': 'chapter'},
        {'title': 'الفصل الثالث', 'type': 'chapter'},
        {'title': 'الذروة', 'type': 'climax'},
        {'title': 'الحل والخاتمة', 'type': 'resolution'},
      ],
    },
    {
      'id': 'presentation',
      'name': 'عرض تقديمي',
      'description': 'قالب لإنشاء العروض التقديمية',
      'icon': Icons.slideshow,
      'sections': [
        {'title': 'غلاف العرض', 'type': 'title_slide'},
        {'title': 'الأهداف', 'type': 'objectives'},
        {'title': 'المحتوى', 'type': 'content'},
        {'title': 'الملخص', 'type': 'summary'},
        {'title': 'الأسئلة', 'type': 'questions'},
        {'title': 'المصادر', 'type': 'references'},
      ],
    },
    {
      'id': 'magazine',
      'name': 'مجلة',
      'description': 'قالب لإنشاء المجلات مع مقالات وصور',
      'icon': Icons.newspaper,
      'sections': [
        {'title': 'الغلاف', 'type': 'cover'},
        {'title': 'الافتتاحية', 'type': 'editorial'},
        {'title': 'فهرس المحتويات', 'type': 'toc'},
        {'title': 'المقالة الأولى', 'type': 'article'},
        {'title': 'المقالة الثانية', 'type': 'article'},
        {'title': 'المقالة الثالثة', 'type': 'article'},
        {'title': 'الصور', 'type': 'images'},
        {'title': 'الخاتمة', 'type': 'conclusion'},
      ],
    },
    {
      'id': 'cookbook',
      'name': 'كتاب طبخ',
      'description': 'قالب لكتابة كتب الطبخ مع وصفات',
      'icon': Icons.restaurant_menu,
      'sections': [
        {'title': 'الغلاف', 'type': 'cover'},
        {'title': 'المقدمة', 'type': 'introduction'},
        {'title': 'أقسام الكتاب', 'type': 'sections'},
        {'title': 'وصفة 1', 'type': 'recipe'},
        {'title': 'وصفة 2', 'type': 'recipe'},
        {'title': 'وصفة 3', 'type': 'recipe'},
        {'title': 'الملحق', 'type': 'appendix'},
      ],
    },
    {
      'id': 'resume',
      'name': 'سيرة ذاتية',
      'description': 'قالب للسيرة الذاتية المهنية',
      'icon': Icons.person,
      'sections': [
        {'title': 'المعلومات الشخصية', 'type': 'personal_info'},
        {'title': 'التعليم', 'type': 'education'},
        {'title': 'الخبرة العملية', 'type': 'experience'},
        {'title': 'المهارات', 'type': 'skills'},
        {'title': 'الإنجازات', 'type': 'achievements'},
        {'title': 'المراجع', 'type': 'references'},
      ],
    },
    {
      'id': 'empty',
      'name': 'مشروع فارغ',
      'description': 'إنشاء مشروع فارغ مع هيكل مخصص',
      'icon': Icons.create,
      'sections': [
        {'title': 'صفحة فارغة', 'type': 'blank'},
      ],
    },
  ];
});

// ============ PROJECT CREATION PROVIDER ============

final createProjectFromTemplateProvider = FutureProvider.family<String, (String, String, String)>((ref, args) async {
  final (templateId, name, description) = args;
  final dbService = ref.read(databaseServiceProvider);
  final templates = ref.read(projectTemplatesProvider);
  
  final template = templates.firstWhere(
    (t) => t['id'] == templateId,
    orElse: () => templates.first,
  );
  
  final sections = template['sections'] as List<dynamic>? ?? [];
  
  final projectSections = sections.map((section) {
    final sectionMap = section as Map<String, dynamic>;
    return ProjectSection(
      id: '',
      title: sectionMap['title'] ?? 'قسم جديد',
      type: sectionMap['type'] ?? 'chapter',
      order: sections.indexOf(section),
      contentBlocks: [],
      subSections: [],
    );
  }).toList();
  
  final project = ProjectModel(
    id: '',
    name: name,
    type: templateId,
    description: description,
    sections: projectSections,
    tags: [],
  );
  
  return await dbService.addProject(project);
});

// ============ CONTENT EDITOR PROVIDERS ============

final saveContentBlockProvider = FutureProvider.family<void, (String, ContentBlock)>((ref, args) async {
  final (projectId, block) = args;
  final dbService = ref.read(databaseServiceProvider);
  
  final project = await dbService.getProject(projectId);
  if (project == null) return;
  
  // Find the section that contains this block
  // This is a simplified implementation
  // In a real app, you'd need to track which section the block belongs to
  
  final updatedSections = project.sections.map((section) {
    // For now, just add the block to the first section
    if (section.id.isEmpty) {
      return section.copyWith(
        contentBlocks: [...section.contentBlocks, block],
      );
    }
    return section;
  }).toList();
  
  await dbService.updateProject(project.copyWith(sections: updatedSections));
});

final updateContentBlockProvider = FutureProvider.family<void, (String, String, ContentBlock)>((ref, args) async {
  final (projectId, blockId, newBlock) = args;
  final dbService = ref.read(databaseServiceProvider);
  
  final project = await dbService.getProject(projectId);
  if (project == null) return;
  
  final updatedSections = project.sections.map((section) {
    final updatedBlocks = section.contentBlocks.map((block) {
      if (block.id == blockId) {
        return newBlock;
      }
      return block;
    }).toList();
    
    return section.copyWith(contentBlocks: updatedBlocks);
  }).toList();
  
  await dbService.updateProject(project.copyWith(sections: updatedSections));
});

final deleteContentBlockProvider = FutureProvider.family<void, (String, String)>((ref, args) async {
  final (projectId, blockId) = args;
  final dbService = ref.read(databaseServiceProvider);
  
  final project = await dbService.getProject(projectId);
  if (project == null) return;
  
  final updatedSections = project.sections.map((section) {
    final updatedBlocks = section.contentBlocks
        .where((block) => block.id != blockId)
        .toList();
    
    return section.copyWith(contentBlocks: updatedBlocks);
  }).toList();
  
  await dbService.updateProject(project.copyWith(sections: updatedSections));
});
