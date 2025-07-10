import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActiveListingsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> listings;
  final Function(int) onEditListing;
  final Function(int) onDeleteListing;
  final Function(int) onViewListing;

  const ActiveListingsWidget({
    super.key,
    required this.listings,
    required this.onEditListing,
    required this.onDeleteListing,
    required this.onViewListing,
  });

  @override
  Widget build(BuildContext context) {
    if (listings.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: listings.length,
      itemBuilder: (context, index) {
        final listing = listings[index];
        return _buildListingCard(context, listing);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'inventory_2',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 15.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Active Listings',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Create your first listing to start selling',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildListingCard(BuildContext context, Map<String, dynamic> listing) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => onViewListing(listing["id"] as int),
        onLongPress: () => _showListingOptions(context, listing),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: CustomImageWidget(
                imageUrl: listing["image"] as String,
                width: double.infinity,
                height: 25.h,
                fit: BoxFit.cover,
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          listing["title"] as String,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          listing["category"] as String,
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.h),

                  Text(
                    listing["price"] as String,
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Stats row
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'visibility',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 4.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '${listing["views"]} views',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      SizedBox(width: 4.w),
                      CustomIconWidget(
                        iconName: 'favorite',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 4.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '${listing["likes"]} likes',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      Spacer(),
                      Text(
                        'Posted ${listing["postedDate"]}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showListingOptions(BuildContext context, Map<String, dynamic> listing) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('View Listing'),
              onTap: () {
                Navigator.pop(context);
                onViewListing(listing["id"] as int);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Edit Listing'),
              onTap: () {
                Navigator.pop(context);
                onEditListing(listing["id"] as int);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Share Listing'),
              onTap: () {
                Navigator.pop(context);
                // Handle share
              },
            ),
            Divider(),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 6.w,
              ),
              title: Text(
                'Delete Listing',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, listing);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, Map<String, dynamic> listing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Listing'),
        content: Text(
            'Are you sure you want to delete "${listing["title"]}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDeleteListing(listing["id"] as int);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
