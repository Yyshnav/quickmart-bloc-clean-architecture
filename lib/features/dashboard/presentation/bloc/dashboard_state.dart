import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';

class DashboardState extends Equatable {
  final bool isLoading;
  final bool hasError;
  final String errorMessage;
  final List<ProductEntity> products;
  final List<String> categories;
  final String selectedCategory;

  const DashboardState({
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage = '',
    this.products = const [],
    this.categories = const [],
    this.selectedCategory = '',
  });

  DashboardState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    List<ProductEntity>? products,
    List<String>? categories,
    String? selectedCategory,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  List<ProductEntity> get filteredProducts {
    if (selectedCategory.isEmpty || selectedCategory == 'All') {
      return products;
    }
    return products.where((p) => p.category == selectedCategory).toList();
  }

  @override
  List<Object?> get props => [
        isLoading,
        hasError,
        errorMessage,
        products,
        categories,
        selectedCategory,
      ];
}
