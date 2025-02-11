import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../utils/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.pixels ==
              scrollNotification.metrics.maxScrollExtent) {
            productProvider.fetchProducts();
          }
          return true;
        },
        child: ListView.builder(
          itemCount: combinedProducts.length +
              (productProvider.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == combinedProducts.length) {
              return const Center(child: CircularProgressIndicator());
            }

            final product = combinedProducts[index];
            return _buildProductCard(product, context);
          },
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product, BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(product.imageUrl),
        title: Text(product.name),
        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: Icon(
            product.isLiked ? Icons.favorite : Icons.favorite_border,
            color: product.isLiked ? Colors.red : null,
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
    );
  }
}