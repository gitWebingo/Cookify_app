import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cookify/recipe_provider.dart';

class EditRecipeScreen extends StatefulWidget {
  final Recipe recipe;

  const EditRecipeScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _category;
  late String _ingredients;
  late String _instructions;
  late String _imagePath;
  late String _cookingTime;
  late String _difficulty;

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

  final List<String> _difficultyList = ['Easy', 'Medium', 'Hard'];

  @override
  void initState() {
    super.initState();
    _name = widget.recipe.name;
    _category = widget.recipe.category;
    _ingredients = widget.recipe.ingredients.join('\n');
    _instructions = widget.recipe.instructions;
    _imagePath = widget.recipe.imagePath;
    _cookingTime = widget.recipe.cookingTime;
    _difficulty = widget.recipe.difficulty;
  }

  void _updateRecipe() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedRecipe = widget.recipe.copyWith(
        name: _name,
        category: _category,
        imagePath: _imagePath,
        imagePaths: [_imagePath],
        ingredients:
            _ingredients.split('\n').where((s) => s.trim().isNotEmpty).toList(),
        instructions: _instructions,
        cookingTime: _cookingTime,
        difficulty: _difficulty,
        cuisine: _category,
      );

      Provider.of<RecipeProvider>(context, listen: false)
          .updateRecipe(widget.recipe.id, updatedRecipe);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Recipe updated successfully!'),
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
                'Edit Recipe.',
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
                      initialValue: _name,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please name your creation'
                          : null,
                      onSaved: (value) => _name = value!,
                    ),
                    const SizedBox(height: 20),
                    _buildElegantDropdown(
                      label: 'Category',
                      icon: Icons.category_rounded,
                      value: _category,
                      items: _categoriesList,
                      onChanged: (value) => setState(() => _category = value!),
                    ),
                    const SizedBox(height: 20),
                    _buildElegantTextField(
                      label: 'Image URL',
                      icon: Icons.image_outlined,
                      initialValue: _imagePath,
                      onSaved: (value) => _imagePath = value!,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildElegantTextField(
                            label: 'Cooking Time',
                            icon: Icons.timer_outlined,
                            initialValue: _cookingTime,
                            onSaved: (value) => _cookingTime = value!,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildElegantDropdown(
                            label: 'Difficulty',
                            icon: Icons.bar_chart_rounded,
                            value: _difficulty,
                            items: _difficultyList,
                            onChanged: (value) =>
                                setState(() => _difficulty = value!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildSectionTitle('Details'),
                    _buildElegantTextField(
                      label: 'Ingredients (one per line)',
                      icon: Icons.format_list_bulleted_rounded,
                      maxLines: 5,
                      initialValue: _ingredients,
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
                      initialValue: _instructions,
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
            onPressed: _updateRecipe,
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
              'Update Recipe',
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

  Widget _buildElegantDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      style: const TextStyle(fontSize: 16, color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFFFF6B35), size: 22),
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
      items:
          items.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
      onChanged: onChanged,
    );
  }
}
