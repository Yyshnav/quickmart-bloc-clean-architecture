import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chips.dart';
import '../../../cart/presentation/widgets/floating_cart_banner.dart';
import '../../../../core/theme/app_theme.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ScrollController _scrollController = ScrollController();
  final PageController _bannerController = PageController(
    viewportFraction: 0.88,
  );
  int _currentBannerPage = 0;
  Timer? _bannerTimer;

  final Map<String, List<Color>> _categoryGradients = {
    'All': [const Color(0xFF2F80ED), const Color(0xFF56CCF2)],
    'electronics': [const Color(0xFF6366F1), const Color(0xFF818CF8)],
    'jewelery': [const Color(0xFFF59E0B), const Color(0xFFFCD34D)],
    "men's clothing": [
      const Color(0xFF374151),
      const Color(0xFF6B7280),
    ],
    "women's clothing": [
      const Color(0xFFEC4899),
      const Color(0xFFF9A8D4),
    ],
  };

  final List<_BannerData> _banners = [
    _BannerData(
      title: 'Dairy Products',
      subtitle: 'Discover the nature taste',
      image: 'assets/images/dairy_banner.png',
    ),
    _BannerData(
      title: 'Eat Share Repeat',
      subtitle: 'Delicious snacks for you',
      image: 'assets/images/snacks_banner.png',
    ),
    _BannerData(
      title: 'Stay Healthy',
      subtitle: 'Refreshing green tea garden',
      image: 'assets/images/tea_banner.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadDashboardDataEvent());
    _startBannerTimer();
  }

  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerController.hasClients) {
        int nextPage = (_currentBannerPage + 1) % _banners.length;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          final gradientColors =
              _categoryGradients[state.selectedCategory] ??
              [const Color(0xFF63412E), const Color(0xFF916A4D)];

          return Stack(
            children: [
              RefreshIndicator(
                color: AppTheme.primaryGreen,
                onRefresh: () async {
                  context.read<DashboardBloc>().add(LoadDashboardDataEvent());
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    _buildCollapsingSliverAppBar(gradientColors, topPadding),
                    _buildStickySearchBar(gradientColors, state, topPadding),

                    if (state.isLoading)
                      _buildLoadingState()
                    else if (state.hasError)
                      _buildErrorState()
                    else ...[
                      _buildPromotionalBanner(gradientColors),
                      _buildSectionHeader('Products for You'),
                      _buildProductGrid(state),
                    ],
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

  Widget _buildCollapsingSliverAppBar(
      List<Color> gradientColors, double topPadding) {
    return SliverAppBar(
      primary: false,
      expandedHeight: 85.0 + topPadding,
      toolbarHeight: 0,
      floating: false,
      pinned: false,
      snap: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        background: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                gradientColors[0],
                Color.lerp(gradientColors[0], gradientColors[1], 0.4) ??
                    gradientColors[0],
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: topPadding + 8, left: 16, right: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'QuickMart',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 5), // User added spacing
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'HOME - Kozhikode, Kerala 673001, India',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStickySearchBar(
      List<Color> gradientColors, DashboardState state, double topPadding) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SearchBarDelegate(
        gradientColors: gradientColors,
        categories: state.categories,
        selectedCategory: state.selectedCategory,
        onCategorySelected: (category) {
          context.read<DashboardBloc>().add(SelectCategoryEvent(category));
        },
        topPadding: topPadding,
      ),
    );
  }

  Widget _buildPromotionalBanner(List<Color> gradientColors) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              child: PageView.builder(
                controller: _bannerController,
                itemCount: _banners.length,
                onPageChanged: (index) {
                  setState(() => _currentBannerPage = index);
                },
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _bannerController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_bannerController.position.haveDimensions) {
                        value = _bannerController.page! - index;
                        value = (1 - (value.abs() * 0.15)).clamp(0.0, 1.0);
                      } else {
                        value = index == _currentBannerPage ? 1.0 : 0.85;
                      }
                      return Transform.scale(scale: value, child: child);
                    },
                    child: _buildBannerCard(_banners[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _banners.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentBannerPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentBannerPage == index
                        ? gradientColors[1]
                        : Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCard(_BannerData banner) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            if (banner.image != null)
              Positioned.fill(
                child: Image.asset(banner.image!, fit: BoxFit.cover),
              )
            else
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: banner.gradient ?? [Colors.grey, Colors.blueGrey],
                    ),
                  ),
                ),
              ),
            Positioned(
              right: 16,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'EXPLORE',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black,
                      size: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              'See all',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid(DashboardState state) {
    if (state.filteredProducts.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              children: [
                const Text('🔍', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text(
                  'No products found',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Try a different category',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.62,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          return ProductCard(product: state.filteredProducts[index]);
        }, childCount: state.filteredProducts.length),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade50,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 10, width: 80, color: Colors.white),
                        const SizedBox(height: 6),
                        Container(height: 10, width: 50, color: Colors.white),
                        const SizedBox(height: 8),
                        Container(height: 28, width: 60, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }, childCount: 6),
      ),
    );
  }

  Widget _buildErrorState() {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi_off_rounded,
                  size: 36,
                  color: Colors.red.shade400,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Oops! Something went wrong',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Please check your connection\nand try again.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<DashboardBloc>().add(LoadDashboardDataEvent());
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final List<Color> gradientColors;
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final double topPadding;

  _SearchBarDelegate({
    required this.gradientColors,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.topPadding,
  });

  @override
  double get minExtent => maxExtent;

  @override
  double get maxExtent => 125.0 + topPadding;

  @override
  bool shouldRebuild(covariant _SearchBarDelegate oldDelegate) {
    return oldDelegate.gradientColors != gradientColors ||
        oldDelegate.selectedCategory != selectedCategory ||
        oldDelegate.categories != categories ||
        oldDelegate.topPadding != topPadding;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(gradientColors[0], gradientColors[1], 0.4) ??
                gradientColors[0],
            gradientColors[1],
          ],
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: topPadding + 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  const Icon(Icons.search, color: Colors.black54, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Search "ice cream"',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(height: 30, width: 1, color: Colors.grey[300]),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.mic_none_outlined,
                    color: AppTheme.primaryGreen,
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          CategoryChips(
            categories: categories,
            selectedCategory: selectedCategory,
            onCategorySelected: onCategorySelected,
          ),
        ],
      ),
    );
  }
}

class _BannerData {
  final String title;
  final String subtitle;
  final String? image;
  final List<Color>? gradient;
  final String? emoji;

  _BannerData({
    required this.title,
    required this.subtitle,
    this.image,
    this.gradient,
    this.emoji,
  });
}