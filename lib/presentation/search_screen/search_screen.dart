import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

import './widgets/advanced_filters_widget.dart';
import './widgets/barcode_scanner_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/popular_categories_widget.dart';
import './widgets/recent_searches_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/search_results_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final SpeechToText _speechToText = SpeechToText();

  CameraController? _cameraController;
  List<CameraDescription>? _cameras;

  Timer? _debounceTimer;

  String _searchQuery = '';
  List<SearchResult> _searchResults = [];
  List<String> _recentSearches = [];
  List<String> _suggestions = [];
  Map<String, dynamic> _activeFilters = {};

  bool _isSearching = false;
  bool _isListening = false;
  bool _isGridView = false;
  bool _showAdvancedFilters = false;
  bool _showBarcodeScanner = false;
  bool _speechEnabled = false;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _initializeCamera();
    _loadRecentSearches();
    _loadPopularCategories();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _cameraController?.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeSpeech() async {
    try {
      _speechEnabled = await _speechToText.initialize();
      setState(() {});
    } catch (e) {
      debugPrint('Speech initialization failed: $e');
    }
  }

  Future<void> _initializeCamera() async {
    try {
      if (await _requestCameraPermission()) {
        _cameras = await availableCameras();
        if (_cameras != null && _cameras!.isNotEmpty) {
          _cameraController = CameraController(
            _cameras!.first,
            ResolutionPreset.high,
          );
          await _cameraController!.initialize();
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Camera initialization failed: $e');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  void _onSearchChanged() {
    final query = _searchController.text;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query != _searchQuery) {
        setState(() {
          _searchQuery = query;
        });
        _performSearch(query);
      }
    });

    // Update suggestions immediately
    _updateSuggestions(query);
  }

  void _updateSuggestions(String query) {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    // Mock suggestions based on query
    final mockSuggestions = [
      'MacBook Pro',
      'iPhone 14',
      'Samsung Galaxy',
      'iPad Air',
      'AirPods Pro',
      'Dell XPS',
      'ThinkPad',
      'Surface Pro',
      'Chemistry textbook',
      'Physics notes',
      'Calculus book',
      'Biology lab manual',
    ];

    setState(() {
      _suggestions = mockSuggestions
          .where((suggestion) =>
              suggestion.toLowerCase().contains(query.toLowerCase()))
          .take(5)
          .toList();
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Add to recent searches
    _addToRecentSearches(query);

    // Simulate search delay
    Timer(const Duration(milliseconds: 800), () {
      setState(() {
        _searchResults = _getMockSearchResults(query);
        _isSearching = false;
      });
    });
  }

  List<SearchResult> _getMockSearchResults(String query) {
    // Mock search results
    final mockResults = [
      SearchResult(
        id: '1',
        title: 'MacBook Pro 16" M2 Pro',
        price: 1899.99,
        condition: 'Excellent',
        imageUrl:
            'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400&h=400&fit=crop',
        sellerName: 'John Doe',
        distance: '0.5 km',
        campus: 'Main Campus',
        category: 'Electronics',
        tags: ['laptop', 'macbook', 'apple'],
        rating: 4.8,
        isVerified: true,
        postedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      SearchResult(
        id: '2',
        title: 'iPhone 14 Pro Max 256GB',
        price: 899.99,
        condition: 'Like New',
        imageUrl:
            'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400&h=400&fit=crop',
        sellerName: 'Sarah Johnson',
        distance: '1.2 km',
        campus: 'North Campus',
        category: 'Electronics',
        tags: ['phone', 'iphone', 'apple'],
        rating: 4.9,
        isVerified: true,
        postedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      SearchResult(
        id: '3',
        title: 'Chemistry Textbook 12th Edition',
        price: 45.00,
        condition: 'Good',
        imageUrl:
            'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&h=400&fit=crop',
        sellerName: 'Mike Chen',
        distance: '0.8 km',
        campus: 'Main Campus',
        category: 'Books',
        tags: ['textbook', 'chemistry', 'education'],
        rating: 4.5,
        isVerified: false,
        postedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      SearchResult(
        id: '4',
        title: 'Gaming Chair RGB LED',
        price: 150.00,
        condition: 'Very Good',
        imageUrl:
            'https://images.unsplash.com/photo-1541558869434-2840d308329a?w=400&h=400&fit=crop',
        sellerName: 'Alex Rodriguez',
        distance: '2.1 km',
        campus: 'South Campus',
        category: 'Furniture',
        tags: ['chair', 'gaming', 'furniture'],
        rating: 4.6,
        isVerified: true,
        postedAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
    ];

    return mockResults
        .where((result) =>
            result.title.toLowerCase().contains(query.toLowerCase()) ||
            result.tags
                .any((tag) => tag.toLowerCase().contains(query.toLowerCase())))
        .toList();
  }

  void _addToRecentSearches(String query) {
    setState(() {
      _recentSearches.removeWhere((search) => search == query);
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 10) {
        _recentSearches = _recentSearches.take(10).toList();
      }
    });
  }

  void _loadRecentSearches() {
    // Mock recent searches
    setState(() {
      _recentSearches = [
        'MacBook Pro',
        'iPhone',
        'Chemistry textbook',
        'Gaming chair',
        'iPad',
      ];
    });
  }

  void _loadPopularCategories() {
    // Categories are loaded in PopularCategoriesWidget
  }

  void _startListening() async {
    if (!_speechEnabled) return;

    try {
      await _speechToText.listen(
        onResult: (result) {
          setState(() {
            _searchController.text = result.recognizedWords;
            _isListening = false;
          });
        },
        listenFor: const Duration(seconds: 5),
        pauseFor: const Duration(seconds: 2),
      );

      setState(() {
        _isListening = true;
      });
    } catch (e) {
      debugPrint('Speech recognition failed: $e');
    }
  }

  void _stopListening() {
    _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _openBarcodeScanner() {
    setState(() {
      _showBarcodeScanner = true;
    });
  }

  void _closeBarcodeScanner() {
    setState(() {
      _showBarcodeScanner = false;
    });
  }

  void _onBarcodeScanned(String barcode) {
    _closeBarcodeScanner();
    _searchController.text = barcode;
    _performSearch(barcode);
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _activeFilters = filters;
      _showAdvancedFilters = false;
    });

    // Re-perform search with new filters
    _performSearch(_searchQuery);
  }

  void _clearFilters() {
    setState(() {
      _activeFilters = {};
    });
    _performSearch(_searchQuery);
  }

  void _removeFilter(String filterKey) {
    setState(() {
      _activeFilters.remove(filterKey);
    });
    _performSearch(_searchQuery);
  }

  void _onSuggestionTap(String suggestion) {
    _searchController.text = suggestion;
    _performSearch(suggestion);
  }

  void _onRecentSearchTap(String search) {
    _searchController.text = search;
    _performSearch(search);
  }

  void _removeRecentSearch(String search) {
    setState(() {
      _recentSearches.remove(search);
    });
  }

  void _clearAllRecentSearches() {
    setState(() {
      _recentSearches.clear();
    });
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort by',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...[
              'Relevance',
              'Price: Low to High',
              'Price: High to Low',
              'Distance',
              'Newest First'
            ].map((option) {
              return ListTile(
                title: Text(option),
                onTap: () {
                  Navigator.pop(context);
                  // Apply sort
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: SearchBarWidget(
          controller: _searchController,
          onVoiceSearch: _speechEnabled ? _startListening : null,
          onBarcodeScanner: _isCameraInitialized ? _openBarcodeScanner : null,
          suggestions: _suggestions,
          onSuggestionTap: _onSuggestionTap,
          isListening: _isListening,
        ),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: _toggleView,
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortOptions,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Filter chips
              FilterChipsWidget(
                activeFilters: _activeFilters,
                onFilterRemoved: _removeFilter,
                onClearAll: _clearFilters,
                onShowAdvancedFilters: () {
                  setState(() {
                    _showAdvancedFilters = true;
                  });
                },
              ),

              // Search results or empty state
              Expanded(
                child: _searchQuery.isEmpty
                    ? _buildEmptySearchState()
                    : _isSearching
                        ? _buildLoadingState()
                        : _searchResults.isEmpty
                            ? _buildNoResultsState()
                            : SearchResultsWidget(
                                results: _searchResults,
                                isGridView: _isGridView,
                                scrollController: _scrollController,
                              ),
              ),
            ],
          ),

          // Advanced filters overlay
          if (_showAdvancedFilters)
            AdvancedFiltersWidget(
              currentFilters: _activeFilters,
              onApplyFilters: _applyFilters,
              onClose: () {
                setState(() {
                  _showAdvancedFilters = false;
                });
              },
            ),

          // Barcode scanner overlay
          if (_showBarcodeScanner)
            BarcodeScannerWidget(
              cameraController: _cameraController,
              onBarcodeScanned: _onBarcodeScanned,
              onClose: _closeBarcodeScanner,
            ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Recent searches
          RecentSearchesWidget(
            recentSearches: _recentSearches,
            onSearchTap: _onRecentSearchTap,
            onRemoveSearch: _removeRecentSearch,
            onClearAll: _clearAllRecentSearches,
          ),

          const SizedBox(height: 24),

          // Popular categories
          PopularCategoriesWidget(
            onCategoryTap: (category) {
              _searchController.text = category;
              _performSearch(category);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Searching...'),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(128),
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords or adjust your filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
                ),
          ),
        ],
      ),
    );
  }
}

// Data models
class SearchResult {
  final String id;
  final String title;
  final double price;
  final String condition;
  final String imageUrl;
  final String sellerName;
  final String distance;
  final String campus;
  final String category;
  final List<String> tags;
  final double rating;
  final bool isVerified;
  final DateTime postedAt;

  SearchResult({
    required this.id,
    required this.title,
    required this.price,
    required this.condition,
    required this.imageUrl,
    required this.sellerName,
    required this.distance,
    required this.campus,
    required this.category,
    required this.tags,
    required this.rating,
    required this.isVerified,
    required this.postedAt,
  });
}
