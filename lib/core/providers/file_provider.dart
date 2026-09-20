import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/file_model.dart';
import '../services/services.dart';

// ============ DATABASE PROVIDER ============

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  final dbService = DatabaseService();
  ref.onDispose(() async {
    await dbService.close();
  });
  return dbService;
});

// ============ FILE PROVIDERS ============

final allFilesProvider = FutureProvider<List<FileModel>>((ref) async {
  final dbService = ref.watch(databaseServiceProvider);
  return await dbService.getAllFiles();
});

final favoriteFilesProvider = FutureProvider<List<FileModel>>((ref) async {
  final dbService = ref.watch(databaseServiceProvider);
  return await dbService.getFavoriteFiles();
});

final recentFilesProvider = FutureProvider<List<FileModel>>((ref) async {
  final dbService = ref.watch(databaseServiceProvider);
  final allFiles = await dbService.getAllFiles();
  return allFiles
    ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt))
    .take(10)
    .toList();
});

final fileByIdProvider = FutureProvider.family<FileModel?, String>((ref, fileId) async {
  final dbService = ref.watch(databaseServiceProvider);
  return await dbService.getFile(fileId);
});

final filesByFolderProvider = FutureProvider.family<List<FileModel>, String>((ref, folderId) async {
  final dbService = ref.watch(databaseServiceProvider);
  return await dbService.getFilesByFolder(folderId);
});

final searchFilesProvider = FutureProvider.family<List<FileModel>, String>((ref, query) async {
  final dbService = ref.watch(databaseServiceProvider);
  return await dbService.searchFiles(query);
});

// ============ FILE ACTION PROVIDERS ============

final addFileProvider = FutureProvider.family<String, FileModel>((ref, file) async {
  final dbService = ref.read(databaseServiceProvider);
  return await dbService.addFile(file);
});

final updateFileProvider = FutureProvider.family<void, FileModel>((ref, file) async {
  final dbService = ref.read(databaseServiceProvider);
  await dbService.updateFile(file);
});

final deleteFileProvider = FutureProvider.family<void, String>((ref, fileId) async {
  final dbService = ref.read(databaseServiceProvider);
  await dbService.deleteFile(fileId);
});

final toggleFavoriteProvider = FutureProvider.family<void, String>((ref, fileId) async {
  final dbService = ref.read(databaseServiceProvider);
  final file = await dbService.getFile(fileId);
  if (file != null) {
    await dbService.updateFile(file.copyWith(isFavorite: !file.isFavorite));
  }
});

// ============ FILE STATISTICS PROVIDERS ============

final totalFilesCountProvider = FutureProvider<int>((ref) async {
  final dbService = ref.watch(databaseServiceProvider);
  return await dbService.getTotalFilesCount();
});

final totalStorageSizeProvider = FutureProvider<int>((ref) async {
  final dbService = ref.watch(databaseServiceProvider);
  return await dbService.getTotalStorageSize();
});

// ============ FILE PROCESSING PROVIDERS ============

final documentServiceProvider = Provider<DocumentService>((ref) {
  final docService = DocumentService();
  ref.onDispose(() async {
    await docService.close();
  });
  return docService;
});

final processFileProvider = FutureProvider.family<FileModel, (String, FileType)>((ref, args) async {
  final (filePath, fileType) = args;
  final docService = ref.read(documentServiceProvider);
  
  switch (fileType) {
    case FileType.pdf:
      return await docService.processPdfFile(filePath);
    case FileType.docx:
      return await docService.processDocxFile(filePath);
    case FileType.txt:
      return await docService.processTxtFile(filePath);
    case FileType.epub:
      return await docService.processEpubFile(filePath);
    case FileType.pptx:
      return await docService.processPptxFile(filePath);
    case FileType.xlsx:
      return await docService.processXlsxFile(filePath);
    case FileType.image:
      return await docService.processImageFile(filePath);
    default:
      throw Exception('Unsupported file type: $fileType');
  }
});

final importFileProvider = FutureProvider.family<FileModel?, String>((ref, filePath) async {
  final docService = ref.read(documentServiceProvider);
  final dbService = ref.read(databaseServiceProvider);
  
  try {
    // Detect file type
    final fileType = docService.detectFileType(filePath);
    
    // Process file
    final fileModel = await ref.read(processFileProvider((filePath, fileType)));
    
    // Save to database
    final fileId = await dbService.addFile(fileModel);
    
    // Return the saved file
    return (await dbService.getFile(fileId))!;
  } catch (e) {
    debugPrint('Failed to import file: $e');
    return null;
  }
});

// ============ PAGE PROVIDERS ============

final pagesByFileProvider = FutureProvider.family<List<PageModel>, String>((ref, fileId) async {
  final dbService = ref.watch(databaseServiceProvider);
  return await dbService.getPagesByFile(fileId);
});

final pageByIdProvider = FutureProvider.family<PageModel?, String>((ref, pageId) async {
  final dbService = ref.watch(databaseServiceProvider);
  return await dbService.getPage(pageId);
});

// ============ OCR PROVIDER ============

final ocrServiceProvider = Provider<OCRService>((ref) {
  final ocrService = OCRService();
  ref.onDispose(() async {
    await ocrService.close();
  });
  return ocrService;
});

final processImageProvider = FutureProvider.family<String, (String, String)>((ref, args) async {
  final (imagePath, language) = args;
  final ocrService = ref.read(ocrServiceProvider);
  return await ocrService.processImageFile(imagePath, language: language);
});

final processImageBytesProvider = FutureProvider.family<String, (Uint8List, String)>((ref, args) async {
  final (bytes, language) = args;
  final ocrService = ref.read(ocrServiceProvider);
  return await ocrService.processImageBytes(bytes, language: language);
});
