import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductImageCarouselWidget extends StatefulWidget {
  final List<String> images;

  const ProductImageCarouselWidget({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  State<ProductImageCarouselWidget> createState() =>
      _ProductImageCarouselWidgetState();
}

class _ProductImageCarouselWidgetState
    extends State<ProductImageCarouselWidget> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showFullScreenGallery() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullScreenGallery(
          images: widget.images,
          initialIndex: _currentIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showFullScreenGallery,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return CustomImageWidget(
                imageUrl: widget.images[index],
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              );
            },
          ),
          if (widget.images.length > 1)
            Positioned(
              bottom: 4.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    width: _currentIndex == index ? 4.w : 2.w,
                    height: 2.w,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(1.w),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            top: 4.h,
            right: 4.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: Text(
                '${_currentIndex + 1}/${widget.images.length}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullScreenGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const _FullScreenGallery({
    Key? key,
    required this.images,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<_FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<_FullScreenGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'close',
            color: Colors.white,
            size: 6.w,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${_currentIndex + 1} of ${widget.images.length}',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            panEnabled: true,
            minScale: 1.0,
            maxScale: 4.0,
            child: Center(
              child: CustomImageWidget(
                imageUrl: widget.images[index],
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
