import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../utils/utils.dart';
import '../model/model.dart';

class ProductsRepository extends ApiClient {
  ProductsRepository() : super();

  static const String _favouritesBoxName = 'favourites';

  /// Dummy GET API call to fetch product list with Hive persistent favourite status.
  Future<List<ProductModel>> getProducts() async {
    try {
      final dummyResponseData = {
        'result': true,
        'message': 'Products retrieved successfully',
        'payload': [
          {
            'id': 'p1',
            'name': 'Wireless Headphones',
            'price': 199.99,
            'category': 'Electronics',
            'imageUrl':
                'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
            'description':
                'Immerse yourself in premium audio performance with noise-cancellation technology, ultra-soft memory foam earcups, and up to 30 hours of continuous wireless playback.',
            'isFavourite': false,
          },
          {
            'id': 'p2',
            'name': 'Minimalist Watch',
            'price': 149.50,
            'category': 'Accessories',
            'imageUrl':
                'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
            'description':
                'Sleek, elegant timepiece crafted with a stainless steel case, sapphire crystal glass, and a genuine leather strap suitable for any formal or casual occasion.',
            'isFavourite': true,
          },
          {
            'id': 'p3',
            'name': 'Smart Fitness Tracker',
            'price': 79.99,
            'category': 'Electronics',
            'imageUrl':
                'https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?w=500',
            'description':
                'Track your daily activities, heart rate, sleep quality, and workout metrics with water-resistant durability and dynamic AMOLED display touch control.',
            'isFavourite': false,
          },
          {
            'id': 'p4',
            'name': 'Ergonomic Running Shoes',
            'price': 119.00,
            'category': 'Footwear',
            'imageUrl':
                'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
            'description':
                'Engineered with responsive foam cushioning and breathable mesh uppers designed to absorb impact and keep you moving comfortably over long distances.',
            'isFavourite': false,
          },
          {
            'id': 'p5',
            'name': 'Classic Denim Jacket',
            'price': 89.95,
            'category': 'Apparel',
            'imageUrl':
                'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=500',
            'description':
                'Timeless denim outerwear featuring durable cotton twill, chest buttoned flap pockets, and an adjustable waist for a versatile layered outfit.',
            'isFavourite': true,
          },
          {
            'id': 'p6',
            'name': 'Ceramic Coffee Mug',
            'price': 24.99,
            'category': 'Home & Living',
            'imageUrl':
                'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=500',
            'description':
                'Handcrafted ceramic mug designed to hold your favorite hot beverages. Dishwasher and microwave safe with an easy-grip ergonomic handle.',
            'isFavourite': false,
          },
        ],
      };

      // Simulate network delay for dummy GET API call
      await Future<void>.delayed(const Duration(seconds: 1));

      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: '/products', method: 'GET'),
        data: dummyResponseData,
      );

      final apiResponse =
          ApiResponse.fromJson(response.data as Map<String, dynamic>);

      if (apiResponse is ApiFailureResponse) {
        throw Exception(apiResponse.message);
      } else {
        final list = apiResponse.data as List<dynamic>;
        final box = Hive.isBoxOpen(_favouritesBoxName)
            ? Hive.box<bool>(_favouritesBoxName)
            : await Hive.openBox<bool>(_favouritesBoxName);

        return list.map((item) {
          final map = item as Map<String, dynamic>;
          final id = map['id'] as String;
          final initialFav = map['isFavourite'] as bool? ?? false;
          final savedFav = box.get(id, defaultValue: initialFav) ?? initialFav;
          map['isFavourite'] = savedFav;
          return ProductModel.fromJson(map);
        }).toList();
      }
    } on Exception catch (e) {
      return onError(e);
    }
  }

  /// Dummy API call to toggle product favourite status and persist in Hive.
  Future<bool> toggleFavouriteApi(String productId, bool currentFavState) async {
    final newFavState = !currentFavState;

    // Simulate dummy API request delay for toggling favourite
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final box = Hive.isBoxOpen(_favouritesBoxName)
        ? Hive.box<bool>(_favouritesBoxName)
        : await Hive.openBox<bool>(_favouritesBoxName);

    await box.put(productId, newFavState);
    return newFavState;
  }

  /// Dummy GET API call to fetch details for a single product by ID.
  Future<ProductModel> getProductDetails(String productId) async {
    final products = await getProducts();
    final index = products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      // Simulate network delay for GET detail API call
      await Future<void>.delayed(const Duration(milliseconds: 600));
      return products[index];
    } else {
      throw Exception('Product not found');
    }
  }
}
