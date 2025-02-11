import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:oru/providers/brand_provider.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../utils/routes.dart';
import '../widgets/buildCategoryButton.dart';
import '../widgets/buildIconButton.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  bool _isBottomNavVisible = true;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        setState(() => _isBottomNavVisible = false);
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        setState(() => _isBottomNavVisible = true);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    // Fetch products on initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (productProvider.products.isEmpty && !productProvider.isLoading) {
        productProvider.fetchProducts();
      }
    });

    // Get the combined list of products and dummy products
    final combinedProducts = productProvider.getProductsWithDummies();

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.pixels ==
              scrollNotification.metrics.maxScrollExtent) {
            productProvider.fetchProducts();
          }
          return true;
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Sliver App Bar with Search Bar
            SliverAppBar(
              title: Row(
                children:[
                  IconButton(onPressed: (){}, icon: Icon(Icons.menu)),
                  SizedBox(
                  height: 80,
                    width: 80,
                    child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0cBwtJxQ14kN_z1ua49yRZyt2qFzu4_vx8A&s")),
             ]
              ),
              floating: true,
              pinned: true,
              snap: false,
              actions: [
                TextButton(
                  onPressed: () {
                    Provider.of<AuthProvider>(context, listen: false).logout();
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                  child: const Text("Login"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.yellow),
                  ),
                ),
              ],
              bottom: AppBar(
                title: Container(
                  width: double.infinity,
                  height: 40,
                  color: Colors.white,
                  child: const Center(
                    child: TextField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.0
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(14))
                        ) ,
                        contentPadding: EdgeInsets.only(top: 1),
                        hintStyle: TextStyle(
                          fontSize: 14
                        ),
                        hintText: 'Search phones with make,model.....',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: Icon(Icons.mic)
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                height: 60, // Set a fixed height for horizontal ListView
                child: ListView(
                  scrollDirection: Axis.horizontal, // Make it scroll horizontally
                  children: [
                    buildCategoryButton('Sell Used Phones'),
                    buildCategoryButton('Buy Used Phones'),
                    buildCategoryButton('Compare Prices'),
                    buildCategoryButton('My Profile'),
                    buildCategoryButton('My Listings'),
                    buildCategoryButton('Services'),
                    buildCategoryButton('Register your Store'),
                    buildCategoryButton('Get the App'),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Consumer<BrandProvider>(
                builder: (context, brandProvider, child) {
                  if (brandProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Container(
                    height: 80, // Adjust height as needed
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: brandProvider.brands.map((brand) {
                        return buildIconButton(brand.imagePath, brand.make);
                      }).toList(),
                    ),
                  );
                },
              ),
            ),

            // Sliver Grid for Products
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 cards per row
                childAspectRatio: 0.65, // Adjusts card height
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  if (index == combinedProducts.length) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final product = combinedProducts[index];
                  return _buildProductCard(product, context);
                },
                childCount: combinedProducts.length + (productProvider.isLoading ? 1 : 0),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type:  BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'My Listings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product, BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Colors.white,
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
                child: Image.network(
                  product.imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      product.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: product.isLiked ? Colors.red : Colors.black54,
                    ),
                    onPressed: () {
                      if (authProvider.status != AuthStatus.authenticated) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please login to like products')),
                        );
                        return;
                      }
                      productProvider.toggleLike(product.id);
                    },
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '₹${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Like New',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                Text(product.city ?? 'Unknown'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}