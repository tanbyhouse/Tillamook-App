import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/product_model.dart';

class ApiService {
  static const String baseUrl = 'https://task.itprojects.web.id';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // token management
  // simpan token setelah login
  static const String _authTokenKey = 'auth_token';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _authTokenKey, value: token);
  }
  // ambil token tiap request
  Future<String?> getToken() async {
    return await _storage.read(key: _authTokenKey);
  }
  // hapus token ketika logout
  Future<void> deleteToken() async {
    await _storage.delete(key: _authTokenKey);
  }

  // auth
  Future<String?> login(String nim) async {
    final url = Uri.parse('$baseUrl/api/auth/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'username': nim,
        'password': nim,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['data']['token'];

      await saveToken(token);
      return token;
    }
    return null;
  }

  // authorization bearer token
  Future<Map<String, String>> _authHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // products
  Future<List<Product>> getProducts() async {
    final url = Uri.parse('$baseUrl/api/products');
    final headers = await _authHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List productsJson = data['data']['products'];
      return productsJson.map((e) => Product.fromJson(e)).toList();
    }
    return [];
  }

  // save product as draft
  Future<bool> addProduct(String name, int price, String description) async {
    final url = Uri.parse('$baseUrl/api/products');
    final headers = await _authHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
      }),
    );

    return response.statusCode == 201;
  }

  // delete product by id
  Future<bool> deleteProduct(int id) async {
    final url = Uri.parse('$baseUrl/api/products/$id');
    final headers = await _authHeaders();

    final response = await http.delete(url, headers: headers);
    return response.statusCode == 200;
  }

  Future<bool> submitTugas(
    String name,
    int price,
    String description,
    String githubUrl,
  ) async {
    final url = Uri.parse('$baseUrl/api/products/submit');
    final headers = await _authHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
        'github_url': githubUrl,
      }),
    );

    return response.statusCode == 201;
  }
}