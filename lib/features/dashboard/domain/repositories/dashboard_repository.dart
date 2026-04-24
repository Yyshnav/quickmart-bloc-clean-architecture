import '../entities/product_entity.dart';

abstract class DashboardRepository {
  Future<List<ProductEntity>> getProducts();
  Future<List<String>> getCategories();
}
