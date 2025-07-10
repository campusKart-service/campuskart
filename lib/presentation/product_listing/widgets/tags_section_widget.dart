import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TagsSectionWidget extends StatefulWidget {
  final List<String> selectedTags;
  final Function(List<String>) onTagsSelected;
  final String category;
  final String title;

  const TagsSectionWidget({
    super.key,
    required this.selectedTags,
    required this.onTagsSelected,
    required this.category,
    required this.title,
  });

  @override
  State<TagsSectionWidget> createState() => _TagsSectionWidgetState();
}

class _TagsSectionWidgetState extends State<TagsSectionWidget> {
  final TextEditingController _customTagController = TextEditingController();
  List<String> _suggestedTags = [];

  @override
  void initState() {
    super.initState();
    _generateSuggestedTags();
  }

  @override
  void didUpdateWidget(TagsSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category ||
        oldWidget.title != widget.title) {
      _generateSuggestedTags();
    }
  }

  @override
  void dispose() {
    _customTagController.dispose();
    super.dispose();
  }

  void _generateSuggestedTags() {
    List<String> suggestions = [];

    // Category-based suggestions
    Map<String, List<String>> categoryTags = {
      'textbooks': [
        'academic',
        'study',
        'college',
        'textbook',
        'education',
        'course'
      ],
      'electronics': [
        'tech',
        'gadget',
        'device',
        'portable',
        'wireless',
        'digital'
      ],
      'furniture': [
        'home',
        'dorm',
        'room',
        'storage',
        'comfort',
        'space-saving'
      ],
      'clothing': [
        'fashion',
        'style',
        'casual',
        'trendy',
        'comfortable',
        'brand'
      ],
      'sports': [
        'fitness',
        'outdoor',
        'exercise',
        'active',
        'recreation',
        'gear'
      ],
    };

    if (widget.category.isNotEmpty &&
        categoryTags.containsKey(widget.category)) {
      suggestions.addAll(categoryTags[widget.category]!);
    }

    // Title-based suggestions
    if (widget.title.isNotEmpty) {
      List<String> titleWords = widget.title.toLowerCase().split(' ');
      for (String word in titleWords) {
        if (word.length > 3 && !suggestions.contains(word)) {
          suggestions.add(word);
        }
      }
    }

    // General popular tags
    suggestions.addAll([
      'affordable',
      'quality',
      'campus',
      'student',
      'quick-sale',
      'negotiable'
    ]);

    // Remove duplicates and limit
    _suggestedTags = suggestions.toSet().take(12).toList();

    setState(() {});
  }

  void _toggleTag(String tag) {
    List<String> updatedTags = List.from(widget.selectedTags);

    if (updatedTags.contains(tag)) {
      updatedTags.remove(tag);
    } else if (updatedTags.length < 8) {
      updatedTags.add(tag);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum 8 tags allowed'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    widget.onTagsSelected(updatedTags);
  }

  void _addCustomTag() {
    String customTag = _customTagController.text.trim().toLowerCase();

    if (customTag.isEmpty) return;

    if (customTag.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tag must be at least 2 characters'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (widget.selectedTags.contains(customTag)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tag already added'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (widget.selectedTags.length >= 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum 8 tags allowed'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    List<String> updatedTags = List.from(widget.selectedTags);
    updatedTags.add(customTag);
    widget.onTagsSelected(updatedTags);

    _customTagController.clear();
  }

  void _showTagsInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About Tags'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tags help buyers find your listing more easily.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Text(
              'Tips for better tags:',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              '• Use specific keywords buyers might search for\n'
              '• Include brand names, colors, or sizes\n'
              '• Add condition-related terms\n'
              '• Maximum 8 tags per listing',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it'),
          ),
        ],
      ),
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
              'Tags',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              '(${widget.selectedTags.length}/8)',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            Spacer(),
            GestureDetector(
              onTap: _showTagsInfo,
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info_outline',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Info',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 1.h),

        Text(
          'Add tags to help buyers find your listing',
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),

        SizedBox(height: 2.h),

        // Selected tags
        if (widget.selectedTags.isNotEmpty) ...[
          Text(
            'Selected Tags',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: widget.selectedTags
                .map((tag) => _buildSelectedTag(tag))
                .toList(),
          ),
          SizedBox(height: 2.h),
        ],

        // Custom tag input
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _customTagController,
                decoration: InputDecoration(
                  hintText: 'Add custom tag...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'local_offer',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _addCustomTag(),
              ),
            ),
            SizedBox(width: 2.w),
            ElevatedButton(
              onPressed: _addCustomTag,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(12.w, 12.w),
                padding: EdgeInsets.zero,
              ),
              child: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 5.w,
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Suggested tags
        if (_suggestedTags.isNotEmpty) ...[
          Text(
            'Suggested Tags',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: _suggestedTags
                .where((tag) => !widget.selectedTags.contains(tag))
                .map((tag) => _buildSuggestedTag(tag))
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildSelectedTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 2.w),
          GestureDetector(
            onTap: () => _toggleTag(tag),
            child: CustomIconWidget(
              iconName: 'close',
              color: Colors.white,
              size: 4.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedTag(String tag) {
    return GestureDetector(
      onTap: () => _toggleTag(tag),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.5),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tag,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'add',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }
}
