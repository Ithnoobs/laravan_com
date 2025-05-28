import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:laravan_com/constants/api.dart';
import 'package:laravan_com/models/products.dart';
import 'package:laravan_com/screens/product_detail_screen.dart';
import 'package:laravan_com/service/api_service.dart';
import 'package:laravan_com/service/api_service_impli.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiService apiService = ApiServiceImpli();
  List<Products> products = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getAllProduct();
  }

  _getAllProduct() async {
    setState(() {
      _isLoading = true;
    });
    var response = await apiService.getUrl(Api.getAllProducts);
    var productsData = response['products'];
    if(null != response && productsData.isNotEmpty) {
      productsData.forEach((product) {
        products.add(Products.fromJson(product));
      });
      if(kDebugMode){
      print("Products loaded: ${products.length}");
      }
    }
    setState(() {
      _isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Laravan Company', style: TextStyle(color: Colors.blueAccent),),
        ),
        body: _isLoading == true ? Center(
          child: CircularProgressIndicator(
            color: Colors.blueAccent,
          ),
        ) : Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blueGrey.shade50,
                Colors.blueGrey.shade100,
                Colors.white,
              ],
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (BuildContext context, index) {
              var product = products[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    if (kDebugMode) {
                      print("Tapped on product: \\${product.title} (ID: \\${product.id})");
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.network(
                            product.thumbnail,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                product.title,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            SizedBox(width: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 22),
                                SizedBox(width: 4),
                                Text(
                                  product.rating.toStringAsFixed(1),
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(
                          product.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              "\$${product.price.toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 20, color: Colors.blueAccent, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 20),
                            Text(
                              "Stock: ${product.stock}",
                              style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.w600),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}