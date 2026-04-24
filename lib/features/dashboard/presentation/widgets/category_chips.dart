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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Shop by Category',
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category == selectedCategory;
              final emoji = _categoryEmojis[category] ?? '📦';
              final gradientColors = _categoryGradients[category] ?? [Colors.grey, Colors.grey.shade400];

              return GestureDetector(
                onTap: () => onCategorySelected(category),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isSelected
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: gradientColors,
                              )
                            : null,
                        color: isSelected ? null : AppTheme.surfaceWhite,
                        border: Border.all(
                          color: isSelected ? gradientColors.first : AppTheme.dividerColor,
                          width: isSelected ? 2.5 : 1.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: gradientColors.first.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 64,
                      child: Text(
                        category == 'All' ? 'All' : _capitalize(category),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? AppTheme.primaryGreen : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
