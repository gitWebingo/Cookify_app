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
      'label': 'Breakfast',
      'image':
          'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=800&q=80',
      'icon': '🍳',
      'description': 'Start your day right'
    },
    {
      'label': 'Lunch',
      'image':
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=80',
      'icon': '�',
      'description': 'Mid-day fuel'
    },
    {
      'label': 'Dinner',
      'image':
          'https://images.unsplash.com/photo-1544025162-d76694265947?w=800&q=80',
      'icon': '�️',
      'description': 'Evening delights'
    },
    {
      'label': 'Dessert',
      'image':
          'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=800&q=80',
      'icon': '🧁',
      'description': 'Sweet treats'
    },
    {
      'label': 'Main Course',
      'image':
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=80',
      'icon': '🥩',
      'description': 'Hearty meals'
    },
    {
      'label': 'Drinks',
      'image':
          'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=800&q=80',
      'icon': '�',
      'description': 'Refreshments'
    },
    {
      'label': 'Italian',
      'image':
          'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=800&q=80',
      'icon': '🍝',
      'description': 'Taste of Italy'
    },
    {
      'label': 'Vegan',
      'image':
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800&q=80',
      'icon': '�',
      'description': 'Plant-based power'
    },
    {
      'label': 'Gluten-Free',
      'image':
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800&q=80',
      'icon': '🍞',
      'description': 'Wheat-free wonders'
    },
    {
      'label': 'Healthy',
      'image':
          'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=800&q=80',
      'icon': '🥦',
      'description': 'Nutritious choices'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 80.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              'Categories',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  height: 50,
                  width: 100,
                  child: Image.asset(
                    'assets/icons/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
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
    return GestureDetector(
      onTap: () {
        final provider = Provider.of<RecipeProvider>(context, listen: false);
        provider.setFilters(category: category['label']);
        provider.setTabIndex(0);

        // Navigation Logic:
        // If this screen was pushed (e.g. from "See All"), pop it.
        // If it's the main tab, switching tab index (above) handles it.
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Background Image with Zoom Effect Container
              Positioned.fill(
                child: Image.network(
                  category['image'],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFFF6B35),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported,
                        color: Colors.grey),
                  ),
                ),
              ),

              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.8),
                      ],
                      stops: const [0.4, 0.6, 1.0],
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon Badge
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          category['icon'],
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),

                    // Text Content
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category['label'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          category['description'],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
