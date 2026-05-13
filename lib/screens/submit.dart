import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SubmitAssignment extends StatefulWidget {
  const SubmitAssignment({super.key});

  @override
  State<SubmitAssignment> createState() => _SubmitAssignmentState();
}

class _SubmitAssignmentState extends State<SubmitAssignment> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _githubController = TextEditingController();

  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String _nim = '';

  @override
  void initState() {
    super.initState();
    _loadNim();
  }

  Future<void> _loadNim() async {
    final nim = await _apiService.getNim();
    if (mounted) setState(() => _nim = nim ?? '');
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final success = await _apiService.submitTugas(
      _nameController.text.trim(),
      int.tryParse(_priceController.text.trim()) ?? 0,
      _descController.text.trim(),
      _githubController.text.trim(),
    );
    setState(() => _isLoading = false);
    if (mounted) {
      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit assignment')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _githubController.dispose();
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 16),
                child: Column(
                  children: [
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
                            // Header card
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const Icon(Icons.arrow_back,
                                      color: Color(0xFF1E2D5A)),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Submit Assignment',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E2D5A),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                  hintText: 'Product Name'),
                              validator: (val) => val!.isEmpty
                                  ? 'Name cannot be empty'
                                  : null,
                            ),
                            const SizedBox(height: 12),

                            TextFormField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: 'Price (Rp)'),
                              validator: (val) {
                                if (val!.isEmpty) return 'Price cannot be empty';
                                if (int.tryParse(val) == null)
                                  return 'Must be a number';
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            TextFormField(
                              controller: _descController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                  hintText: 'Description'),
                              validator: (val) => val!.isEmpty
                                  ? 'Description cannot be empty'
                                  : null,
                            ),
                            const SizedBox(height: 12),

                            TextFormField(
                              controller: _githubController,
                              decoration: const InputDecoration(
                                  hintText: 'Github URL'),
                              validator: (val) => val!.isEmpty
                                  ? 'GitHub URL cannot be empty'
                                  : null,
                            ),
                            const SizedBox(height: 24),

                            ElevatedButton(
                              onPressed: _isLoading ? null : _submit,
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Submit Assignment'),
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
                    color: Color(0xFF1E2D5A), fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}