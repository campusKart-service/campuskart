import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CampusSelectionWidget extends StatefulWidget {
  final List<Map<String, dynamic>> campusList;
  final String? selectedCampus;
  final Function(String) onCampusSelected;

  const CampusSelectionWidget({
    Key? key,
    required this.campusList,
    required this.selectedCampus,
    required this.onCampusSelected,
  }) : super(key: key);

  @override
  State<CampusSelectionWidget> createState() => _CampusSelectionWidgetState();
}

class _CampusSelectionWidgetState extends State<CampusSelectionWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredCampusList = [];
  bool isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    filteredCampusList = widget.campusList;
    _searchController.addListener(_filterCampuses);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCampuses() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredCampusList = widget.campusList.where((campus) {
        final name = (campus['name'] as String).toLowerCase();
        final location = (campus['location'] as String).toLowerCase();
        return name.contains(query) || location.contains(query);
      }).toList();
    });
  }

  void _selectCampus(Map<String, dynamic> campus) {
    setState(() {
      isDropdownOpen = false;
    });
    _searchController.text = campus['name'] as String;
    widget.onCampusSelected(campus['name'] as String);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Your Campus',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDropdownOpen
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline,
              width: isDropdownOpen ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for your university...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isDropdownOpen = !isDropdownOpen;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: isDropdownOpen
                            ? 'keyboard_arrow_up'
                            : 'keyboard_arrow_down',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                ),
                onTap: () {
                  setState(() {
                    isDropdownOpen = true;
                  });
                },
              ),
              if (isDropdownOpen) ...[
                Container(
                  height: 1,
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
                Container(
                  constraints: BoxConstraints(maxHeight: 30.h),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredCampusList.length,
                    itemBuilder: (context, index) {
                      final campus = filteredCampusList[index];
                      return ListTile(
                        title: Text(
                          campus['name'] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                        subtitle: Text(
                          campus['location'] as String,
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                        onTap: () => _selectCampus(campus),
                        dense: true,
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
        if (widget.selectedCampus != null) ...[
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Campus selected',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
