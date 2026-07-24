import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../app/controller/controller.dart';
import '../../auth/controller/controller.dart';
import '../../utils/utils.dart';
import '../controller/controller.dart';
import '../widgets/widgets.dart';

class ProductListHome extends StatefulWidget {
  const ProductListHome({super.key});

  @override
  _ProductListHomeState createState() => _ProductListHomeState();
}

class _ProductListHomeState extends State<ProductListHome> {
  @override
  void initState() {
    super.initState();
    // Fetch products via Provider context on initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<ProductController>();
      if (controller.state is ProductInitial) {
        controller.fetchProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Catalogue',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Switch(
            value: GetIt.instance<ThemeServiceProvider>().isDark,
            onChanged: (value) {
              GetIt.instance<ThemeServiceProvider>().toggleTheme();
            },
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              GetIt.instance<AuthService>().logout();
            },
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
      body: Consumer<ProductController>(
        builder: (context, controller, child) {
          final state = controller.state;

          if (state is ProductLoading || state is ProductInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ProductFailed) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    state.message.isNotEmpty
                        ? state.message
                        : 'Failed to load products',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => controller.fetchProducts(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          if (state is ProductSuccess) {
            final products = state.products;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FixedGap(mainAxisExtent: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CommonSearchBar(
                    hintText: 'Search products by name or category...',
                    onChanged: (query) {
                      controller.searchProducts(query);
                    },
                    onSubmitted: (query) {
                      controller.searchProducts(query);
                    },
                  ),
                ),
                const FixedGap(mainAxisExtent: 16),
                Expanded(
                  child: products.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search_off,
                                  size: 64, color: Colors.grey),
                              const SizedBox(height: 12),
                              Text(
                                'No products found',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () => controller.fetchProducts(),
                          child: GridView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.68,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return ProductCard(
                                product: product,
                                onFavouriteToggle: () {
                                  controller.toggleFavourite(product.id);
                                },
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
