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
