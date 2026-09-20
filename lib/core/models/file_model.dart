import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'file_model.g.dart';

@HiveType(typeId: 0)
class FileModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String path;

  @HiveField(3)
  final String type;

  @HiveField(4)
  final int size;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  @HiveField(7)
  final String? author;

  @HiveField(8)
  final String? language;

  @HiveField(9)
  final int? pageCount;

  @HiveField(10)
  final int? wordCount;

  @HiveField(11)
  final String? folderId;

  @HiveField(12)
  final List<String> tags;

  @HiveField(13)
  final bool isFavorite;

  @HiveField(14)
  final bool isProtected;

  @HiveField(15)
  final String? passwordHash;

  @HiveField(16)
  final String? cloudPath;

  @HiveField(17)
  final bool isSynced;

  @HiveField(18)
  final String? mimeType;

  @HiveField(19)
  final Uint8List? thumbnail;

  FileModel({
    required this.id,
    required this.name,
    required this.path,
    required this.type,
    required this.size,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.author,
    this.language,
    this.pageCount,
    this.wordCount,
    this.folderId,
    this.tags = const [],
    this.isFavorite = false,
    this.isProtected = false,
    this.passwordHash,
    this.cloudPath,
    this.isSynced = false,
    this.mimeType,
    this.thumbnail,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  FileModel copyWith({
    String? id,
    String? name,
    String? path,
    String? type,
    int? size,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? author,
    String? language,
    int? pageCount,
    int? wordCount,
    String? folderId,
    List<String>? tags,
    bool? isFavorite,
    bool? isProtected,
    String? passwordHash,
    String? cloudPath,
    bool? isSynced,
    String? mimeType,
    Uint8List? thumbnail,
  }) {
    return FileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      type: type ?? this.type,
      size: size ?? this.size,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      author: author ?? this.author,
      language: language ?? this.language,
      pageCount: pageCount ?? this.pageCount,
      wordCount: wordCount ?? this.wordCount,
      folderId: folderId ?? this.folderId,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      isProtected: isProtected ?? this.isProtected,
      passwordHash: passwordHash ?? this.passwordHash,
      cloudPath: cloudPath ?? this.cloudPath,
      isSynced: isSynced ?? this.isSynced,
      mimeType: mimeType ?? this.mimeType,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'type': type,
      'size': size,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'author': author,
      'language': language,
      'pageCount': pageCount,
      'wordCount': wordCount,
      'folderId': folderId,
      'tags': tags,
      'isFavorite': isFavorite,
      'isProtected': isProtected,
      'passwordHash': passwordHash,
      'cloudPath': cloudPath,
      'isSynced': isSynced,
      'mimeType': mimeType,
    };
  }

  factory FileModel.fromMap(Map<String, dynamic> map) {
    return FileModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      path: map['path'] ?? '',
      type: map['type'] ?? '',
      size: map['size'] ?? 0,
      createdAt: DateTime.tryParse(map['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(map['updatedAt'] ?? ''),
      author: map['author'],
      language: map['language'],
      pageCount: map['pageCount'],
      wordCount: map['wordCount'],
      folderId: map['folderId'],
      tags: List<String>.from(map['tags'] ?? []),
      isFavorite: map['isFavorite'] ?? false,
      isProtected: map['isProtected'] ?? false,
      passwordHash: map['passwordHash'],
      cloudPath: map['cloudPath'],
      isSynced: map['isSynced'] ?? false,
      mimeType: map['mimeType'],
    );
  }

  factory FileModel.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return FileModel.fromMap(map).copyWith(id: doc.id);
  }

  @override
  String toString() {
    return 'FileModel(id: $id, name: $name, type: $type, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FileModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

@HiveType(typeId: 1)
class PageModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fileId;

  @HiveField(2)
  final int pageNumber;

  @HiveField(3)
  final String? text;

  @HiveField(4)
  final String? imagePath;

  @HiveField(5)
  final bool isProcessed;

  @HiveField(6)
  final double? ocrConfidence;

  @HiveField(7)
  final DateTime processedAt;

  PageModel({
    required this.id,
    required this.fileId,
    required this.pageNumber,
    this.text,
    this.imagePath,
    this.isProcessed = false,
    this.ocrConfidence,
    DateTime? processedAt,
  }) : processedAt = processedAt ?? DateTime.now();

  PageModel copyWith({
    String? id,
    String? fileId,
    int? pageNumber,
    String? text,
    String? imagePath,
    bool? isProcessed,
    double? ocrConfidence,
    DateTime? processedAt,
  }) {
    return PageModel(
      id: id ?? this.id,
      fileId: fileId ?? this.fileId,
      pageNumber: pageNumber ?? this.pageNumber,
      text: text ?? this.text,
      imagePath: imagePath ?? this.imagePath,
      isProcessed: isProcessed ?? this.isProcessed,
      ocrConfidence: ocrConfidence ?? this.ocrConfidence,
      processedAt: processedAt ?? this.processedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fileId': fileId,
      'pageNumber': pageNumber,
      'text': text,
      'imagePath': imagePath,
      'isProcessed': isProcessed,
      'ocrConfidence': ocrConfidence,
      'processedAt': processedAt.toIso8601String(),
    };
  }

  factory PageModel.fromMap(Map<String, dynamic> map) {
    return PageModel(
      id: map['id'] ?? '',
      fileId: map['fileId'] ?? '',
      pageNumber: map['pageNumber'] ?? 0,
      text: map['text'],
      imagePath: map['imagePath'],
      isProcessed: map['isProcessed'] ?? false,
      ocrConfidence: map['ocrConfidence']?.toDouble(),
      processedAt: DateTime.tryParse(map['processedAt'] ?? ''),
    );
  }

  @override
  String toString() {
    return 'PageModel(id: $id, fileId: $fileId, pageNumber: $pageNumber)';
  }
}

@HiveType(typeId: 2)
class ProjectModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime updatedAt;

  @HiveField(6)
  final String? coverImagePath;

  @HiveField(7)
  final String? templateId;

  @HiveField(8)
  final List<String> sourceFileIds;

  @HiveField(9)
  final List<ProjectSection> sections;

  @HiveField(10)
  final List<String> tags;

  @HiveField(11)
  final bool isSynced;

  @HiveField(12)
  final String? cloudPath;

  @HiveField(13)
  final int wordCount;

  @HiveField(14)
  final int pageCount;

  @HiveField(15)
  final ProjectStatus status;

  ProjectModel({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.coverImagePath,
    this.templateId,
    this.sourceFileIds = const [],
    this.sections = const [],
    this.tags = const [],
    this.isSynced = false,
    this.cloudPath,
    this.wordCount = 0,
    this.pageCount = 0,
    this.status = ProjectStatus.draft,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  ProjectModel copyWith({
    String? id,
    String? name,
    String? type,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? coverImagePath,
    String? templateId,
    List<String>? sourceFileIds,
    List<ProjectSection>? sections,
    List<String>? tags,
    bool? isSynced,
    String? cloudPath,
    int? wordCount,
    int? pageCount,
    ProjectStatus? status,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      coverImagePath: coverImagePath ?? this.coverImagePath,
      templateId: templateId ?? this.templateId,
      sourceFileIds: sourceFileIds ?? this.sourceFileIds,
      sections: sections ?? this.sections,
      tags: tags ?? this.tags,
      isSynced: isSynced ?? this.isSynced,
      cloudPath: cloudPath ?? this.cloudPath,
      wordCount: wordCount ?? this.wordCount,
      pageCount: pageCount ?? this.pageCount,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'coverImagePath': coverImagePath,
      'templateId': templateId,
      'sourceFileIds': sourceFileIds,
      'sections': sections.map((s) => s.toMap()).toList(),
      'tags': tags,
      'isSynced': isSynced,
      'cloudPath': cloudPath,
      'wordCount': wordCount,
      'pageCount': pageCount,
      'status': status.name,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      description: map['description'],
      createdAt: DateTime.tryParse(map['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(map['updatedAt'] ?? ''),
      coverImagePath: map['coverImagePath'],
      templateId: map['templateId'],
      sourceFileIds: List<String>.from(map['sourceFileIds'] ?? []),
      sections: (map['sections'] as List<dynamic>?)
          ?.map((s) => ProjectSection.fromMap(s))
          .toList() ?? [],
      tags: List<String>.from(map['tags'] ?? []),
      isSynced: map['isSynced'] ?? false,
      cloudPath: map['cloudPath'],
      wordCount: map['wordCount'] ?? 0,
      pageCount: map['pageCount'] ?? 0,
      status: ProjectStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ProjectStatus.draft,
      ),
    );
  }

  @override
  String toString() {
    return 'ProjectModel(id: $id, name: $name, type: $type, status: $status)';
  }
}

@HiveType(typeId: 3)
class ProjectSection {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final int order;

  @HiveField(4)
  final List<ContentBlock> contentBlocks;

  @HiveField(5)
  final List<ProjectSection> subSections;

  ProjectSection({
    required this.id,
    required this.title,
    required this.type,
    required this.order,
    this.contentBlocks = const [],
    this.subSections = const [],
  });

  ProjectSection copyWith({
    String? id,
    String? title,
    String? type,
    int? order,
    List<ContentBlock>? contentBlocks,
    List<ProjectSection>? subSections,
  }) {
    return ProjectSection(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      order: order ?? this.order,
      contentBlocks: contentBlocks ?? this.contentBlocks,
      subSections: subSections ?? this.subSections,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'order': order,
      'contentBlocks': contentBlocks.map((b) => b.toMap()).toList(),
      'subSections': subSections.map((s) => s.toMap()).toList(),
    };
  }

  factory ProjectSection.fromMap(Map<String, dynamic> map) {
    return ProjectSection(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      type: map['type'] ?? '',
      order: map['order'] ?? 0,
      contentBlocks: (map['contentBlocks'] as List<dynamic>?)
          ?.map((b) => ContentBlock.fromMap(b))
          .toList() ?? [],
      subSections: (map['subSections'] as List<dynamic>?)
          ?.map((s) => ProjectSection.fromMap(s))
          .toList() ?? [],
    );
  }
}

@HiveType(typeId: 4)
class ContentBlock {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final ContentType type;

  @HiveField(2)
  final String? text;

  @HiveField(3)
  final String? imagePath;

  @HiveField(4)
  final String? tableData;

  @HiveField(5)
  final String? style;

  @HiveField(6)
  final int order;

  @HiveField(7)
  final Map<String, dynamic>? metadata;

  @HiveField(8)
  final String? citationId;

  ContentBlock({
    required this.id,
    required this.type,
    this.text,
    this.imagePath,
    this.tableData,
    this.style,
    required this.order,
    this.metadata,
    this.citationId,
  });

  ContentBlock copyWith({
    String? id,
    ContentType? type,
    String? text,
    String? imagePath,
    String? tableData,
    String? style,
    int? order,
    Map<String, dynamic>? metadata,
    String? citationId,
  }) {
    return ContentBlock(
      id: id ?? this.id,
      type: type ?? this.type,
      text: text ?? this.text,
      imagePath: imagePath ?? this.imagePath,
      tableData: tableData ?? this.tableData,
      style: style ?? this.style,
      order: order ?? this.order,
      metadata: metadata ?? this.metadata,
      citationId: citationId ?? this.citationId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'text': text,
      'imagePath': imagePath,
      'tableData': tableData,
      'style': style,
      'order': order,
      'metadata': metadata,
      'citationId': citationId,
    };
  }

  factory ContentBlock.fromMap(Map<String, dynamic> map) {
    return ContentBlock(
      id: map['id'] ?? '',
      type: ContentType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => ContentType.text,
      ),
      text: map['text'],
      imagePath: map['imagePath'],
      tableData: map['tableData'],
      style: map['style'],
      order: map['order'] ?? 0,
      metadata: map['metadata'],
      citationId: map['citationId'],
    );
  }
}

@HiveType(typeId: 5)
enum ContentType {
  text,
  heading1,
  heading2,
  heading3,
  paragraph,
  image,
  table,
  list,
  quote,
  code,
  separator,
  pageBreak,
}

@HiveType(typeId: 6)
enum ProjectStatus {
  draft,
  inProgress,
  review,
  completed,
  published,
  archived,
}

@HiveType(typeId: 7)
class CitationModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String sourceId;

  @HiveField(2)
  final String sourceName;

  @HiveField(3)
  final int? pageNumber;

  @HiveField(4)
  final String? author;

  @HiveField(5)
  final DateTime? publishedDate;

  @HiveField(6)
  final String? publisher;

  @HiveField(7)
  final String citationStyle;

  CitationModel({
    required this.id,
    required this.sourceId,
    required this.sourceName,
    this.pageNumber,
    this.author,
    this.publishedDate,
    this.publisher,
    this.citationStyle = 'APA',
  });

  String get formattedCitation {
    switch (citationStyle) {
      case 'APA':
        return '${author ?? "Unknown"} (${publishedDate?.year ?? "n.d."}). ${sourceName}${pageNumber != null ? ', p. $pageNumber' : ''}. ${publisher ?? ""}'.trim();
      case 'MLA':
        return '${author ?? "Unknown"}. ${sourceName}. ${publisher != null ? publisher! + ", " : ""}${publishedDate?.year ?? "n.d."}${pageNumber != null ? ', p. $pageNumber' : ''}.'.trim();
      default:
        return '($sourceName${pageNumber != null ? ', p. $pageNumber' : ''})';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sourceId': sourceId,
      'sourceName': sourceName,
      'pageNumber': pageNumber,
      'author': author,
      'publishedDate': publishedDate?.toIso8601String(),
      'publisher': publisher,
      'citationStyle': citationStyle,
    };
  }

  factory CitationModel.fromMap(Map<String, dynamic> map) {
    return CitationModel(
      id: map['id'] ?? '',
      sourceId: map['sourceId'] ?? '',
      sourceName: map['sourceName'] ?? '',
      pageNumber: map['pageNumber'],
      author: map['author'],
      publishedDate: DateTime.tryParse(map['publishedDate'] ?? ''),
      publisher: map['publisher'],
      citationStyle: map['citationStyle'] ?? 'APA',
    );
  }
}

@HiveType(typeId: 8)
class ExtractionResult {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String query;

  @HiveField(2)
  final String text;

  @HiveField(3)
  final String sourceId;

  @HiveField(4)
  final int? pageNumber;

  @HiveField(5)
  final double relevanceScore;

  @HiveField(6)
  final String? sourceName;

  @HiveField(7)
  final DateTime extractedAt;

  @HiveField(8)
  final bool isSelected;

  @HiveField(9)
  final String? citationId;

  ExtractionResult({
    required this.id,
    required this.query,
    required this.text,
    required this.sourceId,
    this.pageNumber,
    required this.relevanceScore,
    this.sourceName,
    DateTime? extractedAt,
    this.isSelected = false,
    this.citationId,
  }) : extractedAt = extractedAt ?? DateTime.now();

  ExtractionResult copyWith({
    String? id,
    String? query,
    String? text,
    String? sourceId,
    int? pageNumber,
    double? relevanceScore,
    String? sourceName,
    DateTime? extractedAt,
    bool? isSelected,
    String? citationId,
  }) {
    return ExtractionResult(
      id: id ?? this.id,
      query: query ?? this.query,
      text: text ?? this.text,
      sourceId: sourceId ?? this.sourceId,
      pageNumber: pageNumber ?? this.pageNumber,
      relevanceScore: relevanceScore ?? this.relevanceScore,
      sourceName: sourceName ?? this.sourceName,
      extractedAt: extractedAt ?? this.extractedAt,
      isSelected: isSelected ?? this.isSelected,
      citationId: citationId ?? this.citationId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'query': query,
      'text': text,
      'sourceId': sourceId,
      'pageNumber': pageNumber,
      'relevanceScore': relevanceScore,
      'sourceName': sourceName,
      'extractedAt': extractedAt.toIso8601String(),
      'isSelected': isSelected,
      'citationId': citationId,
    };
  }

  factory ExtractionResult.fromMap(Map<String, dynamic> map) {
    return ExtractionResult(
      id: map['id'] ?? '',
      query: map['query'] ?? '',
      text: map['text'] ?? '',
      sourceId: map['sourceId'] ?? '',
      pageNumber: map['pageNumber'],
      relevanceScore: map['relevanceScore']?.toDouble() ?? 0.0,
      sourceName: map['sourceName'],
      extractedAt: DateTime.tryParse(map['extractedAt'] ?? ''),
      isSelected: map['isSelected'] ?? false,
      citationId: map['citationId'],
    );
  }
}

@HiveType(typeId: 9)
class UserModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  final String? phone;

  @HiveField(4)
  final String? photoUrl;

  @HiveField(5)
  final String? bio;

  @HiveField(6)
  final String language;

  @HiveField(7)
  final String theme;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final DateTime lastLoginAt;

  @HiveField(10)
  final bool isPremium;

  @HiveField(11)
  final String? subscriptionId;

  @HiveField(12)
  final DateTime? subscriptionExpiry;

  UserModel({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.photoUrl,
    this.bio,
    this.language = 'ar',
    this.theme = 'warm_sunset',
    DateTime? createdAt,
    DateTime? lastLoginAt,
    this.isPremium = false,
    this.subscriptionId,
    this.subscriptionExpiry,
  }) : createdAt = createdAt ?? DateTime.now(),
       lastLoginAt = lastLoginAt ?? DateTime.now();

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? bio,
    String? language,
    String? theme,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isPremium,
    String? subscriptionId,
    DateTime? subscriptionExpiry,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isPremium: isPremium ?? this.isPremium,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'bio': bio,
      'language': language,
      'theme': theme,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'isPremium': isPremium,
      'subscriptionId': subscriptionId,
      'subscriptionExpiry': subscriptionExpiry?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      photoUrl: map['photoUrl'],
      bio: map['bio'],
      language: map['language'] ?? 'ar',
      theme: map['theme'] ?? 'warm_sunset',
      createdAt: DateTime.tryParse(map['createdAt'] ?? ''),
      lastLoginAt: DateTime.tryParse(map['lastLoginAt'] ?? ''),
      isPremium: map['isPremium'] ?? false,
      subscriptionId: map['subscriptionId'],
      subscriptionExpiry: DateTime.tryParse(map['subscriptionExpiry'] ?? ''),
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(map).copyWith(id: doc.id);
  }
}
