import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/campus_header_widget.dart';
import './widgets/category_grid_widget.dart';
import './widgets/featured_product_carousel_widget.dart';
import './widgets/recent_listings_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentBottomNavIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;

  // Mock data for featured products
  final List<Map<String, dynamic>> featuredProducts = [
    {
      "id": 1,
      "title": "MacBook Pro 13\" M2",
      "price": "\$1,200",
      "originalPrice": "\$1,500",
      "image":
          "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400&h=300&fit=crop",
      "seller": "Sarah Chen",
      "sellerAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "campus": "Stanford University",
      "distance": "0.2 miles",
      "condition": "Like New",
      "isFeatured": true,
      "postedAt": "2 hours ago"
    },
    {
      "id": 2,
      "title": "Calculus Textbook Bundle",
      "price": "\$85",
      "originalPrice": "\$250",
      "image":
          "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&h=300&fit=crop",
      "seller": "Mike Rodriguez",
      "sellerAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "campus": "Stanford University",
      "distance": "0.5 miles",
      "condition": "Good",
      "isFeatured": true,
      "postedAt": "1 day ago"
    },
    {
      "id": 3,
      "title": "IKEA Desk & Chair Set",
      "price": "\$120",
      "originalPrice": "\$180",
      "image":
          "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400&h=300&fit=crop",
      "seller": "Emma Wilson",
      "sellerAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "campus": "Stanford University",
      "distance": "1.2 miles",
      "condition": "Good",
      "isFeatured": true,
      "postedAt": "3 hours ago"
    }
  ];

  // Mock data for recent listings
  final List<Map<String, dynamic>> recentListings = [
    {
      "id": 4,
      "title": "iPhone 14 Pro - Unlocked",
      "price": "\$850",
      "image":
          "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=300&h=300&fit=crop",
      "seller": "Alex Thompson",
      "sellerAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "campus": "Stanford University",
      "distance": "0.8 miles",
      "condition": "Excellent",
      "postedAt": "30 minutes ago",
      "isFavorite": false
    },
    {
      "id": 5,
      "title": "Organic Chemistry Lab Kit",
      "price": "\$45",
      "image":
          "https://images.unsplash.com/photo-1532187863486-abf9dbad1b69?w=300&h=300&fit=crop",
      "seller": "Jessica Park",
      "sellerAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "campus": "Stanford University",
      "distance": "0.3 miles",
      "condition": "Like New",
      "postedAt": "1 hour ago",
      "isFavorite": true
    },
    {
      "id": 6,
      "title": "Gaming Chair - Ergonomic",
      "price": "\$180",
      "image":
          "https://images.unsplash.com/photo-1541558869434-2840d308329a?w=300&h=300&fit=crop",
      "seller": "David Kim",
      "sellerAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "campus": "Stanford University",
      "distance": "1.5 miles",
      "condition": "Good",
      "postedAt": "2 hours ago",
      "isFavorite": false
    },
    {
      "id": 7,
      "title": "Statistics Textbook Set",
      "price": "\$65",
      "image":
          "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=300&h=300&fit=crop",
      "seller": "Lisa Chang",
      "sellerAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "campus": "Stanford University",
      "distance": "0.7 miles",
      "condition": "Good",
      "postedAt": "4 hours ago",
      "isFavorite": false
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();

    // Simulate refresh API call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        // Refresh data here
      });
    }
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        // Already on Home
        break;
      case 1:
        // Navigate to Search
        break;
      case 2:
        Navigator.pushNamed(context, '/product-listing');
        break;
      case 3:
        // Navigate to Messages
        break;
      case 4:
        Navigator.pushNamed(context, '/user-profile');
        break;
    }
  }

  void _onFabPressed() {
    HapticFeedback.mediumImpact();
    Navigator.pushNamed(context, '/product-listing');
  }

  void _onNotificationPressed() {
    HapticFeedback.lightImpact();
    // Handle notification tap
  }

  void _onSearchPressed() {
    HapticFeedback.lightImpact();
    // Handle search tap
  }

  void _onProductTap(Map<String, dynamic> product) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/product-detail');
  }

  void _onFavoriteToggle(int productId) {
    HapticFeedback.lightImpact();
    setState(() {
      final productIndex =
          recentListings.indexWhere((product) => product['id'] == productId);
      if (productIndex != -1) {
        recentListings[productIndex]['isFavorite'] =
            !recentListings[productIndex]['isFavorite'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _onRefresh,
          color: AppTheme.lightTheme.primaryColor,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Campus Header
              SliverToBoxAdapter(
                child: CampusHeaderWidget(
                  campusName: "Stanford University",
                  location: "Palo Alto, CA",
                  onNotificationPressed: _onNotificationPressed,
                  onSearchPressed: _onSearchPressed,
                ),
              ),

              // Featured Products Carousel
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  child: FeaturedProductCarouselWidget(
                    products: featuredProducts,
                    onProductTap: _onProductTap,
                  ),
                ),
              ),

              // Categories Grid
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  child: CategoryGridWidget(),
                ),
              ),

              // Recent Listings Header
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent Listings",
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          // Navigate to all listings
                        },
                        child: Text(
                          "View All",
                          style: TextStyle(
                            color: AppTheme.lightTheme.primaryColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Recent Listings
              _isLoading
                  ? SliverToBoxAdapter(
                      child: Container(
                        height: 40.h,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.lightTheme.primaryColor,
                          ),
                        ),
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: RecentListingsWidget(
                        listings: recentListings,
                        onProductTap: _onProductTap,
                        onFavoriteToggle: _onFavoriteToggle,
                      ),
                    ),

              // Bottom spacing for FAB
              SliverToBoxAdapter(
                child: SizedBox(height: 10.h),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onFabPressed,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: CustomIconWidget(
          iconName: 'camera_alt',
          color: Colors.white,
          size: 20,
        ),
        label: Text(
          "Sell Item",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        selectedItemColor: AppTheme.lightTheme.primaryColor,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        selectedFontSize: 10.sp,
        unselectedFontSize: 10.sp,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _currentBottomNavIndex == 0
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'search',
              color: _currentBottomNavIndex == 1
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'add_circle_outline',
              color: _currentBottomNavIndex == 2
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Sell',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'chat_bubble_outline',
              color: _currentBottomNavIndex == 3
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person_outline',
              color: _currentBottomNavIndex == 4
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
