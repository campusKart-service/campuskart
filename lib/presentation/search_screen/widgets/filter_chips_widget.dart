import 'package:flutter/material.dart';

class FilterChipsWidget extends StatelessWidget {
  final Map<String, dynamic> activeFilters;
  final Function(String) onFilterRemoved;
  final VoidCallback onClearAll;
  final VoidCallback onShowAdvancedFilters;

  const FilterChipsWidget({
    Key? key,
    required this.activeFilters,
    required this.onFilterRemoved,
    required this.onClearAll,
    required this.onShowAdvancedFilters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (activeFilters.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildDefaultChip(
                        context, 'All Categories', Icons.category),
                    const SizedBox(width: 8),
                    _buildDefaultChip(context, 'Any Price', Icons.attach_money),
                    const SizedBox(width: 8),
                    _buildDefaultChip(
                        context, 'Any Condition', Icons.star_outline),
                    const SizedBox(width: 8),
                    _buildDefaultChip(
                        context, 'Any Distance', Icons.location_on_outlined),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.tune),
              onPressed: onShowAdvancedFilters,
              tooltip: 'Advanced filters',
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...activeFilters.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildActiveFilterChip(
                          context, entry.key, entry.value),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onClearAll,
            child: const Text('Clear all'),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: onShowAdvancedFilters,
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultChip(BuildContext context, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(77),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChip(
      BuildContext context, String key, dynamic value) {
    String displayText = _getFilterDisplayText(key, value);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            displayText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => onFilterRemoved(key),
            child: Icon(
              Icons.close,
              size: 16,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  String _getFilterDisplayText(String key, dynamic value) {
    switch (key) {
      case 'category':
        return value.toString();
      case 'priceRange':
        final range = value as Map<String, double>;
        return '\$${range['min']?.toInt()} - \$${range['max']?.toInt()}';
      case 'condition':
        return value.toString();
      case 'distance':
        return '${value}km';
      case 'rating':
        return '${value}+ stars';
      case 'location':
        return value.toString();
      default:
        return value.toString();
    }
  }
}
