import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  // categories
  String _selectedCategory = 'Cheese';
  final List<String> _categories = ['Cheese', 'Ice Cream', 'Butter', 'Yogurt'];

  String _nim = '';

  @override
  void initState() {
    super.initState();
    _loadNim();
  }

  Future<void> _loadNim() async {
    final token = await _apiService.getToken();
    final nim = await _apiService.getNim();
    if (mounted) setState(() => _nim = nim ?? '');
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await _apiService.addProduct(
      '[$_selectedCategory] ${_nameController.text.trim()}',
      int.parse(_priceController.text.trim()), _descController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully!')),
      );
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add product!')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    // Title
                    Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 30),
                      child: const Text(
                        'Tillamook\nDairies',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E2D5A),
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFF1E2D5A),
                          width: 2.0
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Color(0xFF1E2D5A),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Add Product',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E2D5A),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            DropdownButtonFormField<String>(
                              initialValue: _selectedCategory, 
                              // value: _selectedCategory, 
                              decoration: InputDecoration(
                                hintText: 'Category',
                                filled: true,
                                fillColor: const Color(0x101F2E59),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              items: _categories
                                .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                                .toList(),
                              onChanged: (val) => setState(() => _selectedCategory = val!),
                            ),
                            const SizedBox(height: 12),

                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                hintText: 'Product Name',
                              ),
                              validator: (val) => val!.isEmpty ? 'Name cannot be empty' : null,
                            ),
                            const SizedBox(height: 12),

                            // harga
                            TextFormField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Price (Rp)',
                              ),
                              validator: (val) {
                                if (val!.isEmpty) return 'Price cannot be empty';
                                if (int.tryParse(val) == null) return 'Price must be a number';
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            // desc
                            TextFormField(
                              controller: _descController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                hintText: 'Description',
                                border: OutlineInputBorder(),
                              ),
                              validator: (val) => val!.isEmpty ? "Desciption cannot be empty" : null,
                            ),
                            const SizedBox(height: 24),

                            ElevatedButton(
                              onPressed: _isLoading ? null : _submit, 
                              child: _isLoading
                                ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: 
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text('Save Draft'),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text( 
                _nim,
                style: const TextStyle(
                  color: Color(0xFF1E2D5A),
                  fontSize: 13,
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}