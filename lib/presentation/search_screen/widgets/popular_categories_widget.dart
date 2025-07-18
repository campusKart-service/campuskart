import 'package:flutter/material.dart';

class PopularCategoriesWidget extends StatelessWidget {
  final Function(String) onCategoryTap;

  const PopularCategoriesWidget({
    Key? key,
    required this.onCategoryTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      CategoryItem(
        name: 'Electronics',
        icon: Icons.devices,
        color: Colors.blue,
      ),
      CategoryItem(
        name: 'Books',
        icon: Icons.book,
        color: Colors.green,
      ),
      CategoryItem(
        name: 'Furniture',
        icon: Icons.chair,
        color: Colors.orange,
      ),
      CategoryItem(
        name: 'Clothing',
        icon: Icons.checkroom,
        color: Colors.purple,
      ),
      CategoryItem(
        name: 'Sports',
        icon: Icons.sports_basketball,
        color: Colors.red,
      ),
      CategoryItem(
        name: 'Music',
        icon: Icons.music_note,
        color: Colors.teal,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Categories',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryCard(context, category);
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard(BuildContext context, CategoryItem category) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onCategoryTap(category.name),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: category.color.withAlpha(26),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: category.color.withAlpha(77),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: category.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  category.icon,
                  size: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                category.name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: category.color,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryItem {
  final String name;
  final IconData icon;
  final Color color;

  CategoryItem({
    required this.name,
    required this.icon,
    required this.color,
  });
}
