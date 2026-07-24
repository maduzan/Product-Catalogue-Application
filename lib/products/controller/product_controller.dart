import 'package:flutter/foundation.dart';
import '../model/model.dart';
import 'repository.dart';
import 'states.dart';

class ProductController with ChangeNotifier {
  ProductController({ProductsRepository? repository})
      : _repository = repository ?? ProductsRepository();

  final ProductsRepository _repository;

  ProductState _state = ProductInitial();
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  String _searchQuery = '';

  ProductState get state => _state;
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

  /// Toggles the favourite status of a product by ID
  void toggleFavourite(String productId) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final product = _products[index];
      _products[index] = product.copyWith(isFavourite: !product.isFavourite);
      _applySearchFilter();
      if (_state is ProductSuccess) {
        _state = ProductSuccess(_filteredProducts);
      }
      notifyListeners();
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
