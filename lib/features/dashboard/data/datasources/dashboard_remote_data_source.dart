import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/product_model.dart';

abstract class DashboardRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<List<String>> getCategories();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final DioClient dioClient;

  DashboardRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await dioClient.dio.get('/products/categories');
      return List<String>.from(response.data);
    } catch (e) {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await dioClient.dio.get('/products');
      return (response.data as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load products');
    }
  }
}
