import 'package:dio/dio.dart';
import '../../utils/utils.dart';
import '../model/model.dart';

class ProductsRepository extends ApiClient {
  ProductsRepository() : super();

  /// Dummy GET API call to fetch product list.
  /// Simulates a network call to `GET /products` and returns a list of [ProductModel].
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
            'isFavourite': false,
          },
          {
            'id': 'p2',
            'name': 'Minimalist Watch',
            'price': 149.50,
            'category': 'Accessories',
            'imageUrl':
                'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
            'isFavourite': true,
          },
          {
            'id': 'p3',
            'name': 'Smart Fitness Tracker',
            'price': 79.99,
            'category': 'Electronics',
            'imageUrl':
                'https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?w=500',
            'isFavourite': false,
          },
          {
            'id': 'p4',
            'name': 'Ergonomic Running Shoes',
            'price': 119.00,
            'category': 'Footwear',
            'imageUrl':
                'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
            'isFavourite': false,
          },
          {
            'id': 'p5',
            'name': 'Classic Denim Jacket',
            'price': 89.95,
            'category': 'Apparel',
            'imageUrl':
                'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=500',
            'isFavourite': true,
          },
          {
            'id': 'p6',
            'name': 'Ceramic Coffee Mug',
            'price': 24.99,
            'category': 'Home & Living',
            'imageUrl':
                'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=500',
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
        return list
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } on Exception catch (e) {
      return onError(e);
    }
  }
}
