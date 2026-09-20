import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_text/pdf_text.dart';
import 'package:docx_template/docx_template.dart';
import 'package:epubx/epubx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import '../models/file_model.dart';
import 'ocr_service.dart';

class DocumentService {
  final OCRService _ocrService = OCRService();
  
  static final DocumentService _instance = DocumentService._internal();
  
  factory DocumentService() => _instance;
  
  DocumentService._internal();
  
  // ============ PDF PROCESSING ============
  
  Future<FileModel> processPdfFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('PDF file not found');
      }
      
      final bytes = await file.readAsBytes();
      final pdfDoc = await PDFDoc.fromBytes(bytes);
      
      final pageCount = pdfDoc.length;
      final textPages = <String>[];
      
      for (var i = 0; i < pageCount; i++) {
        final page = await pdfDoc.page(i + 1);
        final text = await page.text;
        textPages.add(text);
      }
      
      // Create file model
      final fileModel = FileModel(
        id: '',
        name: file.path.split('/').last.replaceAll('.pdf', ''),
        path: filePath,
        type: FileType.pdf.name,
        size: bytes.length,
        pageCount: pageCount,
        wordCount: textPages.join(' ').split(RegExp(r'\s+')).length,
        mimeType: 'application/pdf',
        language: _detectLanguage(textPages.join(' ')),
      );
      
      return fileModel;
    } catch (e) {
      throw Exception('Failed to process PDF: $e');
    }
  }
  
  Future<List<Uint8List>> extractPdfPagesAsImages(String filePath, {int? maxPages}) async {
    final images = <Uint8List>[];
    
    try {
      // This would use a PDF to image conversion library
      // For now, we'll return empty list as placeholder
      // In production, use: pdf_image or similar package
      
      // Placeholder: In real implementation, convert each PDF page to image
      // for (var i = 0; i < pageCount && (maxPages == null || i < maxPages); i++) {
      //   final image = await _convertPdfPageToImage(filePath, i);
      //   images.add(image);
      // }
      
    } catch (e) {
      throw Exception('Failed to extract PDF pages as images: $e');
    }
    
    return images;
  }
  
  Future<String> extractPdfText(String filePath) async {
    try {
      final pdfDoc = await PDFDoc.fromPath(filePath);
      final textPages = <String>[];
      
      for (var i = 0; i < pdfDoc.length; i++) {
        final page = await pdfDoc.page(i + 1);
        final text = await page.text;
        textPages.add(text);
      }
      
      return textPages.join('\n\n');
    } catch (e) {
      throw Exception('Failed to extract PDF text: $e');
    }
  }
  
  // ============ DOCX PROCESSING ============
  
  Future<FileModel> processDocxFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('DOCX file not found');
      }
      
      final bytes = await file.readAsBytes();
      final docx = await Docx.fromBytes(bytes);
      
      final text = docx.text;
      final wordCount = text.split(RegExp(r'\s+')).length;
      
      final fileModel = FileModel(
        id: '',
        name: file.path.split('/').last.replaceAll('.docx', ''),
        path: filePath,
        type: FileType.docx.name,
        size: bytes.length,
        pageCount: 1, // DOCX doesn't have pages in the same way
        wordCount: wordCount,
        mimeType: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        language: _detectLanguage(text),
      );
      
      return fileModel;
    } catch (e) {
      throw Exception('Failed to process DOCX: $e');
    }
  }
  
  Future<String> extractDocxText(String filePath) async {
    try {
      final docx = await Docx.fromPath(filePath);
      return docx.text;
    } catch (e) {
      throw Exception('Failed to extract DOCX text: $e');
    }
  }
  
  // ============ TXT PROCESSING ============
  
  Future<FileModel> processTxtFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('TXT file not found');
      }
      
      final content = await file.readAsString();
      final bytes = await file.readAsBytes();
      
      final wordCount = content.split(RegExp(r'\s+')).length;
      
      final fileModel = FileModel(
        id: '',
        name: file.path.split('/').last.replaceAll('.txt', ''),
        path: filePath,
        type: FileType.txt.name,
        size: bytes.length,
        pageCount: 1,
        wordCount: wordCount,
        mimeType: 'text/plain',
        language: _detectLanguage(content),
      );
      
      return fileModel;
    } catch (e) {
      throw Exception('Failed to process TXT: $e');
    }
  }
  
  // ============ EPUB PROCESSING ============
  
  Future<FileModel> processEpubFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('EPUB file not found');
      }
      
      final bytes = await file.readAsBytes();
      final epub = await EpubReader.readBytes(bytes);
      
      final textContent = _extractEpubText(epub);
      final wordCount = textContent.split(RegExp(r'\s+')).length;
      
      final fileModel = FileModel(
        id: '',
        name: file.path.split('/').last.replaceAll('.epub', ''),
        path: filePath,
        type: FileType.epub.name,
        size: bytes.length,
        pageCount: epub.Sections?.length ?? 0,
        wordCount: wordCount,
        mimeType: 'application/epub+zip',
        language: _detectLanguage(textContent),
        author: epub.Author,
      );
      
      return fileModel;
    } catch (e) {
      throw Exception('Failed to process EPUB: $e');
    }
  }
  
  String _extractEpubText(EpubBook epub) {
    final buffer = StringBuffer();
    
    if (epub.Sections != null) {
      for (final section in epub.Sections!) {
        if (section.HtmlContent != null) {
          // Simple HTML to text conversion
          buffer.writeln(_htmlToText(section.HtmlContent!));
        }
      }
    }
    
    return buffer.toString();
  }
  
  String _htmlToText(String html) {
    // Simple HTML to text conversion
    // Remove all HTML tags
    return html.replaceAll(RegExp(r'<[^>]*>'), ' ')
               .replaceAll(RegExp(r'\s+'), ' ')
               .trim();
  }
  
  // ============ IMAGE PROCESSING (with OCR) ============
  
  Future<FileModel> processImageFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('Image file not found');
      }
      
      final bytes = await file.readAsBytes();
      
      // Use OCR to extract text
      final text = await _ocrService.processImageBytes(bytes, language: 'ar');
      final wordCount = text.split(RegExp(r'\s+')).length;
      
      final fileModel = FileModel(
        id: '',
        name: file.path.split('/').last,
        path: filePath,
        type: FileType.image.name,
        size: bytes.length,
        pageCount: 1,
        wordCount: wordCount,
        mimeType: _getImageMimeType(filePath),
        language: _detectLanguage(text),
      );
      
      return fileModel;
    } catch (e) {
      throw Exception('Failed to process image: $e');
    }
  }
  
  String _getImageMimeType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'tiff':
        return 'image/tiff';
      case 'gif':
        return 'image/gif';
      default:
        return 'image/*';
    }
  }
  
  // ============ PPTX PROCESSING ============
  
  Future<FileModel> processPptxFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('PPTX file not found');
      }
      
      final bytes = await file.readAsBytes();
      
      // Extract text from PPTX
      // This would use a PPTX parsing library
      final text = await _extractPptxText(bytes);
      final wordCount = text.split(RegExp(r'\s+')).length;
      
      final fileModel = FileModel(
        id: '',
        name: file.path.split('/').last.replaceAll('.pptx', ''),
        path: filePath,
        type: FileType.pptx.name,
        size: bytes.length,
        pageCount: 1, // Would be number of slides
        wordCount: wordCount,
        mimeType: 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
        language: _detectLanguage(text),
      );
      
      return fileModel;
    } catch (e) {
      throw Exception('Failed to process PPTX: $e');
    }
  }
  
  Future<String> _extractPptxText(Uint8List bytes) async {
    // Placeholder: In real implementation, use a PPTX parsing library
    // For now, return empty string
    return '';
  }
  
  // ============ XLSX PROCESSING ============
  
  Future<FileModel> processXlsxFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('XLSX file not found');
      }
      
      final bytes = await file.readAsBytes();
      
      // Extract text from XLSX
      final text = await _extractXlsxText(bytes);
      final wordCount = text.split(RegExp(r'\s+')).length;
      
      final fileModel = FileModel(
        id: '',
        name: file.path.split('/').last.replaceAll('.xlsx', ''),
        path: filePath,
        type: FileType.xlsx.name,
        size: bytes.length,
        pageCount: 1,
        wordCount: wordCount,
        mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        language: _detectLanguage(text),
      );
      
      return fileModel;
    } catch (e) {
      throw Exception('Failed to process XLSX: $e');
    }
  }
  
  Future<String> _extractXlsxText(Uint8List bytes) async {
    // Placeholder: In real implementation, use an XLSX parsing library
    return '';
  }
  
  // ============ FILE TYPE DETECTION ============
  
  FileType detectFileType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    
    switch (extension) {
      case 'pdf':
        return FileType.pdf;
      case 'docx':
      case 'doc':
        return FileType.docx;
      case 'txt':
      case 'rtf':
      case 'odt':
        return FileType.txt;
      case 'epub':
        return FileType.epub;
      case 'pptx':
      case 'ppt':
        return FileType.pptx;
      case 'xlsx':
      case 'xls':
      case 'csv':
        return FileType.xlsx;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'webp':
      case 'tiff':
      case 'gif':
        return FileType.image;
      default:
        return FileType.unknown;
    }
  }
  
  // ============ LANGUAGE DETECTION ============
  
  String _detectLanguage(String text) {
    if (text.isEmpty) return 'unknown';
    
    // Simple heuristic: check for Arabic characters
    final arabicRegex = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]');
    final englishRegex = RegExp(r'[a-zA-Z]');
    
    final arabicCount = arabicRegex.allMatches(text).length;
    final englishCount = englishRegex.allMatches(text).length;
    
    if (arabicCount > englishCount) {
      return 'ar';
    } else if (englishCount > 0) {
      return 'en';
    }
    
    return 'unknown';
  }
  
  // ============ EXPORT SERVICES ============
  
  Future<Uint8List> exportProjectToPdf(ProjectModel project) async {
    final pdf = pw.Document();
    
    // Add cover page
    if (project.coverImagePath != null) {
      // Would add cover image here
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Text(
                project.name,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            );
          },
        ),
      );
    }
    
    // Add sections
    for (final section in project.sections) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  section.title,
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                ..._buildContentBlocks(section.contentBlocks),
              ],
            );
          },
        ),
      );
    }
    
    return await pdf.save();
  }
  
  List<pw.Widget> _buildContentBlocks(List<ContentBlock> blocks) {
    final widgets = <pw.Widget>[];
    
    for (final block in blocks) {
      switch (block.type) {
        case ContentType.heading1:
          widgets.add(
            pw.Text(
              block.text ?? '',
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          );
          break;
        case ContentType.heading2:
          widgets.add(
            pw.Text(
              block.text ?? '',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          );
          break;
        case ContentType.heading3:
          widgets.add(
            pw.Text(
              block.text ?? '',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          );
          break;
        case ContentType.paragraph:
        case ContentType.text:
          widgets.add(
            pw.Text(
              block.text ?? '',
              style: pw.TextStyle(fontSize: 12),
            ),
          );
          break;
        case ContentType.image:
          // Would add image here
          break;
        case ContentType.table:
          // Would add table here
          break;
        case ContentType.list:
          // Would add list here
          break;
        case ContentType.quote:
          widgets.add(
            pw.Padding(
              padding: pw.EdgeInsets.all(10),
              child: pw.Text(
                block.text ?? '',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
          );
          break;
        default:
          widgets.add(pw.SizedBox(height: 10));
      }
      widgets.add(pw.SizedBox(height: 5));
    }
    
    return widgets;
  }
  
  Future<Uint8List> exportProjectToDocx(ProjectModel project) async {
    // Placeholder: In real implementation, use a DOCX generation library
    throw UnimplementedError('DOCX export not implemented yet');
  }
  
  Future<Uint8List> exportProjectToEpub(ProjectModel project) async {
    // Placeholder: In real implementation, use an EPUB generation library
    throw UnimplementedError('EPUB export not implemented yet');
  }
  
  Future<Uint8List> exportProjectToPptx(ProjectModel project) async {
    // Placeholder: In real implementation, use a PPTX generation library
    throw UnimplementedError('PPTX export not implemented yet');
  }
  
  Future<void> exportToFile(Uint8List data, String fileName, String mimeType) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final filePath = '${appDir.path}/$fileName';
      
      final file = File(filePath);
      await file.writeAsBytes(data);
      
      // Open the file
      await Printing.sharePdf(
        bytes: data,
        filename: fileName,
      );
    } catch (e) {
      throw Exception('Failed to export file: $e');
    }
  }
  
  // ============ TEXT SEARCH ============
  
  Future<List<SearchResult>> searchInDocument(String fileId, String query) async {
    // This would search through the pages of a document
    // For now, return empty list
    return [];
  }
  
  Future<List<SearchResult>> searchInProject(String projectId, String query) async {
    // This would search through the content of a project
    // For now, return empty list
    return [];
  }
  
  // ============ CLEANUP ============
  
  Future<void> close() async {
    await _ocrService.close();
  }
  
  static Future<void> dispose() async {
    await _instance.close();
  }
}

class SearchResult {
  final String id;
  final String text;
  final int pageNumber;
  final double relevance;
  final String sourceId;
  
  SearchResult({
    required this.id,
    required this.text,
    required this.pageNumber,
    required this.relevance,
    required this.sourceId,
  });
}

enum FileType {
  pdf,
  docx,
  txt,
  epub,
  pptx,
  xlsx,
  image,
  unknown,
}
