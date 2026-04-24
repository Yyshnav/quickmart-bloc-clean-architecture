import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/entities/product_entity.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetProductsUseCase getProducts;
  final GetCategoriesUseCase getCategories;

  DashboardBloc({
    required this.getProducts,
    required this.getCategories,
  }) : super(const DashboardState()) {
    on<LoadDashboardDataEvent>(_onLoadDashboardData);
    on<SelectCategoryEvent>(_onSelectCategory);
  }

  void _onLoadDashboardData(LoadDashboardDataEvent event, Emitter<DashboardState> emit) async {
    emit(state.copyWith(isLoading: true, hasError: false));
    try {
      final results = await Future.wait([
        getCategories(),
        getProducts(),
      ]);

      final categories = ['All', ...results[0] as List<String>];
      final products = results[1] as List<ProductEntity>;

      emit(state.copyWith(
        isLoading: false,
        categories: categories,
        products: products,
        selectedCategory: 'All',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to load dashboard data. Please try again.',
      ));
    }
  }

  void _onSelectCategory(SelectCategoryEvent event, Emitter<DashboardState> emit) {
    emit(state.copyWith(selectedCategory: event.category));
  }
}
