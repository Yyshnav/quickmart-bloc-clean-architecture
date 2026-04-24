import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chips.dart';
import '../../../cart/presentation/widgets/floating_cart_banner.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ScrollController _scrollController = ScrollController();
  
  
  final Map<String, Color> _categoryColors = {
    'All': const Color(0xFFF15A24), 
    'electronics': const Color(0xFF2E3192), 
    'jewelery': const Color(0xFFFBB03B), 
    "men's clothing": const Color(0xFF009245), 
    "women's clothing": const Color(0xFFED1E79), 
  };

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadDashboardDataEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          final headerColor = _categoryColors[state.selectedCategory] ?? Theme.of(context).primaryColor;

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  context.read<DashboardBloc>().add(LoadDashboardDataEvent());
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    _buildSliverAppBar(headerColor),
                    if (state.isLoading)
                      _buildLoadingState()
                    else if (state.hasError)
                      _buildErrorState()
                    else
                      ...[
                        _buildPromotionalBanner(),
                        _buildCategorySection(state),
                        _buildProductGrid(state),
                      ]
                  ],
                ),
              ),
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: FloatingCartBanner(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(Color headerColor) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: headerColor,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on, color: Colors.white, size: 16),
            SizedBox(width: 4),
            Text(
              'Home - 123 Main St, City',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                headerColor.withOpacity(0.8),
                headerColor,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 48,
                right: 16,
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionalBanner() {
    return SliverToBoxAdapter(
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              width: 280,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200,
                image: const DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/280x120/FF7F50/FFFFFF?text=Special+Offer'),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategorySection(DashboardState state) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: CategoryChips(
          categories: state.categories,
          selectedCategory: state.selectedCategory,
          onCategorySelected: (category) {
            context.read<DashboardBloc>().add(SelectCategoryEvent(category));
          },
        ),
      ),
    );
  }

  Widget _buildProductGrid(DashboardState state) {
    if (state.filteredProducts.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text('No products found.'),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100), 
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return ProductCard(product: state.filteredProducts[index]);
          },
          childCount: state.filteredProducts.length,
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
          childCount: 6,
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Something went wrong!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<DashboardBloc>().add(LoadDashboardDataEvent());
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
