import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/ocr_service.dart';
import 'ocr_result_page.dart';

class OcrHistoryPage extends StatefulWidget {
  const OcrHistoryPage({super.key});

  @override
  State<OcrHistoryPage> createState() => _OcrHistoryPageState();
}

class _OcrHistoryPageState extends State<OcrHistoryPage> {
  final OcrService _ocrService = OcrService();
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    if (!_hasMore && _currentPage > 1) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _ocrService.getOcrHistory();
      setState(() {
        if (_currentPage == 1) {
          _history = result;
        } else {
          _history.addAll(result);
        }
        _isLoading = false;
        _hasMore = result.length >= 20; // If we got 20 items, there might be more
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshHistory() async {
    setState(() {
      _currentPage = 1;
      _hasMore = true;
      _history = [];
    });
    await _loadHistory();
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown date';
    try {
      DateTime date;
      if (dateString.endsWith('Z')) {
        date = DateTime.parse(dateString);
      } else {
        date = DateTime.parse('${dateString}Z');
      }
      date = date.toLocal();
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          if (difference.inMinutes == 0) {
            return 'Just now';
          }
          return '${difference.inMinutes} minutes ago';
        }
        return '${difference.inHours} hours ago';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return DateFormat('MMM dd, yyyy').format(date);
      }
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildHistoryCard(Map<String, dynamic> item) {
    final translation = item['translation'] ?? 'No translation';
    final sentenceAnalysis = item['sentence_analysis'] as List? ?? [];
    final createdAt = item['created_at'];
    final detectedLanguage = item['detected_language'] ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to detail view
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OcrResultPage(
                ocrResult: {
                  'result': {
                    'translation': translation,
                    'sentence_analysis': sentenceAnalysis,
                    'detected_language': detectedLanguage,
                  },
                  'record_id': item['id'],
                },
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with date and language
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (detectedLanguage.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        detectedLanguage,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  Text(
                    _formatDate(createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Translation preview
              Text(
                translation,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),

              // Sentence count
              if (sentenceAnalysis.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${sentenceAnalysis.length} sentence${sentenceAnalysis.length > 1 ? 's' : ''} analyzed',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('OCR History'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshHistory,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading && _history.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null && _history.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading history',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _refreshHistory,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                )
              : _history.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 80,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No OCR history yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start translating images to see your history',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _refreshHistory,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _history.length + (_hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _history.length) {
                            // Load more indicator
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: _isLoading
                                    ? const CircularProgressIndicator()
                                    : ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _currentPage++;
                                          });
                                          _loadHistory();
                                        },
                                        child: const Text('Load More'),
                                      ),
                              ),
                            );
                          }
                          return _buildHistoryCard(_history[index]);
                        },
                      ),
                    ),
    );
  }
}
