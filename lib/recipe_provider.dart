import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Recipe {
  final String id;
  final String name;
  final String category;
  final String imagePath;
  final List<String> imagePaths;
  final List<String> ingredients;
  final String instructions;
  final double rating;
  final int reviewsCount;
  final String chefName;
  final String chefImage;
  final String cookingTime;
  final String difficulty;
  final String cuisine;
  final bool isVegetarian;
  final bool isFavorite;

  Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.imagePath,
    required this.imagePaths,
    required this.ingredients,
    required this.instructions,
    this.rating = 0.0,
    this.reviewsCount = 0,
    required this.chefName,
    required this.chefImage,
    required this.cookingTime,
    required this.difficulty,
    required this.cuisine,
    this.isVegetarian = true,
    this.isFavorite = false,
  });

  Recipe copyWith({
    String? name,
    String? category,
    String? imagePath,
    List<String>? imagePaths,
    List<String>? ingredients,
    String? instructions,
    double? rating,
    int? reviewsCount,
    String? chefName,
    String? chefImage,
    String? cookingTime,
    String? difficulty,
    String? cuisine,
    bool? isVegetarian,
    bool? isFavorite,
  }) {
    return Recipe(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      imagePaths: imagePaths ?? this.imagePaths,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      chefName: chefName ?? this.chefName,
      chefImage: chefImage ?? this.chefImage,
      cookingTime: cookingTime ?? this.cookingTime,
      difficulty: difficulty ?? this.difficulty,
      cuisine: cuisine ?? this.cuisine,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'imagePath': imagePath,
      'imagePaths': imagePaths,
      'ingredients': ingredients,
      'instructions': instructions,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'chefName': chefName,
      'chefImage': chefImage,
      'cookingTime': cookingTime,
      'difficulty': difficulty,
      'cuisine': cuisine,
      'isVegetarian': isVegetarian,
      'isFavorite': isFavorite,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      imagePath: map['imagePath'],
      imagePaths: List<String>.from(map['imagePaths'] ?? []),
      ingredients: List<String>.from(map['ingredients']),
      instructions: map['instructions'],
      rating: map['rating'],
      reviewsCount: map['reviewsCount'] ?? 0,
      chefName: map['chefName'] ?? 'Unknown Chef',
      chefImage: map['chefImage'] ??
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&q=80',
      cookingTime: map['cookingTime'] ?? '',
      difficulty: map['difficulty'] ?? '',
      cuisine: map['cuisine'] ?? '',
      isVegetarian: map['isVegetarian'] ?? true,
      isFavorite: map['isFavorite'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Recipe.fromJson(String source) => Recipe.fromMap(json.decode(source));
}

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  List<String> _shoppingList = [];
  Map<String, String> _mealPlan = {}; // Day -> RecipeID
  int _selectedTabIndex = 0;
  bool _isLoading = true;

  // Global filters
  String _searchQuery = '';
  String _activeCategory = 'All';

  List<Recipe> get recipes => _recipes;
  List<String> get shoppingList => _shoppingList;
  Map<String, String> get mealPlan => _mealPlan;
  int get selectedTabIndex => _selectedTabIndex;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get activeCategory => _activeCategory;

  RecipeProvider() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    // Load Recipes
    final recipesJson = prefs.getStringList('recipes') ?? [];
    if (recipesJson.isEmpty) {
      _recipes = _getInitialRecipes();
      saveRecipes();
    } else {
      _recipes = recipesJson.map((item) => Recipe.fromJson(item)).toList();
    }

    // Load Shopping List
    _shoppingList = prefs.getStringList('shoppingList') ?? [];

    // Load Meal Plan
    final mealPlanJson = prefs.getString('mealPlan');
    if (mealPlanJson != null) {
      _mealPlan = Map<String, String>.from(json.decode(mealPlanJson));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final recipesJson = _recipes.map((item) => item.toJson()).toList();
    await prefs.setStringList('recipes', recipesJson);
  }

  Future<void> saveShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('shoppingList', _shoppingList);
  }

  Future<void> saveMealPlan() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mealPlan', json.encode(_mealPlan));
  }

  void addRecipe(Recipe recipe) {
    _recipes.add(recipe);
    saveRecipes();
    notifyListeners();
  }

  void updateRecipe(String id, Recipe updatedRecipe) {
    final index = _recipes.indexWhere((r) => r.id == id);
    if (index != -1) {
      _recipes[index] = updatedRecipe;
      saveRecipes();
      notifyListeners();
    }
  }

  void deleteRecipe(String id) {
    _recipes.removeWhere((r) => r.id == id);
    // Also remove from meal plan if assigned
    _mealPlan.removeWhere((key, value) => value == id);
    saveRecipes();
    saveMealPlan();
    notifyListeners();
  }

  void toggleFavorite(String id) {
    final index = _recipes.indexWhere((r) => r.id == id);
    if (index != -1) {
      _recipes[index] =
          _recipes[index].copyWith(isFavorite: !_recipes[index].isFavorite);
      saveRecipes();
      notifyListeners();
    }
  }

  void addToShoppingList(List<String> items) {
    for (var item in items) {
      if (!_shoppingList.contains(item)) {
        _shoppingList.add(item);
      }
    }
    saveShoppingList();
    notifyListeners();
  }

  void removeFromShoppingList(String item) {
    _shoppingList.remove(item);
    saveShoppingList();
    notifyListeners();
  }

  void clearShoppingList() {
    _shoppingList.clear();
    saveShoppingList();
    notifyListeners();
  }

  void updateMealPlan(String day, String recipeId) {
    _mealPlan[day] = recipeId;
    saveMealPlan();
    notifyListeners();
  }

  void removeFromMealPlan(String day) {
    _mealPlan.remove(day);
    saveMealPlan();
    notifyListeners();
  }

  void clearMealPlan() {
    _mealPlan.clear();
    saveMealPlan();
    notifyListeners();
  }

  void setFilters({String? query, String? category}) {
    if (query != null) _searchQuery = query;
    if (category != null) _activeCategory = category;
    notifyListeners();
  }

  void setTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  List<Recipe> get filteredRecipes {
    return _recipes.where((recipe) {
      // Simple exact match: check if category or cuisine matches the filter
      final matchesCategory = _activeCategory == 'All' ||
          recipe.category == _activeCategory ||
          recipe.cuisine == _activeCategory;

      // Match search query in name or ingredients
      final matchesSearch = _searchQuery.isEmpty ||
          recipe.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          recipe.ingredients
              .any((i) => i.toLowerCase().contains(_searchQuery.toLowerCase()));

      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<Recipe> _getInitialRecipes() {
    return [
      Recipe(
        id: const Uuid().v4(),
        name: 'Burst Tomato Pasta',
        category: 'Italian',
        imagePath:
            'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=600&q=80',
        imagePaths: [
          'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=600&q=80',
          'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&q=80',
          'https://images.unsplash.com/photo-1612892483236-52d32a0e0ac1?w=600&q=80',
          'https://images.unsplash.com/photo-1473093226795-af9932fe5856?w=600&q=80',
        ],
        ingredients: [
          '1 cup Lorem Ipsum',
          '200g dolor',
          '2 teaspoons sit',
          '1 tablespoon ac fermentum',
          'Fresh Basil',
          'Parmesan Cheese'
        ],
        instructions:
            '1. Boil pasta\n2. Sauté garlic\n3. Add sauce\n4. Mix and serve',
        rating: 4.8,
        reviewsCount: 1200,
        chefName: 'Dianne Russell',
        chefImage:
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&q=80',
        cookingTime: '35 min',
        difficulty: 'Easy',
        cuisine: 'Italian',
        isVegetarian: true,
      ),
      Recipe(
        id: const Uuid().v4(),
        name: 'Vegetarian Buddha Bowl',
        category: 'Vegan',
        imagePath:
            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&q=80',
        imagePaths: [
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&q=80',
          'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=600&q=80',
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&q=80',
        ],
        ingredients: [
          'Quinoa',
          'Chickpeas',
          'Sweet Potato',
          'Spinach',
          'Tahini'
        ],
        instructions:
            '1. Roast sweet potatoes\n2. Cook quinoa\n3. Assemble bowl\n4. Drizzle with tahini',
        rating: 4.9,
        reviewsCount: 850,
        chefName: 'Jenny Wilson',
        chefImage:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&q=80',
        cookingTime: '25 min',
        difficulty: 'Easy',
        cuisine: 'Healthy',
        isVegetarian: true,
      ),
      // Dessert Recipe 1
      Recipe(
        id: const Uuid().v4(),
        name: 'Chocolate Lava Cake',
        category: 'Dessert',
        imagePath:
            'https://images.unsplash.com/photo-1624353365286-3f8d62daad51?w=600&q=80',
        imagePaths: [
          'https://images.unsplash.com/photo-1624353365286-3f8d62daad51?w=600&q=80',
          'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&q=80',
        ],
        ingredients: [
          '200g Dark Chocolate',
          '100g Butter',
          '2 Eggs',
          '50g Sugar',
          '30g Flour',
          'Vanilla Extract'
        ],
        instructions:
            '1. Melt chocolate and butter\n2. Whisk eggs and sugar\n3. Combine and add flour\n4. Pour into ramekins\n5. Bake at 200°C for 12 minutes',
        rating: 4.7,
        reviewsCount: 920,
        chefName: 'Gordon Hayes',
        chefImage:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&q=80',
        cookingTime: '20 min',
        difficulty: 'Medium',
        cuisine: 'Dessert',
        isVegetarian: true,
      ),
      // Dessert Recipe 2
      Recipe(
        id: const Uuid().v4(),
        name: 'Strawberry Cheesecake',
        category: 'Dessert',
        imagePath:
            'https://images.unsplash.com/photo-1533134486753-c833f0ed4866?w=600&q=80',
        imagePaths: [
          'https://images.unsplash.com/photo-1533134486753-c833f0ed4866?w=600&q=80',
          'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=600&q=80',
        ],
        ingredients: [
          '500g Cream Cheese',
          '200g Graham Crackers',
          '100g Butter',
          '150g Sugar',
          '300g Strawberries',
          '3 Eggs'
        ],
        instructions:
            '1. Make crust with crackers and butter\n2. Beat cream cheese and sugar\n3. Add eggs one at a time\n4. Pour over crust\n5. Bake and top with strawberries',
        rating: 4.9,
        reviewsCount: 1450,
        chefName: 'Sarah Mitchell',
        chefImage:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&q=80',
        cookingTime: '60 min',
        difficulty: 'Medium',
        cuisine: 'Dessert',
        isVegetarian: true,
      ),
      // Healthy Recipe
      Recipe(
        id: const Uuid().v4(),
        name: 'Grilled Salmon Bowl',
        category: 'Healthy',
        imagePath:
            'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=600&q=80',
        imagePaths: [
          'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=600&q=80',
          'https://images.unsplash.com/photo-1485921325833-c519f76c4927?w=600&q=80',
        ],
        ingredients: [
          '2 Salmon Fillets',
          '2 cups Broccoli',
          '1 cup Brown Rice',
          'Lemon',
          'Olive Oil',
          'Herbs'
        ],
        instructions:
            '1. Season salmon with herbs\n2. Grill salmon for 4-5 minutes per side\n3. Steam broccoli\n4. Cook brown rice\n5. Assemble bowl and drizzle with lemon',
        rating: 4.6,
        reviewsCount: 680,
        chefName: 'Michael Chen',
        chefImage:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&q=80',
        cookingTime: '30 min',
        difficulty: 'Easy',
        cuisine: 'Healthy',
        isVegetarian: false,
      ),
      // Gluten-Free Recipe 1
      Recipe(
        id: const Uuid().v4(),
        name: 'Quinoa Stuffed Peppers',
        category: 'Gluten-Free',
        imagePath:
            'https://images.unsplash.com/photo-1606756790138-261d2b21cd75?w=600&q=80',
        imagePaths: [
          'https://images.unsplash.com/photo-1606756790138-261d2b21cd75?w=600&q=80',
          'https://images.unsplash.com/photo-1434641716976-28be27f8d0ec?w=600&q=80',
        ],
        ingredients: [
          '4 Bell Peppers',
          '1 cup Quinoa',
          '1 can Black Beans',
          '1 cup Corn',
          'Cheese',
          'Spices'
        ],
        instructions:
            '1. Cook quinoa\n2. Mix with beans, corn, and spices\n3. Cut tops off peppers\n4. Stuff peppers with mixture\n5. Bake at 180°C for 30 minutes',
        rating: 4.7,
        reviewsCount: 540,
        chefName: 'Emma Rodriguez',
        chefImage:
            'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=150&q=80',
        cookingTime: '45 min',
        difficulty: 'Easy',
        cuisine: 'Gluten-Free',
        isVegetarian: true,
      ),
      // Vegan Recipe 2
      Recipe(
        id: const Uuid().v4(),
        name: 'Vegan Curry Bowl',
        category: 'Vegan',
        imagePath:
            'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=600&q=80',
        imagePaths: [
          'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=600&q=80',
          'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=600&q=80',
        ],
        ingredients: [
          '1 can Coconut Milk',
          '2 cups Mixed Vegetables',
          '2 tablespoons Curry Paste',
          '1 cup Rice',
          'Tofu',
          'Fresh Cilantro'
        ],
        instructions:
            '1. Cook rice\n2. Sauté curry paste\n3. Add coconut milk and vegetables\n4. Add tofu cubes\n5. Simmer and serve over rice',
        rating: 4.8,
        reviewsCount: 760,
        chefName: 'Priya Sharma',
        chefImage:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&q=80',
        cookingTime: '35 min',
        difficulty: 'Easy',
        cuisine: 'Vegan',
        isVegetarian: true,
      ),
      // Italian Recipe 2
      Recipe(
        id: const Uuid().v4(),
        name: 'Margherita Pizza',
        category: 'Italian',
        imagePath:
            'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=600&q=80',
        imagePaths: [
          'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=600&q=80',
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600&q=80',
        ],
        ingredients: [
          'Pizza Dough',
          '200g Mozzarella',
          '1 cup Tomato Sauce',
          'Fresh Basil',
          'Olive Oil',
          'Salt'
        ],
        instructions:
            '1. Roll out pizza dough\n2. Spread tomato sauce\n3. Add mozzarella slices\n4. Bake at 250°C for 12-15 minutes\n5. Top with fresh basil',
        rating: 4.9,
        reviewsCount: 1580,
        chefName: 'Antonio Rossi',
        chefImage:
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150&q=80',
        cookingTime: '25 min',
        difficulty: 'Medium',
        cuisine: 'Italian',
        isVegetarian: true,
      ),
      // Gluten-Free Recipe 2
      Recipe(
        id: const Uuid().v4(),
        name: 'Almond Flour Pancakes',
        category: 'Gluten-Free',
        imagePath:
            'https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=600&q=80',
        imagePaths: [
          'https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=600&q=80',
          'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=600&q=80',
        ],
        ingredients: [
          '2 cups Almond Flour',
          '3 Eggs',
          '1/4 cup Milk',
          '2 tablespoons Honey',
          'Baking Powder',
          'Vanilla Extract'
        ],
        instructions:
            '1. Mix dry ingredients\n2. Whisk eggs, milk, and honey\n3. Combine wet and dry ingredients\n4. Cook on griddle\n5. Serve with maple syrup',
        rating: 4.5,
        reviewsCount: 420,
        chefName: 'Lisa Anderson',
        chefImage:
            'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=150&q=80',
        cookingTime: '20 min',
        difficulty: 'Easy',
        cuisine: 'Gluten-Free',
        isVegetarian: true,
      ),
    ];
  }
}
