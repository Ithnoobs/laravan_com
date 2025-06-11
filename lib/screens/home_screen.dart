import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  List<String> categories = [];
  String? selectedCategory;
  bool _isLoading = false;
  int _currentPage = 1;
  int _totalPages = 1;
  final int _limit = 10;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _getAllProduct();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String value) {
    setState(() {
      _searchQuery = value.trim();
      _currentPage = 1;
    });
    _getAllProduct();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var response = await apiService.getUrl("https://dummyjson.com/products/categories");
      if (kDebugMode) print('Categories API response: ' + response.toString());
      List<String> fetchedCategories = [];
      if (response is List) {
        if (response.isNotEmpty && response.first is String) {
          fetchedCategories = List<String>.from(response);
        } else if (response.isNotEmpty && response.first is Map) {
          fetchedCategories = response.map<String>((e) => e['name']?.toString() ?? '').where((e) => e.isNotEmpty).toList();
        }
      } else if (response is Map && response.containsKey('categories')) {
        var cats = response['categories'];
        if (cats is List) {
          fetchedCategories = List<String>.from(cats);
        }
      }
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      if (kDebugMode) print("Error fetching categories: $e");
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getAllProduct() async {
    setState(() {
      _isLoading = true;
      products.clear();
    });

    if (kDebugMode) print("Fetching products with search query: $_searchQuery, category: $selectedCategory, page: $_currentPage");
    String url;
    if (_searchQuery.isNotEmpty) {
      url = "https://dummyjson.com/products/search?q=${Uri.encodeComponent(_searchQuery)}&limit=$_limit&skip=${(_currentPage - 1) * _limit}";
    } else if (selectedCategory != null && selectedCategory!.isNotEmpty) {
      url = "https://dummyjson.com/products/category/${selectedCategory!}?limit=$_limit&skip=${(_currentPage - 1) * _limit}";
    } else {
      url = "https://dummyjson.com/products?limit=$_limit&skip=${(_currentPage - 1) * _limit}";
    }

    var response = await apiService.getUrl(url);
    var productsData = response['products'];
    setState(() {
      products = [];
      if (response != null && productsData != null && productsData.isNotEmpty) {
        products = List<Products>.from(productsData.map((product) => Products.fromJson(product)));
        int total = response['total'] ?? 0;
        _totalPages = (total / _limit).ceil();
      } else {
        _totalPages = 1;
      }
      _isLoading = false;
    });
  }

  void _onCategoryChanged(String? value) {
    setState(() {
      selectedCategory = value;
      _currentPage = 1;
    });
    _getAllProduct();
  }

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
    _getAllProduct();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Laravan Company', style: TextStyle(color: Colors.blueAccent)),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                ),
              )
            : Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search products...',
                              prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                              ),
                            ),
                            onSubmitted: _onSearchSubmitted,
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: IconButton(
                              icon: Icon(Icons.clear, color: Colors.blueAccent),
                              tooltip: 'Clear search',
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                  _currentPage = 1;
                                });
                                _getAllProduct();
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (categories.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: Colors.white,
                          splashColor: Colors.blueAccent.withOpacity(0.2),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                            border: Border.all(color: Colors.blueAccent, width: 1.5),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedCategory ?? '',
                              hint: Row(
                                children: [
                                  Icon(Icons.category, color: Colors.blueAccent),
                                  SizedBox(width: 8),
                                  Text('Select Category', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600)),
                                ],
                              ),
                              icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.blueAccent, size: 28),
                              dropdownColor: Colors.white,
                              style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600, fontSize: 16),
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(16),
                              items: [
                                DropdownMenuItem<String>(
                                  value: '',
                                  child: Row(
                                    children: [
                                      Icon(Icons.all_inclusive, color: Colors.blueAccent),
                                      SizedBox(width: 8),
                                      Text('All', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                                ...categories.map((cat) => DropdownMenuItem<String>(
                                      value: cat,
                                      child: Row(
                                        children: [
                                          Icon(Icons.label_important, color: Colors.blueAccent, size: 18),
                                          SizedBox(width: 8),
                                          Flexible(child: Text(cat[0].toUpperCase() + cat.substring(1), style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600))),
                                        ],
                                      ),
                                    ))
                              ],
                              onChanged: (value) {
                                _onCategoryChanged(value == '' ? null : value);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Container(
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
                      child: products.isEmpty
                          ? Center(child: Text('No products found.'))
                          : Scrollbar(
                              thumbVisibility: true,
                              thickness: 6,
                              radius: Radius.circular(8),
                              interactive: true,
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: _currentPage > 1 ? () => _goToPage(_currentPage - 1) : null,
                        ),
                        Text('Page $_currentPage of $_totalPages'),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: _currentPage < _totalPages ? () => _goToPage(_currentPage + 1) : null,
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