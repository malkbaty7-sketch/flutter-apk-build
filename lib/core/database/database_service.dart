import 'dart:io';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/file_model.dart';

class DatabaseService {
  static const String _boxFiles = 'files';
  static const String _boxPages = 'pages';
  static const String _boxProjects = 'projects';
  static const String _boxUsers = 'users';
  static const String _boxSettings = 'settings';
  static const String _boxCitations = 'citations';
  static const String _boxExtractions = 'extractions';

  late Box<FileModel> _filesBox;
  late Box<PageModel> _pagesBox;
  late Box<ProjectModel> _projectsBox;
  late Box<UserModel> _usersBox;
  late Box<CitationModel> _citationsBox;
  late Box<ExtractionResult> _extractionsBox;
  late Box _settingsBox;

  bool _isInitialized = false;

  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);

      _registerAdapters();

      _filesBox = await Hive.openBox<FileModel>(_boxFiles);
      _pagesBox = await Hive.openBox<PageModel>(_boxPages);
      _projectsBox = await Hive.openBox<ProjectModel>(_boxProjects);
      _usersBox = await Hive.openBox<UserModel>(_boxUsers);
      _citationsBox = await Hive.openBox<CitationModel>(_boxCitations);
      _extractionsBox = await Hive.openBox<ExtractionResult>(_boxExtractions);
      _settingsBox = await Hive.openBox(_boxSettings);

      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize database: $e');
    }
  }

  void _registerAdapters() {
    Hive.registerAdapter(FileModelAdapter());
    Hive.registerAdapter(PageModelAdapter());
    Hive.registerAdapter(ProjectModelAdapter());
    Hive.registerAdapter(ProjectSectionAdapter());
    Hive.registerAdapter(ContentBlockAdapter());
    Hive.registerAdapter(ContentTypeAdapter());
    Hive.registerAdapter(ProjectStatusAdapter());
    Hive.registerAdapter(CitationModelAdapter());
    Hive.registerAdapter(ExtractionResultAdapter());
    Hive.registerAdapter(UserModelAdapter());
  }

  bool get isInitialized => _isInitialized;

  // ============ FILE OPERATIONS ============

  Future<String> addFile(FileModel file) async {
    await _ensureInitialized();
    final id = file.id.isEmpty ? _generateId() : file.id;
    final newFile = file.copyWith(id: id);
    await _filesBox.put(id, newFile);
    return id;
  }

  Future<FileModel?> getFile(String id) async {
    await _ensureInitialized();
    return _filesBox.get(id);
  }

  Future<List<FileModel>> getAllFiles() async {
    await _ensureInitialized();
    return _filesBox.values.toList();
  }

  Future<List<FileModel>> getFilesByFolder(String folderId) async {
    await _ensureInitialized();
    return _filesBox.values
        .where((file) => file.folderId == folderId)
        .toList();
  }

  Future<List<FileModel>> getFavoriteFiles() async {
    await _ensureInitialized();
    return _filesBox.values
        .where((file) => file.isFavorite)
        .toList();
  }

  Future<List<FileModel>> searchFiles(String query) async {
    await _ensureInitialized();
    final lowerQuery = query.toLowerCase();
    return _filesBox.values
        .where((file) => 
            file.name.toLowerCase().contains(lowerQuery) ||
            (file.author?.toLowerCase().contains(lowerQuery) ?? false) ||
            file.tags.any((tag) => tag.toLowerCase().contains(lowerQuery))
        )
        .toList();
  }

  Future<void> updateFile(FileModel file) async {
    await _ensureInitialized();
    await _filesBox.put(file.id, file);
  }

  Future<void> deleteFile(String id) async {
    await _ensureInitialized();
    await _filesBox.delete(id);
    
    // Delete all pages associated with this file
    final pagesToDelete = _pagesBox.values
        .where((page) => page.fileId == id)
        .map((page) => page.id)
        .toList();
    
    for (final pageId in pagesToDelete) {
      await _pagesBox.delete(pageId);
    }
  }

  Future<void> deleteFilePermanently(String id) async {
    await deleteFile(id);
  }

  // ============ PAGE OPERATIONS ============

  Future<String> addPage(PageModel page) async {
    await _ensureInitialized();
    final id = page.id.isEmpty ? _generateId() : page.id;
    final newPage = page.copyWith(id: id);
    await _pagesBox.put(id, newPage);
    return id;
  }

  Future<PageModel?> getPage(String id) async {
    await _ensureInitialized();
    return _pagesBox.get(id);
  }

  Future<List<PageModel>> getPagesByFile(String fileId) async {
    await _ensureInitialized();
    return _pagesBox.values
        .where((page) => page.fileId == fileId)
        .toList()..sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
  }

  Future<void> updatePage(PageModel page) async {
    await _ensureInitialized();
    await _pagesBox.put(page.id, page);
  }

  Future<void> deletePage(String id) async {
    await _ensureInitialized();
    await _pagesBox.delete(id);
  }

  Future<void> deletePagesByFile(String fileId) async {
    await _ensureInitialized();
    final pages = _pagesBox.values
        .where((page) => page.fileId == fileId)
        .toList();
    
    for (final page in pages) {
      await _pagesBox.delete(page.id);
    }
  }

  // ============ PROJECT OPERATIONS ============

  Future<String> addProject(ProjectModel project) async {
    await _ensureInitialized();
    final id = project.id.isEmpty ? _generateId() : project.id;
    final newProject = project.copyWith(id: id);
    await _projectsBox.put(id, newProject);
    return id;
  }

  Future<ProjectModel?> getProject(String id) async {
    await _ensureInitialized();
    return _projectsBox.get(id);
  }

  Future<List<ProjectModel>> getAllProjects() async {
    await _ensureInitialized();
    return _projectsBox.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<List<ProjectModel>> getProjectsByStatus(ProjectStatus status) async {
    await _ensureInitialized();
    return _projectsBox.values
        .where((project) => project.status == status)
        .toList();
  }

  Future<List<ProjectModel>> searchProjects(String query) async {
    await _ensureInitialized();
    final lowerQuery = query.toLowerCase();
    return _projectsBox.values
        .where((project) => 
            project.name.toLowerCase().contains(lowerQuery) ||
            project.description?.toLowerCase().contains(lowerQuery) ?? false ||
            project.tags.any((tag) => tag.toLowerCase().contains(lowerQuery))
        )
        .toList();
  }

  Future<void> updateProject(ProjectModel project) async {
    await _ensureInitialized();
    await _projectsBox.put(project.id, project);
  }

  Future<void> deleteProject(String id) async {
    await _ensureInitialized();
    await _projectsBox.delete(id);
  }

  // ============ CITATION OPERATIONS ============

  Future<String> addCitation(CitationModel citation) async {
    await _ensureInitialized();
    final id = citation.id.isEmpty ? _generateId() : citation.id;
    final newCitation = citation.copyWith(id: id);
    await _citationsBox.put(id, newCitation);
    return id;
  }

  Future<CitationModel?> getCitation(String id) async {
    await _ensureInitialized();
    return _citationsBox.get(id);
  }

  Future<List<CitationModel>> getAllCitations() async {
    await _ensureInitialized();
    return _citationsBox.values.toList();
  }

  Future<List<CitationModel>> getCitationsBySource(String sourceId) async {
    await _ensureInitialized();
    return _citationsBox.values
        .where((citation) => citation.sourceId == sourceId)
        .toList();
  }

  Future<void> deleteCitation(String id) async {
    await _ensureInitialized();
    await _citationsBox.delete(id);
  }

  // ============ EXTRACTION OPERATIONS ============

  Future<String> addExtractionResult(ExtractionResult result) async {
    await _ensureInitialized();
    final id = result.id.isEmpty ? _generateId() : result.id;
    final newResult = result.copyWith(id: id);
    await _extractionsBox.put(id, newResult);
    return id;
  }

  Future<List<ExtractionResult>> getExtractionResults(String query) async {
    await _ensureInitialized();
    return _extractionsBox.values
        .where((result) => result.query == query)
        .toList()..sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
  }

  Future<List<ExtractionResult>> getAllExtractionResults() async {
    await _ensureInitialized();
    return _extractionsBox.values.toList();
  }

  Future<void> updateExtractionResult(ExtractionResult result) async {
    await _ensureInitialized();
    await _extractionsBox.put(result.id, result);
  }

  Future<void> deleteExtractionResult(String id) async {
    await _ensureInitialized();
    await _extractionsBox.delete(id);
  }

  Future<void> deleteExtractionResultsByQuery(String query) async {
    await _ensureInitialized();
    final results = _extractionsBox.values
        .where((result) => result.query == query)
        .toList();
    
    for (final result in results) {
      await _extractionsBox.delete(result.id);
    }
  }

  // ============ USER OPERATIONS ============

  Future<String> addUser(UserModel user) async {
    await _ensureInitialized();
    final id = user.id.isEmpty ? _generateId() : user.id;
    final newUser = user.copyWith(id: id);
    await _usersBox.put(id, newUser);
    return id;
  }

  Future<UserModel?> getUser(String id) async {
    await _ensureInitialized();
    return _usersBox.get(id);
  }

  Future<void> updateUser(UserModel user) async {
    await _ensureInitialized();
    await _usersBox.put(user.id, user);
  }

  Future<void> deleteUser(String id) async {
    await _ensureInitialized();
    await _usersBox.delete(id);
  }

  // ============ SETTINGS OPERATIONS ============

  Future<void> setSetting(String key, dynamic value) async {
    await _ensureInitialized();
    await _settingsBox.put(key, value);
  }

  Future<dynamic> getSetting(String key, {dynamic defaultValue}) async {
    await _ensureInitialized();
    return _settingsBox.get(key, defaultValue: defaultValue);
  }

  Future<void> deleteSetting(String key) async {
    await _ensureInitialized();
    await _settingsBox.delete(key);
  }

  // ============ UTILITY METHODS ============

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        (1000 + (DateTime.now().microsecondsSinceEpoch % 1000)).toString();
  }

  Future<void> clearAllData() async {
    await _ensureInitialized();
    await _filesBox.clear();
    await _pagesBox.clear();
    await _projectsBox.clear();
    await _usersBox.clear();
    await _citationsBox.clear();
    await _extractionsBox.clear();
    await _settingsBox.clear();
  }

  Future<void> close() async {
    if (_isInitialized) {
      await _filesBox.close();
      await _pagesBox.close();
      await _projectsBox.close();
      await _usersBox.close();
      await _citationsBox.close();
      await _extractionsBox.close();
      await _settingsBox.close();
      _isInitialized = false;
    }
  }

  // ============ STATISTICS ============

  Future<int> getTotalFilesCount() async {
    await _ensureInitialized();
    return _filesBox.length;
  }

  Future<int> getTotalProjectsCount() async {
    await _ensureInitialized();
    return _projectsBox.length;
  }

  Future<int> getTotalPagesCount() async {
    await _ensureInitialized();
    return _pagesBox.length;
  }

  Future<int> getTotalStorageSize() async {
    await _ensureInitialized();
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory(appDir.path);
    
    int totalSize = 0;
    try {
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) {
          final stat = await entity.stat();
          totalSize += stat.size;
        }
      }
    } catch (e) {
      // Ignore errors
    }
    return totalSize;
  }
}
