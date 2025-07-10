import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhotoSectionWidget extends StatefulWidget {
  final List<String> selectedImages;
  final Function(List<String>) onImagesSelected;

  const PhotoSectionWidget({
    super.key,
    required this.selectedImages,
    required this.onImagesSelected,
  });

  @override
  State<PhotoSectionWidget> createState() => _PhotoSectionWidgetState();
}

class _PhotoSectionWidgetState extends State<PhotoSectionWidget> {
  int _primaryImageIndex = 0;

  // Mock image URLs for demonstration
  final List<String> _mockImages = [
    "https://images.pexels.com/photos/1029757/pexels-photo-1029757.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/1029781/pexels-photo-1029781.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/1029804/pexels-photo-1029804.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
  ];

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10.w,
                height: 0.5.h,
                margin: EdgeInsets.only(top: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    Text(
                      'Add Photos',
                      style: AppTheme.lightTheme.textTheme.titleLarge,
                    ),
                    SizedBox(height: 3.h),
                    _buildImageSourceOption(
                      icon: 'camera_alt',
                      title: 'Take Photo',
                      subtitle: 'Use camera to capture product',
                      onTap: _openCamera,
                    ),
                    SizedBox(height: 2.h),
                    _buildImageSourceOption(
                      icon: 'photo_library',
                      title: 'Choose from Gallery',
                      subtitle: 'Select from your photos',
                      onTap: _openGallery,
                    ),
                    SizedBox(height: 2.h),
                    _buildImageSourceOption(
                      icon: 'qr_code_scanner',
                      title: 'Scan Barcode',
                      subtitle: 'For textbooks and products',
                      onTap: _openBarcodeScanner,
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

  Widget _buildImageSourceOption({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.lightTheme.colorScheme.primary,
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
                    style: AppTheme.lightTheme.textTheme.titleMedium,
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

  void _openCamera() {
    Navigator.pop(context);
    // Mock camera functionality - add mock images
    List<String> updatedImages = List.from(widget.selectedImages);
    if (updatedImages.length < 5) {
      updatedImages.add(_mockImages[updatedImages.length % _mockImages.length]);
      widget.onImagesSelected(updatedImages);
    }
  }

  void _openGallery() {
    Navigator.pop(context);
    // Mock gallery functionality - add mock images
    List<String> updatedImages = List.from(widget.selectedImages);
    if (updatedImages.length < 5) {
      updatedImages.add(_mockImages[updatedImages.length % _mockImages.length]);
      widget.onImagesSelected(updatedImages);
    }
  }

  void _openBarcodeScanner() {
    Navigator.pop(context);
    // Mock barcode scanner functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Barcode scanner would open here'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _removeImage(int index) {
    List<String> updatedImages = List.from(widget.selectedImages);
    updatedImages.removeAt(index);

    // Adjust primary image index if needed
    if (_primaryImageIndex >= updatedImages.length &&
        updatedImages.isNotEmpty) {
      _primaryImageIndex = 0;
    } else if (updatedImages.isEmpty) {
      _primaryImageIndex = 0;
    }

    widget.onImagesSelected(updatedImages);
  }

  void _setPrimaryImage(int index) {
    setState(() {
      _primaryImageIndex = index;
    });
  }

  void _showImageEditor(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: Container(
          height: 70.h,
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                title: Text('Edit Photo'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Done',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: CustomImageWidget(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                color: Colors.black,
                padding: EdgeInsets.all(4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildEditButton('crop', 'Crop'),
                    _buildEditButton('rotate_right', 'Rotate'),
                    _buildEditButton('brightness_6', 'Brightness'),
                    _buildEditButton('filter', 'Filter'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditButton(String icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            // Mock edit functionality
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$label tool would work here'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          icon: CustomIconWidget(
            iconName: icon,
            color: Colors.white,
            size: 6.w,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Photos',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              '(${widget.selectedImages.length}/5)',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ),
        SizedBox(height: 1.h),

        // Primary image display
        widget.selectedImages.isNotEmpty
            ? GestureDetector(
                onTap: () =>
                    _showImageEditor(widget.selectedImages[_primaryImageIndex]),
                child: Container(
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomImageWidget(
                          imageUrl: widget.selectedImages[_primaryImageIndex],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 2.w,
                        left: 2.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 1.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Primary',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 2.w,
                        right: 2.w,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            onPressed: () => _showImageEditor(
                                widget.selectedImages[_primaryImageIndex]),
                            icon: CustomIconWidget(
                              iconName: 'edit',
                              color: Colors.white,
                              size: 5.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'add_a_photo',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 12.w,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Add Photos',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Tap to add up to 5 photos',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),

        // Thumbnail row
        if (widget.selectedImages.isNotEmpty) ...[
          SizedBox(height: 2.h),
          SizedBox(
            height: 20.w,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.selectedImages.length +
                  (widget.selectedImages.length < 5 ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == widget.selectedImages.length) {
                  // Add more button
                  return GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: Container(
                      width: 20.w,
                      height: 20.w,
                      margin: EdgeInsets.only(right: 2.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: 'add',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 6.w,
                      ),
                    ),
                  );
                }

                return GestureDetector(
                  onTap: () => _setPrimaryImage(index),
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    margin: EdgeInsets.only(right: 2.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: index == _primaryImageIndex
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                        width: index == _primaryImageIndex ? 2 : 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: CustomImageWidget(
                            imageUrl: widget.selectedImages[index],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 1.w,
                          right: 1.w,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              width: 5.w,
                              height: 5.w,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: 'close',
                                color: Colors.white,
                                size: 3.w,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
