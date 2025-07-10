import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentListingsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> listings;
  final Function(Map<String, dynamic>) onProductTap;
  final Function(int) onFavoriteToggle;

  const RecentListingsWidget({
    super.key,
    required this.listings,
    required this.onProductTap,
    required this.onFavoriteToggle,
  });

  void _showContextMenu(BuildContext context, Map<String, dynamic> product) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            _buildContextMenuItem(
              context,
              icon: 'favorite_border',
              title: 'Save to Favorites',
              onTap: () {
                Navigator.pop(context);
                onFavoriteToggle(product["id"] as int);
              },
            ),
            _buildContextMenuItem(
              context,
              icon: 'share',
              title: 'Share Listing',
              onTap: () {
                Navigator.pop(context);
                // Handle share
              },
            ),
            _buildContextMenuItem(
              context,
              icon: 'report',
              title: 'Report Listing',
              onTap: () {
                Navigator.pop(context);
                // Handle report
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: AppTheme.lightTheme.colorScheme.onSurface,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (listings.isEmpty) {
      return Container(
        height: 30.h,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'inventory_2_outlined',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 48,
              ),
              SizedBox(height: 2.h),
              Text(
                "No recent listings",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                "Be the first to list an item!",
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      itemCount: listings.length,
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
      itemBuilder: (context, index) {
        final listing = listings[index];
        return _buildListingCard(context, listing);
      },
    );
  }

  Widget _buildListingCard(BuildContext context, Map<String, dynamic> listing) {
    return GestureDetector(
      onTap: () => onProductTap(listing),
      onLongPress: () => _showContextMenu(context, listing),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: listing["image"] as String,
                  width: 20.w,
                  height: 20.w,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(width: 3.w),

              // Product details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and favorite button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            listing["title"] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            onFavoriteToggle(listing["id"] as int);
                          },
                          child: Container(
                            padding: EdgeInsets.all(1.w),
                            child: CustomIconWidget(
                              iconName: (listing["isFavorite"] as bool)
                                  ? 'favorite'
                                  : 'favorite_border',
                              color: (listing["isFavorite"] as bool)
                                  ? Colors.red
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 1.h),

                    // Price
                    Text(
                      listing["price"] as String,
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),

                    SizedBox(height: 1.h),

                    // Condition
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.tertiary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        listing["condition"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    SizedBox(height: 1.5.h),

                    // Seller info
                    Row(
                      children: [
                        Container(
                          width: 5.w,
                          height: 5.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.2),
                            ),
                          ),
                          child: ClipOval(
                            child: CustomImageWidget(
                              imageUrl: listing["sellerAvatar"] as String,
                              width: 5.w,
                              height: 5.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                listing["seller"] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "${listing["distance"]} • ${listing["postedAt"]}",
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
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
      ),
    );
  }
}
