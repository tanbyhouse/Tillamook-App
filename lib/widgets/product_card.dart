import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onDelete,
  });

  String _formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.'
    )}';
  }

  String _extractCategory(String name) {
    final match = RegExp(r'\[(.+?)\]').firstMatch(name);
    return match?.group(1) ?? 'Product';
  }

  String _extractName(String name) {
    return name.replaceAll(RegExp(r'\[.+?\]\s*'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0x201F2E59),
          )
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _extractCategory(product.name),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1F2E59),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    _extractName(product.name),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF1F2E59),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF1F2E59),
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    _formatPrice(product.price),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1F2E59),
                    ),
                  ),

                ],
              ),
            ),

            // icon delete
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0x201F2E59),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: onDelete, 
                icon: const Icon(
                  Icons.delete_rounded,
                  color: Color(0xFF1F2E59),
                  size: 20,
                )
              ),
            )
          ],
        ),

      // ),
    );
  }
}