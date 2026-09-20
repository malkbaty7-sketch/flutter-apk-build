import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nlp/nlp.dart';
import '../models/file_model.dart';
import '../database/database_service.dart';

class ExtractionService {
  final DatabaseService _dbService = DatabaseService();
  
  static final ExtractionService _instance = ExtractionService._internal();
  
  factory ExtractionService() => _instance;
  
  ExtractionService._internal();
  
  // Tokenizer for Arabic and English
  final _arabicTokenizer = ArabicTokenizer();
  final _englishTokenizer = EnglishTokenizer();
  
  // Stop words for filtering
  final _arabicStopWords = <String>{
    'و', 'في', 'من', 'إلى', 'على', 'أن', 'لا', 'ما', 'هذا', 'هذه',
    'ال', 'الذى', 'التى', 'الذين', 'اللاتي', 'من', 'في', 'عن', 'إلى',
    'على', 'ب', 'ك', 'ل', 'م', 'ه', 'ها', 'هم', 'هن', 'نا', 'كم',
    'أن', 'لا', 'ما', 'هذا', 'هذه', 'هذه', 'ذلك', 'تلك',
  };
  
  final _englishStopWords = <String>{
    'a', 'an', 'the', 'and', 'or', 'but', 'in', 'on', 'at', 'to',
    'for', 'of', 'with', 'by', 'from', 'as', 'is', 'was', 'are', 'were',
    'be', 'been', 'being', 'have', 'has', 'had', 'do', 'does', 'did',
    'will', 'would', 'should', 'could', 'may', 'might', 'must', 'can',
    'i', 'you', 'he', 'she', 'it', 'we', 'they', 'them', 'their',
  };
  
  Future<List<ExtractionResult>> extractByQuery(
    String query,
    List<String> sourceFileIds, {
    ExtractionType type = ExtractionType.semantic,
    int maxResults = 100,
    double minRelevance = 0.1,
  }) async {
    try {
      // Get all pages from source files
      final allPages = <PageModel>[];
      
      for (final fileId in sourceFileIds) {
        final pages = await _dbService.getPagesByFile(fileId);
        allPages.addAll(pages);
      }
      
      if (allPages.isEmpty) {
        return [];
      }
      
      // Get file models for source information
      final fileModels = <FileModel>[];
      for (final fileId in sourceFileIds) {
        final file = await _dbService.getFile(fileId);
        if (file != null) {
          fileModels.add(file);
        }
      }
      
      // Build inverted index for fast search
      final invertedIndex = _buildInvertedIndex(allPages, fileModels);
      
      // Tokenize query
      final queryTokens = _tokenize(query);
      
      // Calculate query vector
      final queryVector = _buildQueryVector(queryTokens, invertedIndex);
      
      // Calculate document vectors and score all pages
      final results = <ExtractionResult>[];
      
      for (final page in allPages) {
        if (page.text == null || page.text!.isEmpty) continue;
        
        final docVector = _buildDocumentVector(
          _tokenize(page.text!),
          invertedIndex,
        );
        
        final similarity = _cosineSimilarity(queryVector, docVector);
        
        if (similarity >= minRelevance) {
          final fileModel = fileModels.firstWhere(
            (f) => f.id == page.fileId,
            orElse: () => FileModel(
              id: page.fileId,
              name: 'Unknown',
              path: '',
              type: '',
              size: 0,
            ),
          );
          
          results.add(
            ExtractionResult(
              id: '',
              query: query,
              text: page.text!,
              sourceId: page.fileId,
              pageNumber: page.pageNumber,
              relevanceScore: similarity,
              sourceName: fileModel.name,
              citationId: null,
            ),
          );
        }
      }
      
      // Sort by relevance
      results.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
      
      // Limit results
      return results.take(maxResults).toList();
    } catch (e) {
      throw Exception('Failed to extract by query: $e');
    }
  }
  
  Map<String, Map<String, double>> _buildInvertedIndex(
    List<PageModel> pages,
    List<FileModel> files,
  ) {
    final invertedIndex = <String, Map<String, double>>{};
    
    for (final page in pages) {
      if (page.text == null || page.text!.isEmpty) continue;
      
      final tokens = _tokenize(page.text!);
      final tokenFreq = _calculateTermFrequency(tokens);
      
      for (final entry in tokenFreq.entries) {
        final term = entry.key;
        final freq = entry.value;
        
        if (!invertedIndex.containsKey(term)) {
          invertedIndex[term] = {};
        }
        
        // Use file ID + page number as document ID
        final docId = '${page.fileId}_${page.pageNumber}';
        invertedIndex[term]![docId] = freq;
      }
    }
    
    // Apply IDF weighting
    final docCount = pages.length;
    for (final entry in invertedIndex.entries) {
      final term = entry.key;
      final docFreq = entry.value.length;
      final idf = log(docCount / (1 + docFreq)) + 1;
      
      for (final docEntry in entry.value.entries) {
        invertedIndex[term]![docEntry.key] = docEntry.value * idf;
      }
    }
    
    return invertedIndex;
  }
  
  List<String> _tokenize(String text) {
    // Detect language
    final isArabic = _isArabicText(text);
    
    if (isArabic) {
      return _tokenizeArabic(text);
    } else {
      return _tokenizeEnglish(text);
    }
  }
  
  bool _isArabicText(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]');
    final arabicCount = arabicRegex.allMatches(text).length;
    final totalChars = text.length;
    return arabicCount > totalChars * 0.3;
  }
  
  List<String> _tokenizeArabic(String text) {
    try {
      final tokens = _arabicTokenizer.tokenize(text);
      return tokens
          .where((t) => t.isNotEmpty)
          .map((t) => t.toLowerCase())
          .where((t) => !_arabicStopWords.contains(t))
          .toList();
    } catch (e) {
      // Fallback to simple whitespace split
      return text
          .split(RegExp(r'\s+'))
          .where((t) => t.isNotEmpty)
          .map((t) => t.toLowerCase())
          .where((t) => !_arabicStopWords.contains(t))
          .toList();
    }
  }
  
  List<String> _tokenizeEnglish(String text) {
    try {
      final tokens = _englishTokenizer.tokenize(text);
      return tokens
          .where((t) => t.isNotEmpty)
          .map((t) => t.toLowerCase())
          .where((t) => !_englishStopWords.contains(t))
          .toList();
    } catch (e) {
      // Fallback to simple whitespace split
      return text
          .split(RegExp(r'\s+'))
          .where((t) => t.isNotEmpty)
          .map((t) => t.toLowerCase())
          .where((t) => !_englishStopWords.contains(t))
          .toList();
    }
  }
  
  Map<String, double> _calculateTermFrequency(List<String> tokens) {
    final freqMap = <String, double>{};
    final totalTokens = tokens.length;
    
    for (final token in tokens) {
      freqMap[token] = (freqMap[token] ?? 0) + 1;
    }
    
    // Normalize by total tokens
    for (final entry in freqMap.entries) {
      freqMap[entry.key] = entry.value / totalTokens;
    }
    
    return freqMap;
  }
  
  Map<String, double> _buildQueryVector(
    List<String> queryTokens,
    Map<String, Map<String, double>> invertedIndex,
  ) {
    final vector = <String, double>{};
    final queryTermFreq = _calculateTermFrequency(queryTokens);
    
    for (final entry in queryTermFreq.entries) {
      final term = entry.key;
      final freq = entry.value;
      
      if (invertedIndex.containsKey(term)) {
        // Use IDF from inverted index
        final idf = invertedIndex[term]!.values.isNotEmpty
            ? invertedIndex[term]!.values.first
            : 1.0;
        vector[term] = freq * idf;
      } else {
        // Term not in index, use frequency only
        vector[term] = freq;
      }
    }
    
    return vector;
  }
  
  Map<String, double> _buildDocumentVector(
    List<String> docTokens,
    Map<String, Map<String, double>> invertedIndex,
  ) {
    final vector = <String, double>{};
    final docTermFreq = _calculateTermFrequency(docTokens);
    
    for (final entry in docTermFreq.entries) {
      final term = entry.key;
      final freq = entry.value;
      
      if (invertedIndex.containsKey(term)) {
        // Use IDF from inverted index
        final idf = invertedIndex[term]!.values.isNotEmpty
            ? invertedIndex[term]!.values.first
            : 1.0;
        vector[term] = freq * idf;
      } else {
        // Term not in index, use frequency only
        vector[term] = freq;
      }
    }
    
    return vector;
  }
  
  double _cosineSimilarity(
    Map<String, double> vectorA,
    Map<String, double> vectorB,
  ) {
    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;
    
    // Calculate dot product
    for (final entry in vectorA.entries) {
      final term = entry.key;
      final valueA = entry.value;
      final valueB = vectorB[term] ?? 0.0;
      
      dotProduct += valueA * valueB;
      normA += valueA * valueA;
    }
    
    // Calculate norm of vector B
    for (final entry in vectorB.entries) {
      final valueB = entry.value;
      normB += valueB * valueB;
    }
    
    if (normA == 0 || normB == 0) {
      return 0.0;
    }
    
    return dotProduct / (sqrt(normA) * sqrt(normB));
  }
  
  Future<List<ExtractionResult>> extractLiterally(
    String query,
    List<String> sourceFileIds, {
    int maxResults = 100,
  }) async {
    try {
      final results = <ExtractionResult>[];
      final queryLower = query.toLowerCase();
      
      for (final fileId in sourceFileIds) {
        final pages = await _dbService.getPagesByFile(fileId);
        final file = await _dbService.getFile(fileId);
        
        if (file == null) continue;
        
        for (final page in pages) {
          if (page.text == null || page.text!.isEmpty) continue;
          
          final textLower = page.text!.toLowerCase();
          
          if (textLower.contains(queryLower)) {
            results.add(
              ExtractionResult(
                id: '',
                query: query,
                text: page.text!,
                sourceId: fileId,
                pageNumber: page.pageNumber,
                relevanceScore: 1.0, // Exact match
                sourceName: file.name,
              ),
            );
          }
        }
      }
      
      // Sort by page number
      results.sort((a, b) => a.pageNumber?.compareTo(b.pageNumber ?? 0) ?? 0);
      
      return results.take(maxResults).toList();
    } catch (e) {
      throw Exception('Failed to extract literally: $e');
    }
  }
  
  Future<List<ExtractionResult>> extractDefinitions(
    String term,
    List<String> sourceFileIds, {
    int maxResults = 20,
  }) async {
    try {
      final results = <ExtractionResult>[];
      final termLower = term.toLowerCase();
      
      // Patterns for definitions
      final definitionPatterns = [
        RegExp(r'($termLower\s+(هو|هي|يعني|تعني|مقصود|مفهم|يطلق على|تسمى|يسمى|يرمز لها|يرمز إليه)|(هو|هي|يعني|تعني|مقصود|مفهم|يطلق على|تسمى|يسمى|يرمز لها|يرمز إليه)\s+$termLower)', CaseSensitive: false),
        RegExp(r'\b$termLower\b[\s\S]{0,200}?(هو|هي|يعني|تعني|مقصود|مفهم|يطلق على|تسمى|يسمى|يرمز لها|يرمز إليه)', CaseSensitive: false),
        RegExp(r'(هو|هي|يعني|تعني|مقصود|مفهم|يطلق على|تسمى|يسمى|يرمز لها|يرمز إليه)[\s\S]{0,200}?\b$termLower\b', CaseSensitive: false),
      ];
      
      for (final fileId in sourceFileIds) {
        final pages = await _dbService.getPagesByFile(fileId);
        final file = await _dbService.getFile(fileId);
        
        if (file == null) continue;
        
        for (final page in pages) {
          if (page.text == null || page.text!.isEmpty) continue;
          
          for (final pattern in definitionPatterns) {
            final matches = pattern.allMatches(page.text!);
            
            for (final match in matches) {
              final matchText = page.text!.substring(
                max(0, match.start - 50),
                min(page.text!.length, match.end + 50),
              );
              
              results.add(
                ExtractionResult(
                  id: '',
                  query: term,
                  text: matchText,
                  sourceId: fileId,
                  pageNumber: page.pageNumber,
                  relevanceScore: 0.9,
                  sourceName: file.name,
                ),
              );
            }
          }
        }
      }
      
      // Remove duplicates
      final uniqueResults = <ExtractionResult>[];
      final seenTexts = <String>{};
      
      for (final result in results) {
        if (!seenTexts.contains(result.text)) {
          seenTexts.add(result.text!);
          uniqueResults.add(result);
        }
      }
      
      return uniqueResults.take(maxResults).toList();
    } catch (e) {
      throw Exception('Failed to extract definitions: $e');
    }
  }
  
  Future<List<ExtractionResult>> extractNumbers(
    String query,
    List<String> sourceFileIds, {
    int maxResults = 50,
  }) async {
    try {
      final results = <ExtractionResult>[];
      
      // Extract all numbers from source files
      for (final fileId in sourceFileIds) {
        final pages = await _dbService.getPagesByFile(fileId);
        final file = await _dbService.getFile(fileId);
        
        if (file == null) continue;
        
        for (final page in pages) {
          if (page.text == null || page.text!.isEmpty) continue;
          
          // Find all numbers in the text
          final numberRegex = RegExp(r'\d+[.,]?\d*%?');
          final matches = numberRegex.allMatches(page.text!);
          
          for (final match in matches) {
            final numberText = match.group(0)!;
            
            // Get context around the number
            final start = max(0, match.start - 100);
            final end = min(page.text!.length, match.end + 100);
            final context = page.text!.substring(start, end);
            
            results.add(
              ExtractionResult(
                id: '',
                query: query,
                text: context,
                sourceId: fileId,
                pageNumber: page.pageNumber,
                relevanceScore: _calculateNumberRelevance(numberText, query),
                sourceName: file.name,
              ),
            );
          }
        }
      }
      
      // Sort by relevance
      results.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
      
      return results.take(maxResults).toList();
    } catch (e) {
      throw Exception('Failed to extract numbers: $e');
    }
  }
  
  double _calculateNumberRelevance(String number, String query) {
    // Check if query contains the number
    if (query.contains(number)) {
      return 1.0;
    }
    
    // Check if query contains similar numbers
    final queryNumbers = RegExp(r'\d+[.,]?\d*%?').allMatches(query)
        .map((m) => m.group(0)!)
        .toList();
    
    for (final qNum in queryNumbers) {
      if (number.contains(qNum) || qNum.contains(number)) {
        return 0.8;
      }
    }
    
    return 0.1;
  }
  
  Future<List<ExtractionResult>> extractQuotes(
    List<String> sourceFileIds, {
    int maxResults = 50,
    String? authorFilter,
  }) async {
    try {
      final results = <ExtractionResult>[];
      
      for (final fileId in sourceFileIds) {
        final pages = await _dbService.getPagesByFile(fileId);
        final file = await _dbService.getFile(fileId);
        
        if (file == null) continue;
        
        // Skip if author filter doesn't match
        if (authorFilter != null && 
            authorFilter.isNotEmpty && 
            file.author != null &&
            !file.author!.contains(authorFilter)) {
          continue;
        }
        
        for (final page in pages) {
          if (page.text == null || page.text!.isEmpty) continue;
          
          // Look for quote patterns
          final quotePatterns = [
            RegExp(r'"[^"]{20,500}"'),
            RegExp(r'"[^"]{50,}"'),
            RegExp(r'\u201C[^\u201D]{20,500}\u201D'),
            RegExp(r'\u201C[^\u201D]{50,}\u201D'),
          ];
          
          for (final pattern in quotePatterns) {
            final matches = pattern.allMatches(page.text!);
            
            for (final match in matches) {
              final quoteText = match.group(0)!;
              
              results.add(
                ExtractionResult(
                  id: '',
                  query: 'quotes',
                  text: quoteText,
                  sourceId: fileId,
                  pageNumber: page.pageNumber,
                  relevanceScore: 0.8,
                  sourceName: file.name,
                ),
              );
            }
          }
        }
      }
      
      return results.take(maxResults).toList();
    } catch (e) {
      throw Exception('Failed to extract quotes: $e');
    }
  }
  
  Future<ExtractionResult> createSummary(
    List<String> sourceFileIds,
    String query, {
    int maxLength = 1000,
  }) async {
    try {
      // Get all relevant text from sources
      final allTexts = <String>[];
      
      for (final fileId in sourceFileIds) {
        final pages = await _dbService.getPagesByFile(fileId);
        
        for (final page in pages) {
          if (page.text != null && page.text!.isNotEmpty) {
            allTexts.add(page.text!);
          }
        }
      }
      
      if (allTexts.isEmpty) {
        return ExtractionResult(
          id: '',
          query: query,
          text: '',
          sourceId: '',
          relevanceScore: 0.0,
        );
      }
      
      // Combine all text
      final combinedText = allTexts.join('\n\n');
      
      // Simple summarization: take first N sentences that contain query terms
      final sentences = _splitIntoSentences(combinedText);
      final queryTokens = _tokenize(query);
      
      final relevantSentences = <String>[];
      
      for (final sentence in sentences) {
        if (relevantSentences.length >= maxLength ~/ 100) break;
        
        final sentenceTokens = _tokenize(sentence);
        final intersection = sentenceTokens.toSet().intersection(queryTokens.toSet());
        
        if (intersection.isNotEmpty) {
          relevantSentences.add(sentence);
        }
      }
      
      // If we don't have enough relevant sentences, add more
      if (relevantSentences.length < 3 && sentences.isNotEmpty) {
        relevantSentences.addAll(
          sentences.take(min(3, sentences.length))
        );
      }
      
      final summary = relevantSentences.join(' ');
      
      return ExtractionResult(
        id: '',
        query: query,
        text: summary,
        sourceId: sourceFileIds.join(','),
        relevanceScore: 1.0,
      );
    } catch (e) {
      throw Exception('Failed to create summary: $e');
    }
  }
  
  List<String> _splitIntoSentences(String text) {
    // Simple sentence splitting for Arabic and English
    final sentences = <String>[];
    
    // Split by sentence-ending punctuation
    final splitRegex = RegExp(r'[.!?]+[\s\n]+');
    final parts = splitRegex.split(text);
    
    for (final part in parts) {
      if (part.trim().isNotEmpty) {
        sentences.add(part.trim());
      }
    }
    
    return sentences;
  }
  
  Future<void> close() async {
    // Cleanup if needed
  }
  
  static Future<void> dispose() async {
    await _instance.close();
  }
}

enum ExtractionType {
  literal,
  semantic,
  definitions,
  numbers,
  quotes,
  summary,
  comparison,
  arguments,
}
