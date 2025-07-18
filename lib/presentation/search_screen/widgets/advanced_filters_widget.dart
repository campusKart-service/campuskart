import 'package:flutter/material.dart';

class AdvancedFiltersWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onApplyFilters;
  final VoidCallback onClose;

  const AdvancedFiltersWidget({
    Key? key,
    required this.currentFilters,
    required this.onApplyFilters,
    required this.onClose,
  }) : super(key: key);

  @override
  State<AdvancedFiltersWidget> createState() => _AdvancedFiltersWidgetState();
}

class _AdvancedFiltersWidgetState extends State<AdvancedFiltersWidget> {
  late Map<String, dynamic> _filters;

  final List<String> _categories = [
    'Electronics',
    'Books',
    'Furniture',
    'Clothing',
    'Sports',
    'Music',
    'Home & Garden',
    'Automotive',
  ];

  final List<String> _conditions = [
    'Excellent',
    'Like New',
    'Very Good',
    'Good',
    'Fair',
  ];

  final List<String> _campuses = [
    'Main Campus',
    'North Campus',
    'South Campus',
    'East Campus',
    'West Campus',
  ];

  double _minPrice = 0;
  double _maxPrice = 1000;
  double _maxDistance = 50;
  double _minRating = 0;

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);

    // Initialize price range
    if (_filters['priceRange'] != null) {
      final priceRange = _filters['priceRange'] as Map<String, double>;
      _minPrice = priceRange['min'] ?? 0;
      _maxPrice = priceRange['max'] ?? 1000;
    }

    // Initialize distance
    if (_filters['distance'] != null) {
      _maxDistance = _filters['distance'] as double;
    }

    // Initialize rating
    if (_filters['rating'] != null) {
      _minRating = _filters['rating'] as double;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color:
                          Theme.of(context).colorScheme.outline.withAlpha(77),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: widget.onClose,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Advanced Filters',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _clearAllFilters,
                      child: const Text('Clear All'),
                    ),
                  ],
                ),
              ),

              // Filters content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category filter
                      _buildSectionTitle('Category'),
                      const SizedBox(height: 8),
                      _buildCategoryChips(),
                      const SizedBox(height: 24),

                      // Price range filter
                      _buildSectionTitle('Price Range'),
                      const SizedBox(height: 8),
                      _buildPriceRangeSlider(),
                      const SizedBox(height: 24),

                      // Condition filter
                      _buildSectionTitle('Condition'),
                      const SizedBox(height: 8),
                      _buildConditionChips(),
                      const SizedBox(height: 24),

                      // Distance filter
                      _buildSectionTitle('Distance'),
                      const SizedBox(height: 8),
                      _buildDistanceSlider(),
                      const SizedBox(height: 24),

                      // Campus filter
                      _buildSectionTitle('Campus'),
                      const SizedBox(height: 8),
                      _buildCampusDropdown(),
                      const SizedBox(height: 24),

                      // Rating filter
                      _buildSectionTitle('Minimum Rating'),
                      const SizedBox(height: 8),
                      _buildRatingSlider(),
                    ],
                  ),
                ),
              ),

              // Apply button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color:
                          Theme.of(context).colorScheme.outline.withAlpha(77),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _applyFilters,
                        child: const Text('Apply Filters'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _categories.map((category) {
        final isSelected = _filters['category'] == category;
        return FilterChip(
          label: Text(category),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _filters['category'] = category;
              } else {
                _filters.remove('category');
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildPriceRangeSlider() {
    return Column(
      children: [
        RangeSlider(
          values: RangeValues(_minPrice, _maxPrice),
          min: 0,
          max: 2000,
          divisions: 40,
          labels: RangeLabels(
            '\$${_minPrice.toInt()}',
            '\$${_maxPrice.toInt()}',
          ),
          onChanged: (values) {
            setState(() {
              _minPrice = values.start;
              _maxPrice = values.end;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('\$${_minPrice.toInt()}'),
            Text('\$${_maxPrice.toInt()}'),
          ],
        ),
      ],
    );
  }

  Widget _buildConditionChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _conditions.map((condition) {
        final isSelected = _filters['condition'] == condition;
        return FilterChip(
          label: Text(condition),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _filters['condition'] = condition;
              } else {
                _filters.remove('condition');
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildDistanceSlider() {
    return Column(
      children: [
        Slider(
          value: _maxDistance,
          min: 1,
          max: 100,
          divisions: 19,
          label: '${_maxDistance.toInt()} km',
          onChanged: (value) {
            setState(() {
              _maxDistance = value;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('1 km'),
            Text('${_maxDistance.toInt()} km'),
            const Text('100 km'),
          ],
        ),
      ],
    );
  }

  Widget _buildCampusDropdown() {
    return DropdownButtonFormField<String>(
      value: _filters['campus'] as String?,
      hint: const Text('Select campus'),
      items: _campuses.map((campus) {
        return DropdownMenuItem(
          value: campus,
          child: Text(campus),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          if (value != null) {
            _filters['campus'] = value;
          } else {
            _filters.remove('campus');
          }
        });
      },
    );
  }

  Widget _buildRatingSlider() {
    return Column(
      children: [
        Slider(
          value: _minRating,
          min: 0,
          max: 5,
          divisions: 10,
          label: '${_minRating.toStringAsFixed(1)} stars',
          onChanged: (value) {
            setState(() {
              _minRating = value;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Any rating'),
            Text('${_minRating.toStringAsFixed(1)} stars'),
            const Text('5 stars'),
          ],
        ),
      ],
    );
  }

  void _clearAllFilters() {
    setState(() {
      _filters.clear();
      _minPrice = 0;
      _maxPrice = 1000;
      _maxDistance = 50;
      _minRating = 0;
    });
  }

  void _applyFilters() {
    // Update price range
    if (_minPrice > 0 || _maxPrice < 1000) {
      _filters['priceRange'] = {'min': _minPrice, 'max': _maxPrice};
    }

    // Update distance
    if (_maxDistance < 50) {
      _filters['distance'] = _maxDistance;
    }

    // Update rating
    if (_minRating > 0) {
      _filters['rating'] = _minRating;
    }

    widget.onApplyFilters(_filters);
  }
}
