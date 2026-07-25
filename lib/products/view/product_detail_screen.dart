import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/controller.dart';
import '../widgets/widgets.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    required this.productId,
    required this.heroTag,
    super.key,
  });

  final String productId;
  final String heroTag;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductController>().fetchProductDetails(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, controller, child) {
        final detailState = controller.detailState;
        if (detailState is ProductDetailLoading ||
            detailState is ProductDetailInitial) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (detailState is ProductDetailFailed) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 56,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    detailState.message.isNotEmpty
                        ? detailState.message
                        : 'Failed to load product details',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () =>
                        controller.fetchProductDetails(widget.productId),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        if (detailState is ProductDetailSuccess) {
          final product = detailState.product;

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 320,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: ProductDetailImage(
                      imageUrl: product.imageUrl,
                      tag: widget.heroTag,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(20.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        ProductDetailHeader(
                          name: product.name,
                          price: product.price,
                          category: product.category,
                        ),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                        ProductDetailDescription(
                          description: product.description,
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: ProductDetailFavouriteButton(
              isFavourite: product.isFavourite,
              onPressed: () {
                controller.toggleFavourite(product.id);
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
