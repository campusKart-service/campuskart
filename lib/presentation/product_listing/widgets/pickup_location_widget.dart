import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PickupLocationWidget extends StatefulWidget {
  final List<Map<String, dynamic>> locations;
  final String selectedLocation;
  final Function(String) onLocationSelected;

  const PickupLocationWidget({
    super.key,
    required this.locations,
    required this.selectedLocation,
    required this.onLocationSelected,
  });

  @override
  State<PickupLocationWidget> createState() => _PickupLocationWidgetState();
}

class _PickupLocationWidgetState extends State<PickupLocationWidget> {
  void _showLocationMap(Map<String, dynamic> location) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 60.h,
          child: Column(
            children: [
              AppBar(
                title: Text(location['name']),
                backgroundColor: AppTheme.lightTheme.cardColor,
                foregroundColor: AppTheme.lightTheme.colorScheme.onSurface,
                elevation: 0,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Stack(
                    children: [
                      // Mock map background
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.green[100]!,
                              Colors.green[200]!,
                            ],
                          ),
                        ),
                      ),
                      // Mock map lines
                      CustomPaint(
                        size: Size(double.infinity, double.infinity),
                        painter: MapLinesPainter(),
                      ),
                      // Location marker
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'location_on',
                              color: AppTheme.lightTheme.colorScheme.error,
                              size: 15.w,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                location['name'],
                                style: AppTheme.lightTheme.textTheme.titleSmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location['address'],
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 2.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onLocationSelected(location['id']);
                          Navigator.pop(context);
                        },
                        child: Text('Select This Location'),
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
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
                  Expanded(
                    child: Text(
                      'Pickup Locations',
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

            // Locations list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(4.w),
                itemCount: widget.locations.length,
                itemBuilder: (context, index) {
                  final location = widget.locations[index];
                  final isSelected = widget.selectedLocation == location['id'];

                  return InkWell(
                    onTap: () => _showLocationMap(location),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      margin: EdgeInsets.only(bottom: 2.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.05)
                            : null,
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
                              iconName: 'location_on',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 6.w,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        location['name'],
                                        style: AppTheme
                                            .lightTheme.textTheme.titleMedium
                                            ?.copyWith(
                                          color: isSelected
                                              ? AppTheme.lightTheme.colorScheme
                                                  .primary
                                              : null,
                                        ),
                                      ),
                                    ),
                                    if (location['verified'] == true)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.w, vertical: 0.5.h),
                                        decoration: BoxDecoration(
                                          color: AppTheme
                                              .lightTheme.colorScheme.tertiary
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomIconWidget(
                                              iconName: 'verified',
                                              color: AppTheme.lightTheme
                                                  .colorScheme.tertiary,
                                              size: 3.w,
                                            ),
                                            SizedBox(width: 1.w),
                                            Text(
                                              'Verified',
                                              style: TextStyle(
                                                color: AppTheme.lightTheme
                                                    .colorScheme.tertiary,
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  location['address'],
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'access_time',
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      size: 3.w,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      'Open 24/7',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall,
                                    ),
                                    SizedBox(width: 4.w),
                                    CustomIconWidget(
                                      iconName: 'directions_walk',
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      size: 3.w,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      '5 min walk',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              if (isSelected)
                                CustomIconWidget(
                                  iconName: 'check_circle',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 5.w,
                                ),
                              SizedBox(height: 1.h),
                              CustomIconWidget(
                                iconName: 'map',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 5.w,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Add custom location option
            Padding(
              padding: EdgeInsets.all(4.w),
              child: OutlinedButton.icon(
                onPressed: () {
                  // Mock custom location functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Custom location feature would be available here'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: CustomIconWidget(
                  iconName: 'add_location',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
                label: Text('Add Custom Location'),
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 12.w),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1.0;

    // Draw some mock map lines
    for (int i = 0; i < 10; i++) {
      canvas.drawLine(
        Offset(0, size.height * i / 10),
        Offset(size.width, size.height * i / 10),
        paint,
      );
      canvas.drawLine(
        Offset(size.width * i / 10, 0),
        Offset(size.width * i / 10, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
