import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bottom_action_bar_widget.dart';
import './widgets/product_image_carousel_widget.dart';
import './widgets/product_info_widget.dart';
import './widgets/seller_card_widget.dart';
import './widgets/similar_items_widget.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final ScrollController _scrollController = ScrollController();
  bool _showStickyHeader = false;

  // Mock product data
  final Map<String, dynamic> productData = {
    "id": 1,
    "title": "MacBook Pro 13-inch M2 Chip",
    "price": "\$1,299.00",
    "originalPrice": "\$1,599.00",
    "condition": "Like New",
    "category": "Electronics",
    "campus": "Stanford University",
    "location": "Palo Alto, CA",
    "description":
        """Selling my MacBook Pro 13-inch with M2 chip in excellent condition. Used for only 6 months for coursework and light programming. 

Features:
• Apple M2 chip with 8-core CPU and 10-core GPU
• 16GB unified memory
• 512GB SSD storage
• 13.3-inch Retina display
• Touch Bar and Touch ID
• Two Thunderbolt / USB 4 ports

Includes original box, charger, and documentation. No scratches or dents. Battery health at 98%. Perfect for students or professionals.

Reason for selling: Upgraded to 16-inch model for video editing work.""",
    "specifications": {
      "Brand": "Apple",
      "Model": "MacBook Pro 13-inch",
      "Processor": "Apple M2 chip",
      "Memory": "16GB unified memory",
      "Storage": "512GB SSD",
      "Display": "13.3-inch Retina",
      "Condition": "Like New",
      "Year": "2023"
    },
    "images": [
      "https://images.unsplash.com/photo-1541807084-5c52b6b3adef?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3"
    ],
    "seller": {
      "id": 101,
      "name": "Sarah Chen",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "rating": 4.8,
      "reviewCount": 24,
      "isVerified": true,
      "campusVerified": true,
      "joinDate": "2023-09-15",
      "responseTime": "Usually responds within 2 hours"
    },
    "isNegotiable": true,
    "viewCount": 156,
    "favoriteCount": 23,
    "postedDate": "2025-01-08",
    "lastUpdated": "2025-01-09"
  };

  final List<Map<String, dynamic>> similarItems = [
    {
      "id": 2,
      "title": "MacBook Air M1",
      "price": "\$899.00",
      "condition": "Good",
      "image":
          "https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "campus": "Stanford University"
    },
    {
      "id": 3,
      "title": "iPad Pro 12.9-inch",
      "price": "\$749.00",
      "condition": "Excellent",
      "image":
          "https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "campus": "Stanford University"
    },
    {
      "id": 4,
      "title": "Dell XPS 13",
      "price": "\$1,099.00",
      "condition": "Like New",
      "image":
          "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "campus": "Stanford University"
    }
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_showStickyHeader) {
      setState(() {
        _showStickyHeader = true;
      });
    } else if (_scrollController.offset <= 200 && _showStickyHeader) {
      setState(() {
        _showStickyHeader = false;
      });
    }
  }

  void _onMessageSeller() {
    // Navigate to chat or show message dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Message Seller',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send a message to ${(productData["seller"] as Map<String, dynamic>)["name"]}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    'Hi, I\'m interested in your ${productData["title"]}. Is it still available?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Message sent successfully!')),
              );
            },
            child: Text('Send Message'),
          ),
        ],
      ),
    );
  }

  void _onMakeOffer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Make an Offer',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current price: ${productData["price"]}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Your Offer',
                prefixText: '\$ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Message (Optional)',
                hintText: 'Add a message to your offer...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Offer sent successfully!')),
              );
            },
            child: Text('Send Offer'),
          ),
        ],
      ),
    );
  }

  void _onShare() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${productData["title"]}')),
    );
  }

  void _onReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Report Listing',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Why are you reporting this listing?',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            ...[
              'Inappropriate content',
              'Spam',
              'Fake listing',
              'Overpriced',
              'Other'
            ].map(
              (reason) => RadioListTile<String>(
                title: Text(reason),
                value: reason,
                groupValue: null,
                onChanged: (value) {},
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Report submitted successfully')),
              );
            },
            child: Text('Submit Report'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 40.h,
                pinned: false,
                backgroundColor: Colors.transparent,
                leading: Container(
                  margin: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: Colors.white,
                      size: 6.w,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Container(
                    margin: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: CustomIconWidget(
                        iconName: 'favorite_border',
                        color: Colors.white,
                        size: 6.w,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added to favorites')),
                        );
                      },
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: ProductImageCarouselWidget(
                    images: (productData["images"] as List).cast<String>(),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: AppTheme.lightTheme.scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductInfoWidget(
                        productData: productData,
                        onMakeOffer: _onMakeOffer,
                      ),
                      SizedBox(height: 2.h),
                      SellerCardWidget(
                        sellerData:
                            productData["seller"] as Map<String, dynamic>,
                        onTap: () {
                          Navigator.pushNamed(context, '/user-profile');
                        },
                      ),
                      SizedBox(height: 2.h),
                      SimilarItemsWidget(
                        items: similarItems,
                        onItemTap: (item) {
                          Navigator.pushNamed(context, '/product-detail');
                        },
                      ),
                      SizedBox(height: 10.h), // Space for bottom action bar
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_showStickyHeader)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  left: 4.w,
                  right: 4.w,
                  bottom: 2.h,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 6.w,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productData["title"] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if ((productData["seller"]
                                  as Map<String, dynamic>)["isVerified"] ==
                              true)
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'verified',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 4.w,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  'Verified Seller',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: CustomIconWidget(
                        iconName: 'favorite_border',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 6.w,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added to favorites')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomActionBarWidget(
              onMessageSeller: _onMessageSeller,
              onShare: _onShare,
              onReport: _onReport,
              isNegotiable: productData["isNegotiable"] as bool,
              onMakeOffer: _onMakeOffer,
            ),
          ),
        ],
      ),
    );
  }
}
