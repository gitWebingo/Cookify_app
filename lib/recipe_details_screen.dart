import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cookify/recipe_provider.dart';
import 'package:share_plus/share_plus.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipe = ModalRoute.of(context)!.settings.arguments as Recipe;

    return Consumer<RecipeProvider>(
      builder: (context, provider, child) {
        // Find the current state of the recipe from provider to handle updates
        final currentRecipe = provider.recipes
            .firstWhere((r) => r.id == recipe.id, orElse: () => recipe);

        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageCarousel(currentRecipe, context),
                _buildRecipeContent(currentRecipe, context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageCarousel(Recipe recipe, BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 400,
          child: PageView.builder(
            itemCount: recipe.imagePaths.length,
            itemBuilder: (context, index) {
              return Hero(
                tag: 'recipe_${recipe.id}',
                child: Image.network(
                  recipe.imagePaths[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 50,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRoundButton(Icons.arrow_back, () => Navigator.pop(context)),
              Row(
                children: [
                  _buildRoundButton(Icons.edit_outlined, () {
                    Navigator.pushNamed(
                      context,
                      '/edit-recipe',
                      arguments: recipe,
                    );
                  }, color: const Color(0xFFFF6B35)),
                  const SizedBox(width: 10),
                  _buildRoundButton(Icons.delete_outline,
                      () => _showDeleteConfirmation(context, recipe),
                      color: Colors.red),
                  const SizedBox(width: 10),
                  _buildRoundButton(
                      recipe.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border, () {
                    Provider.of<RecipeProvider>(context, listen: false)
                        .toggleFavorite(recipe.id);
                  }, color: const Color(0xFFFF6B35)),
                  const SizedBox(width: 10),
                  _buildRoundButton(Icons.share, () {
                    Share.share(
                        'Check out this delicious recipe: ${recipe.name} by ${recipe.chefName}!\n\n${recipe.instructions}');
                  }),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: recipe.imagePaths.asMap().entries.map((entry) {
              return Container(
                width: entry.key == 0 ? 20 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: entry.key == 0
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
              );
            }).toList(),
          ),
        ),
        Positioned(
          bottom: 80,
          right: 20,
          child: Row(
            children: recipe.imagePaths
                .take(4)
                .map((path) => _buildThumbnail(path))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRoundButton(IconData icon, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color ?? Colors.black87, size: 22),
      ),
    );
  }

  Widget _buildThumbnail(String path) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
        image: DecorationImage(image: NetworkImage(path), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildRecipeContent(Recipe recipe, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                recipe.category,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFFFFD700), size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${recipe.rating}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  recipe.name,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              Icon(
                Icons.lens,
                color: recipe.isVegetarian ? Colors.green : Colors.red,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildChefCard(recipe),
          const SizedBox(height: 24),
          const Text(
            'Description',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            recipe.instructions,
            style: TextStyle(color: Colors.grey.shade600, height: 1.5),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildInfoTile(
                  Icons.access_time, 'Cooking Time', recipe.cookingTime),
              const SizedBox(width: 20),
              _buildInfoTile(Icons.restaurant_menu, 'Cuisine', recipe.cuisine),
            ],
          ),
          const SizedBox(height: 24),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ingredients',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '${recipe.ingredients.length} items',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              Provider.of<RecipeProvider>(context, listen: false)
                  .addToShoppingList(recipe.ingredients);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Added to shopping list!'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: const Color(0xFFFF6B35),
                ),
              );
            },
            icon: const Icon(Icons.shopping_basket_outlined, size: 20),
            label: const Text('Add All to Shopping List'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35).withOpacity(0.1),
              foregroundColor: const Color(0xFFFF6B35),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
          ),
          const SizedBox(height: 16),
          _buildIngredientsList(recipe),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildChefCard(Recipe recipe) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(recipe.chefImage),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recipe.chefName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Text(
                'Chef',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        // Removed non-functional Chat and Phone icons
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, Recipe recipe) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Delete Recipe?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to delete "${recipe.name}"? This action cannot be undone.',
            style: const TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Use the outer context to access provider
                final provider =
                    Provider.of<RecipeProvider>(context, listen: false);
                provider.deleteRecipe(recipe.id);

                Navigator.pop(dialogContext); // Close dialog
                Navigator.pop(context); // Go back to previous screen

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Recipe deleted successfully'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade100),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFF6B35), size: 24),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(color: Colors.grey, fontSize: 10)),
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsList(Recipe recipe) {
    return Column(
      children: recipe.ingredients.map((ingredient) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    color: Color(0xFFFF6B35), shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Text(
                ingredient,
                style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
