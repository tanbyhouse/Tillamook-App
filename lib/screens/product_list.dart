import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';
import 'add_product.dart';
import 'login.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final products = await _apiService.getProducts();
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  Future<void> _deleteProduct(int id) async {
    final confirm = await showDialog<bool>(
      context: context, 
      builder: (_) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure to delete this product?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

  if (confirm == true) {
    final success = await _apiService.deleteProduct(id);
    if (success) {
      _loadProducts();
    }
  }
}

// dialog inpusubmit
Future<void> _showSubmitDialog() async {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();
  final githubController = TextEditingController();

  await showDialog(
    context: context, 
    builder: (_) => AlertDialog(
      title: const Text('Submit'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: githubController,
              decoration: const InputDecoration(labelText: 'GitHub URL'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            final success = await _apiService.submitTugas(
              nameController.text.trim(), 
              int.tryParse(priceController.text.trim()) ?? 0,
              descController.text.trim(), 
              githubController.text.trim(),
            );
            if (mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(success
                  ? 'Submitted successfully'
                  : 'Failed to submit'),
              ));
            }
          },
          child: const Text('Submit'),
        ),
      ],
    ),
  );
}

Future<void> _logout() async {
  await _apiService.deleteToken();
  if (mounted) {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (_) => const Login()),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tillamook Dairies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: 'Submit',
            onPressed: _showSubmitDialog,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? const Center(child: Text('Catalogue is empty, add one now!'))
              : RefreshIndicator(
                  // refresh
                  onRefresh: _loadProducts,
                  child: ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (_, index) => ProductCard(
                      product: _products[index],
                      onDelete: () => _deleteProduct(_products[index].id),
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // navigasi ke add product
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProduct()),
          );
          if (result == true) _loadProducts();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}