import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cookify/recipe_provider.dart';
import 'package:cookify/onboarding_screen.dart';
import 'package:cookify/recipe_details_screen.dart';
import 'package:cookify/shopping_list_screen.dart';
import 'package:cookify/nav_bar_screen.dart';
import 'package:cookify/add_recipe_screen.dart';
import 'package:cookify/edit_recipe_screen.dart';
import 'package:cookify/category_screen.dart';
import 'package:cookify/meal_planner_screen.dart';
import 'package:cookify/login_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => RecipeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cookify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B35),
          primary: const Color(0xFFFF6B35),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/home': (context) => const NavBarScreen(),
        '/recipe-detail': (context) => const RecipeDetailScreen(),
        '/shopping-list': (context) => const ShoppingListScreen(),
        '/add-recipe': (context) => const AddRecipeScreen(),
        '/edit-recipe': (context) {
          final recipe = ModalRoute.of(context)!.settings.arguments as Recipe;
          return EditRecipeScreen(recipe: recipe);
        },
        '/categories': (context) => const SearchCategoriesScreen(),
        '/meal-planner': (context) => const MealPlannerScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
