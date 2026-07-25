import 'package:flutter/foundation.dart';
import '../model/model.dart';
import 'repository.dart';
import 'states.dart';

class ProductController with ChangeNotifier {
  ProductController({ProductsRepository? repository})
      : _repository = repository ?? ProductsRepository();

  final ProductsRepository _repository;

  ProductState _state = ProductInitial();
  ProductDetailState _detailState = ProductDetailInitial();

  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  String _searchQuery = '';

  ProductState get state => _state;
  ProductDetailState get detailState => _detailState;
  List<ProductModel> get products =>
      _searchQuery.isEmpty ? _products : _filteredProducts;
  String get searchQuery => _searchQuery;

  /// Fetches products using the dummy GET API call from ProductsRepository
  Future<void> fetchProducts() async {
    _state = ProductLoading();
    notifyListeners();

    try {
      final result = await _repository.getProducts();
      _products = result;
      _applySearchFilter();
      _state = ProductSuccess(_filteredProducts);
    } catch (e) {
      _state = ProductFailed(e.toString());
    }
    notifyListeners();
  }

  /// Fetches single product details using dummy GET detail API call
  Future<void> fetchProductDetails(String productId) async {
    _detailState = ProductDetailLoading();
    notifyListeners();

    try {
      final result = await _repository.getProductDetails(productId);
      _detailState = ProductDetailSuccess(result);
    } catch (e) {
      _detailState = ProductDetailFailed(e.toString());
    }
    notifyListeners();
  }

  /// Toggles the favourite status of a product by ID using dummy API call & Hive persistence
  Future<void> toggleFavourite(String productId) async {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final currentProduct = _products[index];
      final newFavState = !currentProduct.isFavourite;

      // Optimistic local UI update on product list
      _products[index] = currentProduct.copyWith(isFavourite: newFavState);
      _applySearchFilter();
      if (_state is ProductSuccess) {
        _state = ProductSuccess(_filteredProducts);
      }

      // Sync detail state if currently viewing this product
      if (_detailState is ProductDetailSuccess) {
        final detail = (_detailState as ProductDetailSuccess).product;
        if (detail.id == productId) {
          _detailState = ProductDetailSuccess(
            detail.copyWith(isFavourite: newFavState),
          );
        }
      }
      notifyListeners();

      try {
        // Persist change via dummy API & Hive
        await _repository.toggleFavouriteApi(productId, currentProduct.isFavourite);
      } catch (_) {
        // Rollback on error
        _products[index] = currentProduct;
        _applySearchFilter();
        if (_state is ProductSuccess) {
          _state = ProductSuccess(_filteredProducts);
        }
        // Rollback detail state
        if (_detailState is ProductDetailSuccess) {
          final detail = (_detailState as ProductDetailSuccess).product;
          if (detail.id == productId) {
            _detailState = ProductDetailSuccess(currentProduct);
          }
        }
        notifyListeners();
      }
    }
  }

  /// Searches products by name or category
  void searchProducts(String query) {
    _searchQuery = query;
    _applySearchFilter();
    if (_state is ProductSuccess) {
      _state = ProductSuccess(_filteredProducts);
    }
    notifyListeners();
  }

  void _applySearchFilter() {
    if (_searchQuery.isEmpty) {
      _filteredProducts = List.from(_products);
    } else {
      final q = _searchQuery.toLowerCase();
      _filteredProducts = _products.where((p) {
        return p.name.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q);
      }).toList();
    }
  }
}
