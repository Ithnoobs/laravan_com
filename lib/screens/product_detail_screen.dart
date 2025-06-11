import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:laravan_com/models/products.dart';
import 'package:laravan_com/service/api_service.dart';
import 'package:laravan_com/service/api_service_impli.dart';
import 'package:laravan_com/screens/carousel_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Products product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ApiService apiService = ApiServiceImpli();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if(kDebugMode){
      print('Product images for "${widget.product.title}": ${widget.product.images}');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.product.title,
          style: const TextStyle(color: Colors.blueAccent),
        ),
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              )
              : SingleChildScrollView(
                child: Column(
                  children: [
                    ProductImageCarousel(
                      imageUrls: widget.product.images,
                      height: 300,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 22),
                              SizedBox(width: 4),
                              Text(
                                widget.product.rating.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.product.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                'Price: \$${widget.product.price}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      widget.product.discountPercentage > 0 ? Colors.red : Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  widget.product.discountPercentage > 0
                                      ? '-${widget.product.discountPercentage}%'
                                      : 'No Discount',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.inventory_2, color: Colors.blueGrey, size: 20),
                              SizedBox(width: 4),
                              Text(
                                'Stock: ${widget.product.stock}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      widget.product.stock == 0 ? Colors.red : Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Remove the Wrap of Chips and instead display brand, category, and tags as simple text rows below the description
                          if (widget.product.brand != null && widget.product.brand!.isNotEmpty)
                            Text(
                              'Brand: ${widget.product.brand}',
                              style: TextStyle(fontSize: 15, color: Colors.blueAccent, fontWeight: FontWeight.w600),
                            ),
                          Text(
                            'Category: ${widget.product.category}',
                            style: TextStyle(fontSize: 15, color: Colors.blueAccent, fontWeight: FontWeight.w600),
                          ),
                          if (widget.product.tags.isNotEmpty)
                            Text(
                              'Tags: ${widget.product.tags.join(", ")}',
                              style: TextStyle(fontSize: 15, color: Colors.blueAccent, fontWeight: FontWeight.w600),
                            ),
                          Divider(color: Colors.green, thickness: 2),
                          Text(
                            'Warranty: ${widget.product.warrantyInformation}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.redAccent,
                            ),
                          ),
                          Text(
                            'Shipping: ${widget.product.shippingInformation}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.redAccent,
                            ),
                          ),
                          Text(
                            'Availability: ${widget.product.availabilityStatus}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.redAccent,
                            ),
                          ),
                          Divider(color: Colors.green, thickness: 2),
                          Text(
                            'Reviews: ${widget.product.reviews.length}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 10),
                          widget.product.reviews.isEmpty
                              ? Text(
                                  'No reviews yet.',
                                  style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: widget.product.reviews.length,
                                  separatorBuilder: (context, i) => Divider(),
                                  itemBuilder: (context, i) {
                                    final review = widget.product.reviews[i];
                                    return Container(
                                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.person, color: Colors.blueAccent, size: 20),
                                              SizedBox(width: 6),
                                              Text(
                                                review.reviewerName,
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                              ),
                                              Spacer(),
                                              Icon(Icons.star, color: Colors.amber, size: 18),
                                              SizedBox(width: 2),
                                              Text(
                                                review.rating.toString(),
                                                style: TextStyle(fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            review.comment,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '${review.date.day}/${review.date.month}/${review.date.year}',
                                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
