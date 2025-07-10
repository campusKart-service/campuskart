import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/active_listings_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_menu_widget.dart';
import './widgets/sold_items_widget.dart';
import './widgets/stats_section_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin {
  int _currentIndex = 3; // Profile tab active
  late TabController _tabController;

  // Mock user data
  final Map<String, dynamic> userData = {
    "id": 1,
    "name": "Sarah Johnson",
    "email": "sarah.johnson@university.edu",
    "campus": "Stanford University",
    "avatar":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    "bio":
        "Computer Science major, selling textbooks and electronics. Quick responses guaranteed!",
    "isVerified": true,
    "studentIdVerified": true,
    "emailVerified": true,
    "phoneVerified": false,
    "memberSince": "September 2023",
    "rating": 4.8,
    "totalRatings": 47,
    "itemsSold": 23,
    "responseTime": "< 1 hour",
    "phone": "+1 (555) 123-4567",
    "joinDate": "2023-09-15"
  };

  final List<Map<String, dynamic>> activeListings = [
    {
      "id": 1,
      "title": "MacBook Pro 13\" M2",
      "price": "\$1,200",
      "image":
          "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "category": "Electronics",
      "postedDate": "2025-07-08",
      "views": 45,
      "likes": 12
    },
    {
      "id": 2,
      "title": "Calculus Textbook",
      "price": "\$85",
      "image":
          "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "category": "Books",
      "postedDate": "2025-07-05",
      "views": 23,
      "likes": 8
    },
    {
      "id": 3,
      "title": "Desk Lamp",
      "price": "\$25",
      "image":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "category": "Furniture",
      "postedDate": "2025-07-03",
      "views": 18,
      "likes": 5
    }
  ];

  final List<Map<String, dynamic>> soldItems = [
    {
      "id": 1,
      "title": "iPhone 14 Pro",
      "price": "\$800",
      "image":
          "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "soldDate": "2025-07-01",
      "buyerRating": 5,
      "buyerFeedback": "Great seller, item exactly as described!"
    },
    {
      "id": 2,
      "title": "Chemistry Lab Kit",
      "price": "\$150",
      "image":
          "https://images.unsplash.com/photo-1532187863486-abf9dbad1b69?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "soldDate": "2025-06-28",
      "buyerRating": 5,
      "buyerFeedback": "Perfect condition, fast delivery!"
    }
  ];

  final List<Map<String, dynamic>> ratingBreakdown = [
    {"stars": 5, "count": 32, "percentage": 68.1},
    {"stars": 4, "count": 12, "percentage": 25.5},
    {"stars": 3, "count": 2, "percentage": 4.3},
    {"stars": 2, "count": 1, "percentage": 2.1},
    {"stars": 1, "count": 0, "percentage": 0.0}
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home-screen');
        break;
      case 1:
        Navigator.pushNamed(context, '/product-listing');
        break;
      case 2:
        // Search functionality
        break;
      case 3:
        // Already on profile
        break;
    }
  }

  void _showEditProfileModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildEditProfileModal(),
    );
  }

  void _showSettingsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SettingsMenuWidget(
        userData: userData,
        onLogout: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login-screen',
            (route) => false,
          );
        },
        onCampusVerification: () {
          Navigator.pushNamed(context, '/campus-verification');
        },
      ),
    );
  }

  Widget _buildEditProfileModal() {
    final TextEditingController nameController =
        TextEditingController(text: userData["name"] as String);
    final TextEditingController bioController =
        TextEditingController(text: userData["bio"] as String);
    final TextEditingController phoneController =
        TextEditingController(text: userData["phone"] as String);

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                    ),
                  ),
                ),
                Text(
                  'Edit Profile',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Save changes
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Save',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar section
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 25.w,
                              height: 25.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: CustomImageWidget(
                                  imageUrl: userData["avatar"] as String,
                                  width: 25.w,
                                  height: 25.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme
                                        .lightTheme.scaffoldBackgroundColor,
                                    width: 2,
                                  ),
                                ),
                                child: CustomIconWidget(
                                  iconName: 'camera_alt',
                                  color: Colors.white,
                                  size: 4.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Change Photo',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Form fields
                  Text(
                    'Display Name',
                    style: AppTheme.lightTheme.textTheme.titleSmall,
                  ),
                  SizedBox(height: 1.h),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your display name',
                    ),
                  ),
                  SizedBox(height: 3.h),

                  Text(
                    'Bio',
                    style: AppTheme.lightTheme.textTheme.titleSmall,
                  ),
                  SizedBox(height: 1.h),
                  TextField(
                    controller: bioController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Tell others about yourself...',
                    ),
                  ),
                  SizedBox(height: 3.h),

                  Text(
                    'Phone Number',
                    style: AppTheme.lightTheme.textTheme.titleSmall,
                  ),
                  SizedBox(height: 1.h),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Enter your phone number',
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Contact preferences
                  Text(
                    'Contact Preferences',
                    style: AppTheme.lightTheme.textTheme.titleSmall,
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Allow messages',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                            Switch(
                              value: true,
                              onChanged: (value) {},
                            ),
                          ],
                        ),
                        Divider(height: 2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Show phone number',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                            Switch(
                              value: false,
                              onChanged: (value) {},
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            onPressed: _showSettingsModal,
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              ProfileHeaderWidget(
                userData: userData,
                onEditPressed: _showEditProfileModal,
              ),

              SizedBox(height: 3.h),

              // Stats Section
              StatsSection(userData: userData),

              SizedBox(height: 3.h),

              // Tab Navigation
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'Active (${activeListings.length})'),
                    Tab(text: 'Sold (${soldItems.length})'),
                    Tab(text: 'Reviews (${userData["totalRatings"]})'),
                  ],
                ),
              ),

              SizedBox(height: 2.h),

              // Tab Content
              Container(
                height: 50.h,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Active Listings
                    ActiveListingsWidget(
                      listings: activeListings,
                      onEditListing: (listingId) {
                        Navigator.pushNamed(context, '/product-listing');
                      },
                      onDeleteListing: (listingId) {
                        // Handle delete
                      },
                      onViewListing: (listingId) {
                        Navigator.pushNamed(context, '/product-detail');
                      },
                    ),

                    // Sold Items
                    SoldItemsWidget(
                      soldItems: soldItems,
                      onViewItem: (itemId) {
                        Navigator.pushNamed(context, '/product-detail');
                      },
                    ),

                    // Reviews
                    _buildReviewsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _currentIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'add_circle_outline',
              color: _currentIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Sell',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'search',
              color: _currentIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating overview
          Container(
            padding: EdgeInsets.all(4.w),
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
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '${userData["rating"]}',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return CustomIconWidget(
                              iconName: index < 4 ? 'star' : 'star_border',
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              size: 4.w,
                            );
                          }),
                        ),
                        Text(
                          '${userData["totalRatings"]} reviews',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 3.h),

                // Rating breakdown
                ...ratingBreakdown.map((rating) {
                  final stars = rating["stars"] as int;
                  final count = rating["count"] as int;
                  final percentage = rating["percentage"] as double;

                  return Padding(
                    padding: EdgeInsets.only(bottom: 1.h),
                    child: Row(
                      children: [
                        Text(
                          '$stars',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                        SizedBox(width: 1.w),
                        CustomIconWidget(
                          iconName: 'star',
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          size: 3.w,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: percentage / 100,
                            backgroundColor: AppTheme
                                .lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.tertiary,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '$count',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Recent reviews
          Text(
            'Recent Reviews',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),

          // Review items
          ...soldItems.map((item) {
            return Container(
              margin: EdgeInsets.only(bottom: 2.h),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return CustomIconWidget(
                            iconName: index < (item["buyerRating"] as int)
                                ? 'star'
                                : 'star_border',
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            size: 4.w,
                          );
                        }),
                      ),
                      Spacer(),
                      Text(
                        item["soldDate"] as String,
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    item["buyerFeedback"] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'For: ${item["title"]}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
