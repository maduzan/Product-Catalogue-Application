import '../model/model.dart';

/// Abstract base class for Product states.
abstract class ProductState {
  const ProductState();
}

/// Initial product state.
class ProductInitial extends ProductState {}

/// Product state when loading/fetching products.
class ProductLoading extends ProductState {}

/// Product state when product retrieval succeeds.
class ProductSuccess extends ProductState {
  const ProductSuccess(this.products);
  final List<ProductModel> products;
}

/// Product state when product retrieval fails.
class ProductFailed extends ProductState {
  const ProductFailed(this.message);
  final String message;
}

/// Abstract base class for Product Details states.
abstract class ProductDetailState {
  const ProductDetailState();
}

/// Initial product detail state.
class ProductDetailInitial extends ProductDetailState {}

/// Product detail state when loading detail info.
class ProductDetailLoading extends ProductDetailState {}

/// Product detail state when retrieval succeeds.
class ProductDetailSuccess extends ProductDetailState {
  const ProductDetailSuccess(this.product);
  final ProductModel product;
}

/// Product detail state when retrieval fails.
class ProductDetailFailed extends ProductDetailState {
  const ProductDetailFailed(this.message);
  final String message;
}
