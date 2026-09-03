import 'package:flutter/material.dart';

void main() {
  runApp(const AarvoApp());
}

// ─────────────────────────────────────────────
// AARVO APP
// ─────────────────────────────────────────────

class AarvoApp extends StatelessWidget {
  const AarvoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AARVO',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF7F7FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C35FF),
        ),
      ),
      home: const HomePage(),
    );
  }
}

// ─────────────────────────────────────────────
// DATA
// ─────────────────────────────────────────────

class Product {
  final String name;
  final String category;
  final String emoji;
  final double price;
  final double oldPrice;
  final String color;

  const Product({
    required this.name,
    required this.category,
    required this.emoji,
    required this.price,
    required this.oldPrice,
    required this.color,
  });
}

const products = [
  Product(
    name: 'Premium Headphones',
    category: 'Electronics',
    emoji: '🎧',
    price: 1499,
    oldPrice: 2499,
    color: '6C35FF',
  ),
  Product(
    name: 'Smart Watch Pro',
    category: 'Electronics',
    emoji: '⌚',
    price: 1999,
    oldPrice: 3299,
    color: '00A8FF',
  ),
  Product(
    name: 'Running Shoes',
    category: 'Fashion',
    emoji: '👟',
    price: 1299,
    oldPrice: 2199,
    color: 'FF4F81',
  ),
  Product(
    name: 'Classic Backpack',
    category: 'Fashion',
    emoji: '🎒',
    price: 899,
    oldPrice: 1499,
    color: 'FF8A00',
  ),
  Product(
    name: 'Wireless Speaker',
    category: 'Electronics',
    emoji: '🔊',
    price: 999,
    oldPrice: 1799,
    color: '00B894',
  ),
  Product(
    name: 'Sunglasses',
    category: 'Fashion',
    emoji: '🕶️',
    price: 699,
    oldPrice: 1199,
    color: 'F5A623',
  ),
];

// ─────────────────────────────────────────────
// HOME
// ─────────────────────────────────────────────

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0;
  final List<Product> cart = [];
  final List<Product> wishlist = [];

  final TextEditingController searchController = TextEditingController();

  String searchText = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Product> get filteredProducts {
    if (searchText.trim().isEmpty) return products;

    return products.where((product) {
      return product.name
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
          product.category
              .toLowerCase()
              .contains(searchText.toLowerCase());
    }).toList();
  }

  void addToCart(Product product) {
    setState(() {
      cart.add(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} cart mein add ho gaya'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF17152A),
      ),
    );
  }

  void toggleWishlist(Product product) {
    setState(() {
      if (wishlist.contains(product)) {
        wishlist.remove(product);
      } else {
        wishlist.add(product);
      }
    });
  }

  void openProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductPage(
          product: product,
          isWishlisted: wishlist.contains(product),
          onWishlist: () => toggleWishlist(product),
          onAddCart: () => addToCart(product),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: selectedTab,
          children: [
            buildHome(),
            CategoriesPage(
              onProductTap: openProduct,
            ),
            WishlistPage(
              wishlist: wishlist,
              onProductTap: openProduct,
              onWishlist: toggleWishlist,
            ),
            ProfilePage(
              cartCount: cart.length,
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (index) {
          setState(() {
            selectedTab = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE9DDFF),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget buildHome() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'AARVO',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: Color(0xFF17152A),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CartPage(
                              cart: cart,
                              onRemove: (product) {
                                setState(() {
                                  cart.remove(product);
                                });
                              },
                            ),
                          ),
                        );
                      },
                      icon: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(
                            Icons.shopping_bag_outlined,
                            size: 28,
                          ),
                          if (cart.isNotEmpty)
                            Positioned(
                              right: -7,
                              top: -7,
                              child: CircleAvatar(
                                radius: 9,
                                backgroundColor: const Color(0xFFFF3D71),
                                child: Text(
                                  '${cart.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                const Text(
                  'Sab Kuch, Ek Hi Jagah',
                  style: TextStyle(
                    color: Color(0xFF77758A),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 20),

                // SEARCH
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.07),
                        blurRadius: 18,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF6C35FF),
                      ),
                      suffixIcon: searchText.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                searchController.clear();
                                setState(() {
                                  searchText = '';
                                });
                              },
                              icon: const Icon(Icons.close),
                            )
                          : const Icon(Icons.tune),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 17,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // HERO
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF6C35FF),
                        Color(0xFFB12CFF),
                        Color(0xFFFF4F81),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C35FF).withOpacity(.25),
                        blurRadius: 25,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.18),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '🔥 TRENDING NOW',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Big Deals.\nBold Choices.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 27,
                                height: 1.05,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Up to 60% OFF',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        '🛍️',
                        style: TextStyle(fontSize: 65),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 27),

                const Text(
                  'Shop by Category',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 14),

                SizedBox(
                  height: 105,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      categoryChip('📱', 'Electronics'),
                      categoryChip('👕', 'Fashion'),
                      categoryChip('🏠', 'Home'),
                      categoryChip('💄', 'Beauty'),
                      categoryChip('🎮', 'Gaming'),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Popular Products',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('View all'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // PRODUCTS
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 25),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = filteredProducts[index];

                return ProductCard(
                  product: product,
                  isWishlisted: wishlist.contains(product),
                  onTap: () => openProduct(product),
                  onWishlist: () => toggleWishlist(product),
                  onCart: () => addToCart(product),
                );
              },
              childCount: filteredProducts.length,
            ),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 16,
              childAspectRatio: .67,
            ),
          ),
        ),
      ],
    );
  }

  Widget categoryChip(String emoji, String title) {
    return Container(
      width: 92,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 7),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PRODUCT CARD
// ─────────────────────────────────────────────

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isWishlisted;
  final VoidCallback onTap;
  final VoidCallback onWishlist;
  final VoidCallback onCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.isWishlisted,
    required this.onTap,
    required this.onWishlist,
    required this.onCart,
  });

  Color get productColor {
    return Color(int.parse('FF${product.color}', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.07),
              blurRadius: 16,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(22),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          productColor.withOpacity(.13),
                          productColor.withOpacity(.04),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        product.emoji,
                        style: const TextStyle(fontSize: 65),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: onWishlist,
                      child: CircleAvatar(
                        radius: 17,
                        backgroundColor: Colors.white,
                        child: Icon(
                          isWishlisted
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 19,
                          color: isWishlisted
                              ? const Color(0xFFFF3D71)
                              : Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE8EF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'SALE',
                        style: TextStyle(
                          color: Color(0xFFFF3D71),
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category,
                    style: const TextStyle(
                      color: Color(0xFF8A8798),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Text(
                        '₹${product.price.toInt()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '₹${product.oldPrice.toInt()}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 34,
                    child: ElevatedButton(
                      onPressed: onCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C35FF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
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

// ─────────────────────────────────────────────
// PRODUCT DETAILS
// ─────────────────────────────────────────────

class ProductPage extends StatelessWidget {
  final Product product;
  final bool isWishlisted;
  final VoidCallback onWishlist;
  final VoidCallback onAddCart;

  const ProductPage({
    super.key,
    required this.product,
    required this.isWishlisted,
    required this.onWishlist,
    required this.onAddCart,
  });

  Color get productColor {
    return Color(int.parse('FF${product.color}', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Product Details',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            onPressed: onWishlist,
            icon: Icon(
              isWishlisted
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: const Color(0xFFFF3D71),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 330,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [
                    productColor.withOpacity(.18),
                    productColor.withOpacity(.05),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  product.emoji,
                  style: const TextStyle(fontSize: 150),
                ),
              ),
            ),

            const SizedBox(height: 22),

            Text(
              product.category.toUpperCase(),
              style: TextStyle(
                color: productColor,
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              product.name,
              style: const TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 13),

            Row(
              children: [
                Text(
                  '₹${product.price.toInt()}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '₹${product.oldPrice.toInt()}',
                  style: const TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  '40% OFF',
                  style: TextStyle(
                    color: Color(0xFF00A86B),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why you will love it',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '✨ Premium quality\n'
                    '🚚 Fast delivery\n'
                    '🔒 Secure shopping\n'
                    '↩️ Easy returns',
                    style: TextStyle(
                      height: 1.9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: onAddCart,
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text(
                  'ADD TO CART',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C35FF),
                  foregroundColor: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CATEGORIES
// ─────────────────────────────────────────────

class CategoriesPage extends StatelessWidget {
  final Function(Product) onProductTap;

  const CategoriesPage({
    super.key,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      ('📱', 'Electronics'),
      ('👕', 'Fashion'),
      ('🏠', 'Home'),
      ('💄', 'Beauty'),
      ('🎮', 'Gaming'),
      ('📚', 'Books'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Explore everything on AARVO',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 25),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (_, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.06),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      categories[index].$1,
                      style: const TextStyle(fontSize: 50),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      categories[index].$2,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 30),

          const Text(
            'Featured',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 15),

          ...products.take(3).map(
                (product) => ListTile(
                  onTap: () => onProductTap(product),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 5,
                  ),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFFEDE7FF),
                    child: Text(
                      product.emoji,
                      style: const TextStyle(fontSize: 25),
                    ),
                  ),
                  title: Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  subtitle: Text(product.category),
                  trailing: Text(
                    '₹${product.price.toInt()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WISHLIST
// ─────────────────────────────────────────────

class WishlistPage extends StatelessWidget {
  final List<Product> wishlist;
  final Function(Product) onProductTap;
  final Function(Product) onWishlist;

  const WishlistPage({
    super.key,
    required this.wishlist,
    required this.onProductTap,
    required this.onWishlist,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Wishlist',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 20),

          if (wishlist.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 70),
              child: const Column(
                children: [
                  Text(
                    '💜',
                    style: TextStyle(fontSize: 70),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Your wishlist is empty',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Save products you love here.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: wishlist.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 16,
                childAspectRatio: .67,
              ),
              itemBuilder: (_, index) {
                final product = wishlist[index];

                return ProductCard(
                  product: product,
                  isWishlisted: true,
                  onTap: () => onProductTap(product),
                  onWishlist: () => onWishlist(product),
                  onCart: () {},
                );
              },
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CART
// ─────────────────────────────────────────────

class CartPage extends StatelessWidget {
  final List<Product> cart;
  final Function(Product) onRemove;

  const CartPage({
    super.key,
    required this.cart,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final total = cart.fold<double>(
      0,
      (sum, product) => sum + product.price,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: cart.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🛒', style: TextStyle(fontSize: 70)),
                  SizedBox(height: 15),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: cart.length,
                    itemBuilder: (_, index) {
                      final product = cart[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 13),
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0EAFF),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  product.emoji,
                                  style: const TextStyle(fontSize: 35),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '₹${product.price.toInt()}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF6C35FF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => onRemove(product),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Color(0xFFFF3D71),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    18,
                    20,
                    25,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Text(
                            '₹${total.toInt()}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Checkout screen coming next!',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF6C35FF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'PROCEED TO CHECKOUT',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

// ─────────────────────────────────────────────
// PROFILE
// ─────────────────────────────────────────────

class ProfilePage extends StatelessWidget {
  final int cartCount;

  const ProfilePage({
    super.key,
    required this.cartCount,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF6C35FF),
                  Color(0xFFFF4F81),
                ],
              ),
            ),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 48,
                    color: Color(0xFF6C35FF),
                  ),
                ),
                SizedBox(height: 13),
                Text(
                  'Welcome to AARVO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Sab Kuch, Ek Hi Jagah',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          profileOption(
            Icons.shopping_bag_outlined,
            'My Orders',
          ),
          profileOption(
            Icons.location_on_outlined,
            'My Addresses',
          ),
          profileOption(
            Icons.notifications_none,
            'Notifications',
          ),
          profileOption(
            Icons.settings_outlined,
            'Settings',
          ),
          profileOption(
            Icons.help_outline,
            'Help & Support',
          ),
        ],
      ),
    );
  }

  Widget profileOption(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEDE7FF),
          child: Icon(
            icon,
            color: const Color(0xFF6C35FF),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
      ),
    );
  }
}
