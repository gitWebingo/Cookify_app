import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cookify/home_screen.dart';
import 'package:cookify/category_screen.dart';
import 'package:cookify/meal_planner_screen.dart';
import 'package:cookify/favorites_screen.dart';
import 'package:cookify/recipe_provider.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({Key? key}) : super(key: key);

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  final List<Widget> _screens = [
    const HomeScreen(),
    const MealPlannerScreen(),
    const FavoritesScreen(),
    const SearchCategoriesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecipeProvider>(context);

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: provider.selectedTabIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: provider.selectedTabIndex,
        onItemSelected: (index) => provider.setTabIndex(index),
      ),
      floatingActionButton: Transform.rotate(
        angle: 45 * 3.1415927 / 180,
        child: SizedBox(
          width: 56,
          height: 56,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add-recipe');
            },
            backgroundColor: const Color(0xFFFF6B35),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Transform.rotate(
              angle: -45 * 3.1415927 / 180,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home_outlined, Icons.home, "Home", 0),
          _buildNavItem(Icons.calendar_today_outlined, Icons.calendar_today,
              "Meal Plan", 1),
          const SizedBox(width: 40), // Space for FAB
          _buildNavItem(Icons.favorite_outline, Icons.favorite, "Favorites", 2),
          _buildNavItem(
              Icons.grid_view_outlined, Icons.grid_view, "Categories", 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, IconData activeIcon, String label, int index) {
    final bool isSelected = selectedIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onItemSelected(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? const Color(0xFFFF6B35) : Colors.grey,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? const Color(0xFFFF6B35) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 30); // Initial rounding start

    // Top-left rounding
    path.quadraticBezierTo(0, 0, 30, 0);

    // Left side line
    path.lineTo(size.width * 0.38, 0);

    // The Concave Notch (Dip)
    path.quadraticBezierTo(size.width * 0.42, 0, size.width * 0.45, 12);
    path.arcToPoint(
      Offset(size.width * 0.55, 12),
      radius: const Radius.circular(25),
      clockwise: false,
    );
    path.quadraticBezierTo(size.width * 0.58, 0, size.width * 0.62, 0);

    // Right side line
    path.lineTo(size.width - 30, 0);

    // Top-right rounding
    path.quadraticBezierTo(size.width, 0, size.width, 30);

    // Closing the path
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
