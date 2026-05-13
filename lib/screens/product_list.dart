import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';
import 'add_product.dart';
import 'login.dart';
import 'submit.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  bool _isLoading = true;
  String _nim = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadNim();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final products = await _apiService.getProducts();
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  Future<void> _loadNim() async {
    final nim = await _apiService.getNim();
    if (mounted) setState(() => _nim = nim ?? '');
  }

  Future<void> _deleteProduct(int id) async {
    final confirm = await showDialog<bool>(
      context: context, 
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
        title: const Text('Delete Product'),
        content: const Text('Are you sure to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), 
            child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text('Delete', style: TextStyle(color: Colors.red),)),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _apiService.deleteProduct(id);
      if (success) {_loadProducts();
      }
    }
  }

  // // dialog inpusubmit
  // Future<void> _showSubmitDialog() async {
  //   final nameController = TextEditingController();
  //   final priceController = TextEditingController();
  //   final descController = TextEditingController();
  //   final githubController = TextEditingController();

  //   await showDialog(
  //     context: context, 
  //     builder: (_) => AlertDialog(
  //       title: const Text('Submit'),
  //       content: SingleChildScrollView(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: nameController,
  //               decoration: const InputDecoration(labelText: 'Product Name'),
  //             ),
  //             TextField(
  //               controller: priceController,
  //               decoration: const InputDecoration(labelText: 'Price'),
  //             ),
  //             TextField(
  //               controller: descController,
  //               decoration: const InputDecoration(labelText: 'Description'),
  //             ),
  //             TextField(
  //               controller: githubController,
  //               decoration: const InputDecoration(labelText: 'GitHub URL'),
  //             ),
  //           ],
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context), 
  //           child: const Text('Cancel'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () async {
  //             final success = await _apiService.submitTugas(
  //               nameController.text.trim(), 
  //               int.tryParse(priceController.text.trim()) ?? 0,
  //               descController.text.trim(), 
  //               githubController.text.trim(),
  //             );
  //             if (mounted) {
  //               Navigator.pop(context);
  //               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //                 content: Text(success
  //                   ? 'Submitted successfully'
  //                   : 'Failed to submit'),
  //               ));
  //             }
  //           },
  //           child: const Text('Submit'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
      // appBar: AppBar
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 10),
                      child: Text(
                        'Tillamook\nDairies',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1F2E59),
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: _logout,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(8, 30, 8, 10),
                      child: const Icon(
                        Icons.logout_rounded,
                        color: Color(0xFF1F2E59),
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsetsGeometry.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (_) => const AddProduct()
                          ),
                        );
                        if (result == true) _loadProducts();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                      ),
                      child: const Text('Add Product'),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // submit btn
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SubmitAssignment()),
                        );
                        if (result == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Assignment submitted!')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                      ),
                      child: const Text('Submit'),
                    ),
                  )
                ],
              ),
            ),

            // list product
            Expanded(
              child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _products.isEmpty
                  ? const Center(
                    child: Text('Catalogue is empty, add one now!'))
                // refresh
                  : RefreshIndicator(
                      onRefresh: _loadProducts,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 4, bottom: 16),
                        itemCount: _products.length,
                        itemBuilder: (_, index) => ProductCard(
                          product: _products[index],
                          onDelete: () => _deleteProduct(_products[index].id),
                        ),
                      ),
                    ),
            ),

            // footer
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                _nim,
                style: const TextStyle(
                  color: Color(0xFF1F2E59),
                  fontSize: 13
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}