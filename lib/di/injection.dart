import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/network/dio_client.dart';
import '../features/auth/data/datasources/auth_local_data_source.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/cart/presentation/bloc/cart_bloc.dart';
import '../features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import '../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../features/dashboard/domain/usecases/get_categories.dart';
import '../features/dashboard/domain/usecases/get_products.dart';
import '../features/dashboard/presentation/bloc/dashboard_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  
  sl.registerFactory(() => AuthBloc(localDataSource: sl()));
  sl.registerLazySingleton(() => CartBloc()); 
  sl.registerFactory(() => DashboardBloc(getProducts: sl(), getCategories: sl()));

  
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));

  
  sl.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(remoteDataSource: sl()));

  
  sl.registerLazySingleton<DashboardRemoteDataSource>(() => DashboardRemoteDataSourceImpl(dioClient: sl()));
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(sharedPreferences: sl()));

  
  sl.registerLazySingleton(() => DioClient());

  
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
