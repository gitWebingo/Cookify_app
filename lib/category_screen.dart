import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cookify/recipe_provider.dart';

class SearchCategoriesScreen extends StatefulWidget {
  const SearchCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<SearchCategoriesScreen> createState() => _SearchCategoriesScreenState();
}

class _SearchCategoriesScreenState extends State<SearchCategoriesScreen> {
  final List<Map<String, dynamic>> _categories = [
    {
      'label': 'Vegan',
      'image':
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800&q=80',
      'icon': '🥗',
      'color': const Color(0xFFE8F5E9)
    },
    {
      'label': 'Dessert',
      'image':
          'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=800&q=80',
      'icon': '🧁',
      'color': const Color(0xFFFCE4EC)
    },
    {
      'label': 'Italian',
      'image':
          'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=800&q=80',
      'icon': '🍝',
      'color': const Color(0xFFFFF3E0)
    },
    {
      'label': 'Main Course',
      'image':
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=80',
      'icon': '🥩',
      'color': const Color(0xFFFBE9E7)
    },
    {
      'label': 'Breakfast',
      'image':
          'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=800&q=80',
      'icon': '🍳',
      'color': const Color(0xFFFFFDE7)
    },
    {
      'label': 'Healthy',
      'image':
          'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=800&q=80',
      'icon': '🥦',
      'color': const Color(0xFFF1F8E9)
    },
    {
      'label': 'Gluten-Free',
      'image':
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800&q=80',
      'icon': '🍞',
      'color': const Color(0xFFEFEBE9)
    },
    {
      'label': 'Drinks',
      'image':
          'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=800&q=80',
      'icon': '🍹',
      'color': const Color(0xFFE1F5FE)
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose Your',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Cuisines.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildElegantCategoryCard(_categories[index], context);
                },
                childCount: _categories.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildElegantCategoryCard(
      Map<String, dynamic> category, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Background Image
            Image.network(
              category['image'],
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),

            // Category Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      category['icon'],
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category['label'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Explore Now',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Ink Well for Ripple Effect
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  final provider =
                      Provider.of<RecipeProvider>(context, listen: false);
                  provider.setFilters(category: category['label']);
                  provider.setTabIndex(0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
