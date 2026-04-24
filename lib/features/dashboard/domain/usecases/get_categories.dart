import '../repositories/dashboard_repository.dart';

class GetCategoriesUseCase {
  final DashboardRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<String>> call() async {
    return await repository.getCategories();
  }
}
