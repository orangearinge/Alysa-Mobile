import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class OcrResultPage extends StatelessWidget {
  final Map<String, dynamic> ocrResult;
  final File? imageFile;
  final XFile? webImage;

  const OcrResultPage({
    super.key,
    required this.ocrResult,
    this.imageFile,
    this.webImage,
  });

  String _formatResult() {
    final result = ocrResult['result'];
    if (result == null) return 'No result available';

    final StringBuffer buffer = StringBuffer();

    // Translation
    if (result['translation'] != null) {
      buffer.writeln('📝 Translation:');
      buffer.writeln(result['translation']);
      buffer.writeln();
    }

    // Sentence Analysis
    if (result['sentence_analysis'] != null &&
        result['sentence_analysis'] is List) {
      buffer.writeln('📚 Sentence Analysis:');
      buffer.writeln();

      final List analyses = result['sentence_analysis'];
      for (int i = 0; i < analyses.length; i++) {
        final analysis = analyses[i];
        buffer.writeln('${i + 1}. ${analysis['sentence'] ?? ''}');
        buffer.writeln('   Grammar: ${analysis['grammar_point'] ?? ''}');
        buffer.writeln('   Explanation: ${analysis['explanation'] ?? ''}');
        if (i < analyses.length - 1) buffer.writeln();
      }
    }

    return buffer.toString();
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: _formatResult()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hasil berhasil disalin ke clipboard'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = ocrResult['result'];
    final translation = result?['translation'] ?? '';
    final sentenceAnalysis = result?['sentence_analysis'] as List? ?? [];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Hasil OCR Translation'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Preview
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey.shade200,
              child: _buildImagePreview(),
            ),

            // Results Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Translation Section
                  if (translation.isNotEmpty) ...[
                    _buildSectionTitle('📝 Translation'),
                    const SizedBox(height: 8),
                    _buildCard(
                      child: Text(
                        translation,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Sentence Analysis Section
                  if (sentenceAnalysis.isNotEmpty) ...[
                    _buildSectionTitle('📚 Sentence Analysis'),
                    const SizedBox(height: 12),
                    ...sentenceAnalysis.asMap().entries.map((entry) {
                      final index = entry.key;
                      final analysis = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildAnalysisCard(
                          index: index + 1,
                          sentence: analysis['sentence'] ?? '',
                          grammarPoint: analysis['grammar_point'] ?? '',
                          explanation: analysis['explanation'] ?? '',
                        ),
                      );
                    }).toList(),
                  ],

                  // Record ID
                  if (ocrResult['record_id'] != null) ...[
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Record ID: ${ocrResult['record_id']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 80), // Space for floating button
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _copyToClipboard(context),
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.copy),
        label: const Text('Copy Hasil'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildImagePreview() {
    if (kIsWeb && webImage != null) {
      return Image.network(
        webImage!.path,
        fit: BoxFit.contain,
      );
    } else if (!kIsWeb && imageFile != null) {
      return Image.file(
        imageFile!,
        fit: BoxFit.contain,
      );
    } else {
      return const Center(
        child: Icon(
          Icons.image,
          size: 80,
          color: Colors.grey,
        ),
      );
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildAnalysisCard({
    required int index,
    required String sentence,
    required String grammarPoint,
    required String explanation,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Index and Sentence
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  sentence,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Grammar Point
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.school,
                  size: 16,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    grammarPoint,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Explanation
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 18,
                  color: Colors.orange.shade700,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    explanation,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade800,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
