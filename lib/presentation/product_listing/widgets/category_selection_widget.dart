import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategorySelectionWidget extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelectionWidget({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<CategorySelectionWidget> createState() =>
      _CategorySelectionWidgetState();
}

class _CategorySelectionWidgetState extends State<CategorySelectionWidget> {
  String? _selectedMainCategory;
  String? _selectedSubCategory;

  @override
  void initState() {
    super.initState();
    if (widget.selectedCategory.isNotEmpty) {
      // Find the selected category and subcategory
      for (var category in widget.categories) {
        if (category['id'] == widget.selectedCategory) {
          _selectedMainCategory = category['id'];
          break;
        }
        // Check subcategories
        List<String> subcategories =
            (category['subcategories'] as List).cast<String>();
        if (subcategories.contains(widget.selectedCategory)) {
          _selectedMainCategory = category['id'];
          _selectedSubCategory = widget.selectedCategory;
          break;
        }
      }
    }
  }

  void _selectMainCategory(String categoryId) {
    setState(() {
      _selectedMainCategory = categoryId;
      _selectedSubCategory = null;
    });
  }

  void _selectSubCategory(String subcategory) {
    setState(() {
      _selectedSubCategory = subcategory;
    });
    widget.onCategorySelected(subcategory);
    Navigator.pop(context);
  }

  void _selectMainCategoryOnly() {
    if (_selectedMainCategory != null) {
      widget.onCategorySelected(_selectedMainCategory!);
      Navigator.pop(context);
    }
  }

  void _showBarcodeScanner() {
    Navigator.pop(context);
    // Mock barcode scanner for textbooks
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ISBN Scanner'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'qr_code_scanner',
                    color: Colors.white,
                    size: 15.w,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Point camera at ISBN barcode',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'We\'ll automatically fill in book details',
              style: AppTheme.lightTheme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Mock successful scan
              widget.onCategorySelected('textbooks');
            },
            child: Text('Mock Scan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  if (_selectedMainCategory != null)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedMainCategory = null;
                          _selectedSubCategory = null;
                        });
                      },
                      icon: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 6.w,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      _selectedMainCategory == null
                          ? 'Select Category'
                          : widget.categories.firstWhere(
                              (cat) => cat['id'] == _selectedMainCategory,
                            )['name'],
                      style: AppTheme.lightTheme.textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
            ),

            Divider(height: 1),

            // Content
            Expanded(
              child: _selectedMainCategory == null
                  ? _buildMainCategories()
                  : _buildSubCategories(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCategories() {
    return ListView(
      padding: EdgeInsets.all(4.w),
      children: [
        // Special option for textbooks with ISBN scanning
        _buildCategoryTile(
          icon: 'qr_code_scanner',
          title: 'Scan Textbook ISBN',
          subtitle: 'Automatically detect book details',
          onTap: _showBarcodeScanner,
          isSpecial: true,
        ),

        SizedBox(height: 2.h),

        // Regular categories
        ...widget.categories.map((category) => _buildCategoryTile(
              icon: category['icon'],
              title: category['name'],
              subtitle:
                  '${(category['subcategories'] as List).length} subcategories',
              onTap: () => _selectMainCategory(category['id']),
              isSelected: _selectedMainCategory == category['id'],
            )),
      ],
    );
  }

  Widget _buildSubCategories() {
    final selectedCategory = widget.categories.firstWhere(
      (cat) => cat['id'] == _selectedMainCategory,
    );

    List<String> subcategories =
        (selectedCategory['subcategories'] as List).cast<String>();

    return ListView(
      padding: EdgeInsets.all(4.w),
      children: [
        // Option to select main category without subcategory
        _buildSubcategoryTile(
          title: 'All ${selectedCategory['name']}',
          subtitle: 'General category',
          onTap: _selectMainCategoryOnly,
          isSelected: _selectedSubCategory == null,
        ),

        SizedBox(height: 1.h),

        // Subcategories
        ...subcategories.map((subcategory) => _buildSubcategoryTile(
              title: subcategory,
              subtitle: 'Specific category',
              onTap: () => _selectSubCategory(subcategory),
              isSelected: _selectedSubCategory == subcategory,
            )),
      ],
    );
  }

  Widget _buildCategoryTile({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isSelected = false,
    bool isSpecial = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : isSpecial
                    ? AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.3)
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05)
              : isSpecial
                  ? AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.05)
                  : null,
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: isSpecial
                    ? AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: isSpecial
                    ? AppTheme.lightTheme.colorScheme.tertiary
                    : AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : null,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'keyboard_arrow_right',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcategoryTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        margin: EdgeInsets.only(bottom: 1.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05)
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : null,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (isSelected)
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
          ],
        ),
      ),
    );
  }
}
