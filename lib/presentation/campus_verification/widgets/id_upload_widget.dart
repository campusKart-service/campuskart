import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class IdUploadWidget extends StatefulWidget {
  final bool isUploaded;
  final String? uploadedImagePath;
  final Function(String) onIdUploaded;

  const IdUploadWidget({
    Key? key,
    required this.isUploaded,
    required this.uploadedImagePath,
    required this.onIdUploaded,
  }) : super(key: key);

  @override
  State<IdUploadWidget> createState() => _IdUploadWidgetState();
}

class _IdUploadWidgetState extends State<IdUploadWidget> {
  bool isUploading = false;

  void _handleCameraCapture() async {
    setState(() {
      isUploading = true;
    });

    // Simulate camera capture and processing
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        isUploading = false;
      });

      // Mock successful upload
      const mockImagePath =
          "https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=400&h=250&fit=crop";
      widget.onIdUploaded(mockImagePath);

      HapticFeedback.mediumImpact();
    }
  }

  void _handleGalleryPick() async {
    setState(() {
      isUploading = true;
    });

    // Simulate gallery selection and processing
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        isUploading = false;
      });

      // Mock successful upload
      const mockImagePath =
          "https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=400&h=250&fit=crop";
      widget.onIdUploaded(mockImagePath);

      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Student ID',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Take a clear photo of your student ID card. Make sure all text is readable.',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),

        // Upload area
        Container(
          width: double.infinity,
          height: widget.isUploaded ? 25.h : 20.h,
          decoration: BoxDecoration(
            color: widget.isUploaded
                ? AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.05)
                : AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isUploaded
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline,
              width: widget.isUploaded ? 2 : 1,
              style: widget.isUploaded ? BorderStyle.solid : BorderStyle.solid,
            ),
          ),
          child: widget.isUploaded && widget.uploadedImagePath != null
              ? _buildUploadedImage()
              : _buildUploadArea(),
        ),

        if (!widget.isUploaded) ...[
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isUploading ? null : _handleCameraCapture,
                  icon: isUploading
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        )
                      : CustomIconWidget(
                          iconName: 'camera_alt',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 18,
                        ),
                  label: Text(isUploading ? 'Processing...' : 'Take Photo'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isUploading ? null : _handleGalleryPick,
                  icon: CustomIconWidget(
                    iconName: 'photo_library',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 18,
                  ),
                  label: const Text('Gallery'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildUploadArea() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: 'add_a_photo',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 32,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Tap to upload your student ID',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          'JPG, PNG up to 10MB',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadedImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CustomImageWidget(
            imageUrl: widget.uploadedImagePath!,
            width: double.infinity,
            height: 25.h,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 2.w,
          right: 2.w,
          child: Container(
            padding: EdgeInsets.all(1.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'check',
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
        Positioned(
          bottom: 2.w,
          left: 2.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'ID Uploaded',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
