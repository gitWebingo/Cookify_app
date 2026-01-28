import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cookify/recipe_provider.dart';
import 'package:uuid/uuid.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({Key? key}) : super(key: key);

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _category = 'Breakfast';
  String _ingredients = '';
  String _instructions = '';
  String _imagePath =
      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=80';

  final List<String> _categoriesList = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Dessert',
    'Vegan',
    'Gluten-Free',
    'Italian',
    'Healthy'
  ];

  void _saveRecipe() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newRecipe = Recipe(
        id: const Uuid().v4(),
        name: _name,
        category: _category,
        imagePath: _imagePath,
        imagePaths: [_imagePath],
        ingredients:
            _ingredients.split('\n').where((s) => s.trim().isNotEmpty).toList(),
        instructions: _instructions,
        rating: 0.0,
        reviewsCount: 0,
        chefName: 'Me',
        chefImage:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
        cookingTime: '20 min',
        difficulty: 'Easy',
        cuisine: _category,
        isVegetarian: true,
      );

      Provider.of<RecipeProvider>(context, listen: false).addRecipe(newRecipe);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('New recipe added to your library!'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: const Color(0xFFFF6B35),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Elegant Header
          SliverAppBar(
            expandedHeight: 140.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.close_rounded,
                  color: Colors.black, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 64, bottom: 16),
              title: const Text(
                'New Recipe.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Form Section
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Basic Info'),
                    _buildElegantTextField(
                      label: 'Recipe Name',
                      icon: Icons.restaurant_rounded,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please name your creation'
                          : null,
                      onSaved: (value) => _name = value!,
                    ),
                    const SizedBox(height: 20),
                    _buildElegantDropdown(),
                    const SizedBox(height: 20),
                    _buildElegantTextField(
                      label: 'Image URL',
                      icon: Icons.image_outlined,
                      initialValue: _imagePath,
                      onSaved: (value) => _imagePath = value!,
                    ),
                    const SizedBox(height: 32),
                    _buildSectionTitle('Details'),
                    _buildElegantTextField(
                      label: 'Ingredients (one per line)',
                      icon: Icons.format_list_bulleted_rounded,
                      maxLines: 5,
                      validator: (value) => value == null || value.isEmpty
                          ? 'What goes into this meal?'
                          : null,
                      onSaved: (value) => _ingredients = value!,
                    ),
                    const SizedBox(height: 20),
                    _buildElegantTextField(
                      label: 'Cooking Instructions',
                      icon: Icons.menu_book_rounded,
                      maxLines: 8,
                      validator: (value) => value == null || value.isEmpty
                          ? 'How do we cook this?'
                          : null,
                      onSaved: (value) => _instructions = value!,
                    ),
                    const SizedBox(
                        height: 120), // Bottom padding for FAB-like button
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // Positioned Save Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: _saveRecipe,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
              elevation: 8,
              shadowColor: const Color(0xFFFF6B35).withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Create Recipe',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[400],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildElegantTextField({
    required String label,
    required IconData icon,
    String? initialValue,
    int maxLines = 1,
    String? Function(String?)? validator,
    required void Function(String?)? onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 16, color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFFFF6B35), size: 22),
        filled: true,
        fillColor: Colors.grey[50],
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.grey[100]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        contentPadding: const EdgeInsets.all(20),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildElegantDropdown() {
    return DropdownButtonFormField<String>(
      value: _category,
      style: const TextStyle(fontSize: 16, color: Colors.black87),
      decoration: InputDecoration(
        labelText: 'Category',
        labelStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
        prefixIcon: const Icon(Icons.category_rounded,
            color: Color(0xFFFF6B35), size: 22),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.grey[100]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      items: _categoriesList
          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
          .toList(),
      onChanged: (value) => setState(() => _category = value!),
    );
  }
}
