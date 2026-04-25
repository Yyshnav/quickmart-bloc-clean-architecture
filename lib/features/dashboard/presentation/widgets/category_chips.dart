import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  // Emoji + gradient per category
  static const Map<String, String> _categoryEmojis = {
    'All': '🔥',
    'electronics': '📱',
    'jewelery': '💍',
    "men's clothing": '👔',
    "women's clothing": '👗',
  };

  static const Map<String, List<Color>> _categoryGradients = {
    'All': [Color(0xFF0C831F), Color(0xFF14A829)],
    'electronics': [Color(0xFF1A237E), Color(0xFF3F51B5)],
    'jewelery': [Color(0xFFE65100), Color(0xFFFFA726)],
    "men's clothing": [Color(0xFF00695C), Color(0xFF26A69A)],
    "women's clothing": [Color(0xFFAD1457), Color(0xFFEC407A)],
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          final emoji = _categoryEmojis[category] ?? '📦';

          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    emoji,
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category == 'All' ? 'All' : _capitalize(category),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Tab Indicator Line
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 3,
                    width: 28,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        )
                      ] : [],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
