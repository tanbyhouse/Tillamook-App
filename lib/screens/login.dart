import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'product_list.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  String _currentNim = '';

  Future<void> _login() async {
    final nim = _nimController.text.trim();

    if (nim.isEmpty) {
      _showSnackBar('NIM cannot be empty');
      return;
    }

    setState(() => _isLoading = true);

    final token = await _apiService.login(nim);

    setState(() => _isLoading = false);

    if (token != null) {
      if (mounted) {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (_) => const ProductList()),
        );
      }
    } else {
      _showSnackBar('Login failed');
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _nimController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFF1F2E59),
                            width: 2.0
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 100,
                                height: 3,
                                margin: const EdgeInsets.only(bottom: 31),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1F2E59),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            
                            Center(
                              child: const Text(
                                'Tillamook\nDairies',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1F2E59),
                                  height: 1.1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            Center(
                              child: const Text(
                                'Welcome Back!!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF1F2E59),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            TextField(
                              controller: _nimController,
                              keyboardType: TextInputType.number,
                              onChanged: (val) => setState(() => _currentNim = val),
                              decoration: const InputDecoration(
                                hintText: 'NIM',
                              ),
                            ),
                            const SizedBox(height: 12),

                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Password',
                              ),
                            ),
                            const SizedBox(height: 24),

                            ElevatedButton(
                              onPressed: _isLoading ? null : _login, 
                              child: _isLoading ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ) : const Text('Login'),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                _currentNim.isEmpty ? '' : _currentNim,
                style: const TextStyle(
                  color: Color(0xFF1F2E59),
                  fontSize: 13,
                ),
              ),
            ),
          ],
        )
      ),
      // ),
  // ),
    );
  }
}