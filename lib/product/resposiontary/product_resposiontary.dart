import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../core/api constants/api_constant.dart';
import '../../homePage/models/product.dart';

class ProductRepository {
  Future<List<Product>> getpdturl(String catId) async {
    final categoryId = catId.trim();

    debugPrint('====================================');
    debugPrint('PRODUCT API START');
    debugPrint('Category ID: "$categoryId"');
    debugPrint('URL: ${ApiConstant.pdturl}');

    if (categoryId.isEmpty || categoryId == '0') {
      throw Exception('Category ID is required');
    }

    try {
      final response = await http.post(
        Uri.parse(ApiConstant.pdturl),

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },

        body: jsonEncode({'catid': categoryId}),
      );

      debugPrint('HTTP Status: ${response.statusCode}');
      debugPrint('API Response: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Server error: ${response.statusCode}');
      }

      final Map<String, dynamic> data = jsonDecode(response.body);

      debugPrint('ResponseCode: ${data['ResponseCode']}');
      debugPrint('ResponseMsg: ${data['ResponseMsg']}');

      if (data['ResponseCode']?.toString() != '200') {
        throw Exception(
          data['ResponseMsg']?.toString() ?? 'Failed to load products',
        );
      }

      final List productList = data['productlist'] as List? ?? [];

      debugPrint('Products found: ${productList.length}');

      final products = productList.map((item) => Product.fromJson(item as Map<String, dynamic>)).toList();

      debugPrint('Products parsed: ${products.length}');
      debugPrint('PRODUCT API END');
      debugPrint('====================================');

      return products;
    } catch (e) {
      debugPrint('PRODUCT API ERROR: $e');

      rethrow;
    }
  }
}
