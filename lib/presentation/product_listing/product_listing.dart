import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_selection_widget.dart';
import './widgets/condition_selector_widget.dart';
import './widgets/photo_section_widget.dart';
import './widgets/pickup_location_widget.dart';
import './widgets/product_form_widget.dart';
import './widgets/tags_section_widget.dart';

class ProductListing extends StatefulWidget {
  const ProductListing({super.key});

  @override
  State<ProductListing> createState() => _ProductListingState();
}

class _ProductListingState extends State<ProductListing> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form controllers
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Form state
  List<String> _selectedImages = [];
  String _selectedCategory = '';
  String _selectedCondition = 'New';
  String _selectedLocation = '';
  List<String> _selectedTags = [];
  bool _isAvailable = true;
  bool _isLoading = false;

  // Mock data for categories
  final List<Map<String, dynamic>> _categories = [
    {
      "id": "textbooks",
      "name": "Textbooks & Academic",
      "icon": "book",
      "subcategories": ["Engineering", "Business", "Science", "Arts", "Medical"]
    },
    {
      "id": "electronics",
      "name": "Electronics",
      "icon": "devices",
      "subcategories": ["Laptops", "Phones", "Accessories", "Gaming"]
    },
    {
      "id": "furniture",
      "name": "Furniture",
      "icon": "chair",
      "subcategories": ["Desk", "Chair", "Storage", "Decor"]
    },
    {
      "id": "clothing",
      "name": "Clothing & Fashion",
      "icon": "checkroom",
      "subcategories": ["Men", "Women", "Accessories", "Shoes"]
    },
    {
      "id": "sports",
      "name": "Sports & Recreation",
      "icon": "sports_basketball",
      "subcategories": ["Equipment", "Apparel", "Outdoor", "Fitness"]
    }
  ];

  // Mock pickup locations
  final List<Map<String, dynamic>> _pickupLocations = [
    {
      "id": "library",
      "name": "Main Library",
      "address": "Central Campus, Building A",
      "verified": true
    },
    {
      "id": "student_center",
      "name": "Student Center",
      "address": "Campus Plaza, Building B",
      "verified": true
    },
    {
      "id": "engineering",
      "name": "Engineering Building",
      "address": "North Campus, Building C",
      "verified": true
    },
    {
      "id": "dormitory",
      "name": "Residence Hall",
      "address": "East Campus, Building D",
      "verified": false
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadDraft() {
    // Mock loading saved draft
    setState(() {
      _titleController.text = "";
      _priceController.text = "";
      _descriptionController.text = "";
    });
  }

  void _saveDraft() {
    // Mock auto-save functionality
    if (_titleController.text.isNotEmpty || _priceController.text.isNotEmpty) {
      // Save draft locally
    }
  }

  void _onImageSelected(List<String> images) {
    setState(() {
      _selectedImages = images;
    });
    _saveDraft();
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _saveDraft();
  }

  void _onConditionSelected(String condition) {
    setState(() {
      _selectedCondition = condition;
    });
    _saveDraft();
  }

  void _onLocationSelected(String location) {
    setState(() {
      _selectedLocation = location;
    });
    _saveDraft();
  }

  void _onTagsSelected(List<String> tags) {
    setState(() {
      _selectedTags = tags;
    });
    _saveDraft();
  }

  void _showCategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategorySelectionWidget(
        categories: _categories,
        selectedCategory: _selectedCategory,
        onCategorySelected: _onCategorySelected,
      ),
    );
  }

  void _showLocationBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PickupLocationWidget(
        locations: _pickupLocations,
        selectedLocation: _selectedLocation,
        onLocationSelected: _onLocationSelected,
      ),
    );
  }

  bool _validateForm() {
    if (_titleController.text.trim().isEmpty) {
      _showErrorSnackBar("Product title is required");
      return false;
    }
    if (_priceController.text.trim().isEmpty) {
      _showErrorSnackBar("Price is required");
      return false;
    }
    if (_selectedCategory.isEmpty) {
      _showErrorSnackBar("Please select a category");
      return false;
    }
    if (_selectedImages.isEmpty) {
      _showErrorSnackBar("Please add at least one photo");
      return false;
    }
    if (_selectedLocation.isEmpty) {
      _showErrorSnackBar("Please select a pickup location");
      return false;
    }
    return true;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 10.w,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Listing Posted Successfully!',
              style: AppTheme.lightTheme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Your product is now live on CampusKart',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/home-screen');
                    },
                    child: Text('Share'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/user-profile');
                    },
                    child: Text('View Listing'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _postListing() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    // Mock API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    _showSuccessModal();
  }

  void _cancelListing() {
    if (_titleController.text.isNotEmpty ||
        _priceController.text.isNotEmpty ||
        _descriptionController.text.isNotEmpty ||
        _selectedImages.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Discard Changes?'),
          content:
              Text('You have unsaved changes. Are you sure you want to leave?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Stay'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Discard'),
            ),
          ],
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: _cancelListing,
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        title: Text(
          'Create Listing',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: _isLoading
                ? SizedBox(
                    width: 6.w,
                    height: 6.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: _postListing,
                    child: Text(
                      'Post',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo Section
                PhotoSectionWidget(
                  selectedImages: _selectedImages,
                  onImagesSelected: _onImageSelected,
                ),

                SizedBox(height: 4.h),

                // Product Form
                ProductFormWidget(
                  titleController: _titleController,
                  priceController: _priceController,
                  descriptionController: _descriptionController,
                  onChanged: _saveDraft,
                ),

                SizedBox(height: 3.h),

                // Category Selection
                _buildSectionTitle('Category'),
                SizedBox(height: 1.h),
                GestureDetector(
                  onTap: _showCategoryBottomSheet,
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedCategory.isEmpty
                                ? 'Select category'
                                : _categories.firstWhere(
                                    (cat) => cat['id'] == _selectedCategory,
                                    orElse: () => {'name': _selectedCategory},
                                  )['name'],
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: _selectedCategory.isEmpty
                                  ? AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        CustomIconWidget(
                          iconName: 'keyboard_arrow_down',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 5.w,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 3.h),

                // Condition Selector
                _buildSectionTitle('Condition'),
                SizedBox(height: 1.h),
                ConditionSelectorWidget(
                  selectedCondition: _selectedCondition,
                  onConditionSelected: _onConditionSelected,
                ),

                SizedBox(height: 3.h),

                // Pickup Location
                _buildSectionTitle('Pickup Location'),
                SizedBox(height: 1.h),
                GestureDetector(
                  onTap: _showLocationBottomSheet,
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 5.w,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            _selectedLocation.isEmpty
                                ? 'Select pickup location'
                                : _pickupLocations.firstWhere(
                                    (loc) => loc['id'] == _selectedLocation,
                                    orElse: () => {'name': _selectedLocation},
                                  )['name'],
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: _selectedLocation.isEmpty
                                  ? AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        CustomIconWidget(
                          iconName: 'keyboard_arrow_right',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 5.w,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 3.h),

                // Availability Toggle
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Available for immediate pickup',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                    ),
                    Switch(
                      value: _isAvailable,
                      onChanged: (value) {
                        setState(() {
                          _isAvailable = value;
                        });
                        _saveDraft();
                      },
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // Tags Section
                TagsSectionWidget(
                  selectedTags: _selectedTags,
                  onTagsSelected: _onTagsSelected,
                  category: _selectedCategory,
                  title: _titleController.text,
                ),

                SizedBox(height: 8.h), // Extra space for keyboard
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
