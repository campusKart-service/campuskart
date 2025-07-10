import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductFormWidget extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController priceController;
  final TextEditingController descriptionController;
  final VoidCallback onChanged;

  const ProductFormWidget({
    super.key,
    required this.titleController,
    required this.priceController,
    required this.descriptionController,
    required this.onChanged,
  });

  @override
  State<ProductFormWidget> createState() => _ProductFormWidgetState();
}

class _ProductFormWidgetState extends State<ProductFormWidget> {
  final int _maxTitleLength = 80;
  final int _maxDescriptionLength = 500;

  // Mock suggested prices
  final List<Map<String, dynamic>> _suggestedPrices = [
    {"label": "Similar items", "price": "\$45"},
    {"label": "Market average", "price": "\$52"},
    {"label": "Quick sell", "price": "\$38"},
  ];

  @override
  void initState() {
    super.initState();
    widget.titleController.addListener(_onTitleChanged);
    widget.priceController.addListener(_onPriceChanged);
    widget.descriptionController.addListener(widget.onChanged);
  }

  @override
  void dispose() {
    widget.titleController.removeListener(_onTitleChanged);
    widget.priceController.removeListener(_onPriceChanged);
    widget.descriptionController.removeListener(widget.onChanged);
    super.dispose();
  }

  void _onTitleChanged() {
    widget.onChanged();
    setState(() {}); // Update character counter
  }

  void _onPriceChanged() {
    widget.onChanged();
    _formatPrice();
  }

  void _formatPrice() {
    String text = widget.priceController.text;
    if (text.isNotEmpty && !text.startsWith('\$')) {
      // Remove any existing dollar signs and format
      text = text.replaceAll('\$', '');
      if (text.isNotEmpty) {
        widget.priceController.value = TextEditingValue(
          text: '\$${text}',
          selection: TextSelection.collapsed(offset: text.length + 1),
        );
      }
    }
  }

  void _showSuggestedPrices() {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Suggested Prices',
                      style: AppTheme.lightTheme.textTheme.titleLarge,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Based on similar items in your area',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    SizedBox(height: 3.h),
                    ..._suggestedPrices
                        .map((suggestion) => _buildPriceSuggestion(
                              suggestion['label'],
                              suggestion['price'],
                            )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSuggestion(String label, String price) {
    return InkWell(
      onTap: () {
        widget.priceController.text = price;
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  Text(
                    'Tap to use this price',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Title
        Text(
          'Product Title',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: widget.titleController,
          maxLength: _maxTitleLength,
          maxLines: 2,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'e.g., iPhone 13 Pro Max 256GB',
            counterText:
                '${widget.titleController.text.length}/$_maxTitleLength',
            counterStyle: AppTheme.lightTheme.textTheme.bodySmall,
          ),
          style: AppTheme.lightTheme.textTheme.bodyLarge,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Product title is required';
            }
            return null;
          },
        ),

        SizedBox(height: 3.h),

        // Price
        Row(
          children: [
            Text(
              'Price',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: _showSuggestedPrices,
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'lightbulb_outline',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Suggested prices',
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
        TextFormField(
          controller: widget.priceController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d\.\$]')),
          ],
          decoration: InputDecoration(
            hintText: '\$0.00',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'attach_money',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
          ),
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Price is required';
            }
            return null;
          },
        ),

        SizedBox(height: 3.h),

        // Description
        Text(
          'Description',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: widget.descriptionController,
          maxLength: _maxDescriptionLength,
          maxLines: 5,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText:
                'Describe your item\'s condition, features, and any important details...',
            counterText:
                '${widget.descriptionController.text.length}/$_maxDescriptionLength',
            counterStyle: AppTheme.lightTheme.textTheme.bodySmall,
            alignLabelWithHint: true,
          ),
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),

        SizedBox(height: 2.h),

        // Description tips
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'tips_and_updates',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Tips for better listings',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                '• Mention brand, model, and year\n• Include original price and purchase date\n• Describe any wear, damage, or missing parts\n• Add dimensions or specifications',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
