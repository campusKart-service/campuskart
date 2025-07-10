import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductInfoWidget extends StatefulWidget {
  final Map<String, dynamic> productData;
  final VoidCallback onMakeOffer;

  const ProductInfoWidget({
    Key? key,
    required this.productData,
    required this.onMakeOffer,
  }) : super(key: key);

  @override
  State<ProductInfoWidget> createState() => _ProductInfoWidgetState();
}

class _ProductInfoWidgetState extends State<ProductInfoWidget> {
  bool _isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    final description = widget.productData["description"] as String;
    final specifications =
        widget.productData["specifications"] as Map<String, dynamic>;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Price Section
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productData["title"] as String,
                    style: AppTheme.lightTheme.textTheme.headlineSmall,
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Text(
                        widget.productData["price"] as String,
                        style: AppTheme.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (widget.productData["originalPrice"] != null)
                        Padding(
                          padding: EdgeInsets.only(left: 2.w),
                          child: Text(
                            widget.productData["originalPrice"] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      Spacer(),
                      if (widget.productData["isNegotiable"] == true)
                        TextButton(
                          onPressed: widget.onMakeOffer,
                          child: Text('Make Offer'),
                        ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: [
                      _buildInfoChip(
                        icon: 'check_circle_outline',
                        label: widget.productData["condition"] as String,
                        color: AppTheme.successLight,
                      ),
                      _buildInfoChip(
                        icon: 'location_on',
                        label: widget.productData["campus"] as String,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                      _buildInfoChip(
                        icon: 'category',
                        label: widget.productData["category"] as String,
                        color: AppTheme.lightTheme.colorScheme.secondary,
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'visibility',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 4.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '${widget.productData["viewCount"]} views',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      SizedBox(width: 4.w),
                      CustomIconWidget(
                        iconName: 'favorite',
                        color: AppTheme.errorLight,
                        size: 4.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '${widget.productData["favoriteCount"]} favorites',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      Spacer(),
                      Text(
                        'Posted ${widget.productData["postedDate"]}',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Description Section
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 2.h),
                  AnimatedCrossFade(
                    firstChild: Text(
                      description.length > 200
                          ? '${description.substring(0, 200)}...'
                          : description,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    secondChild: Text(
                      description,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    crossFadeState: _isDescriptionExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 300),
                  ),
                  if (description.length > 200)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isDescriptionExpanded = !_isDescriptionExpanded;
                        });
                      },
                      child: Text(
                        _isDescriptionExpanded ? 'Read Less' : 'Read More',
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Specifications Section
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Specifications',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 2.h),
                  ...specifications.entries
                      .map((entry) => Padding(
                            padding: EdgeInsets.only(bottom: 1.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 25.w,
                                  child: Text(
                                    entry.key,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    entry.value.toString(),
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required String icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: color,
            size: 4.w,
          ),
          SizedBox(width: 1.w),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
