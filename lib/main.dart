import 'package:flutter/material.dart';

void main() {
  runApp(const QwickBazaarApp());
}

class QwickBazaarApp extends StatelessWidget {
  const QwickBazaarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qwick Bazaar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F8FC),
      ),
      home: const HomePage(),
    );
  }
}

class Product {
  final String name;
  final String category;
  final double price;
  final double oldPrice;
  final String image;
  final String description;
  final double rating;

  const Product({
    required this.name,
    required this.category,
    required this.price,
    required this.oldPrice,
    required this.image,
    required this.description,
    required this.rating,
  });
}

const products = <Product>[
  Product(
    name: 'Wireless Earbuds',
    category: 'Electronics',
    price: 999,
    oldPrice: 1999,
    image: '🎧',
    rating: 4.4,
    description:
        'Clear sound wireless earbuds with comfortable design and long battery life.',
  ),
  Product(
    name: 'Smart Watch',
    category: 'Electronics',
    price: 1499,
    oldPrice: 2999,
    image: '⌚',
    rating: 4.3,
    description:
        'Stylish smart watch for everyday use with useful smart features.',
  ),
  Product(
    name: 'Cotton T-Shirt',
    category: 'Fashion',
    price: 499,
    oldPrice: 899,
    image: '👕',
    rating: 4.2,
    description:
        'Comfortable cotton T-shirt suitable for everyday wear.',
  ),
  Product(
    name: 'Running Shoes',
    category: 'Fashion',
    price: 1299,
    oldPrice: 2499,
    image: '👟',
    rating: 4.5,
    description:
        'Comfortable lightweight shoes designed for everyday walking and running.',
  ),
  Product(
    name: 'Backpack',
    category: 'Bags',
    price: 799,
    oldPrice: 1499,
    image: '🎒',
    rating: 4.1,
    description:
        'Useful everyday backpack with spacious compartments.',
  ),
  Product(
    name: 'Coffee Mug',
    category: 'Home',
    price: 249,
    oldPrice: 499,
    image: '☕',
    rating: 4.6,
    description:
        'Simple and stylish mug for home, school or office use.',
  ),
  Product(
    name: 'Study Lamp',
    category: 'Home',
    price: 699,
    oldPrice: 1199,
    image: '💡',
    rating: 4.3,
    description:
        'Compact desk lamp for reading and studying.',
  ),
  Product(
    name: 'Bluetooth Speaker',
    category: 'Electronics',
    price: 899,
    oldPrice: 1799,
    image: '🔊',
    rating: 4.4,
    description:
        'Portable Bluetooth speaker with powerful sound for everyday use.',
  ),
];

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });
}

final List<CartItem> cart = [];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0;
  String selectedCategory = 'All';
  String searchText = '';

  final TextEditingController searchController = TextEditingController();

  List<Product> get filteredProducts {
    return products.where((product) {
      final categoryMatch = selectedCategory == 'All' ||
          product.category == selectedCategory;

      final searchMatch = searchText.isEmpty ||
          product.name.toLowerCase().contains(searchText.toLowerCase()) ||
          product.category.toLowerCase().contains(searchText.toLowerCase());

      return categoryMatch && searchMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: selectedTab,
          children: [
            buildHome(),
            const OrdersPage(),
            const ProfilePage(),
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
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
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
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
            decoration: const BoxDecoration(
              color: Color(0xFF1565C0),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text(
                          'QB',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Qwick Bazaar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Sab Kuch, Ek Hi Jagah',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: openCart,
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchText.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              searchController.clear();
                              setState(() {
                                searchText = '';
                              });
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedCategory = 'All';
                    });
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: SizedBox(
            height: 105,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              children: [
                categoryButton('All', '🛍️'),
                categoryButton('Electronics', '📱'),
                categoryButton('Fashion', '👕'),
                categoryButton('Bags', '🎒'),
                categoryButton('Home', '🏠'),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(18, 10, 18, 18),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1565C0),
                  Color(0xFF42A5F5),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Big Deals',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Great products at great prices',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '🔥',
                  style: TextStyle(fontSize: 45),
                ),
              ],
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Popular Products',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${filteredProducts.length} items',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 12),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = filteredProducts[index];

                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsPage(
                          product: product,
                        ),
                      ),
                    ).then((_) {
                      setState(() {});
                    });
                  },
                );
              },
              childCount: filteredProducts.length,
            ),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.67,
            ),
          ),
        ),
      ],
    );
  }

  Widget categoryButton(String name, String emoji) {
    final selected = selectedCategory == name;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = name;
        });
      },
      child: Container(
        width: 92,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF1565C0)
                    : Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(height: 7),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                    selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CartPage(),
      ),
    ).then((_) {
      setState(() {});
    });
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FF),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Text(
                    product.image,
                    style: const TextStyle(fontSize: 58),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 15,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        product.rating.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '₹${product.oldPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
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

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsPage> createState() =>
      _ProductDetailsPageState();
}

class _ProductDetailsPageState
    extends State<ProductDetailsPage> {
  void addToCart() {
    final existing = cart.where(
      (item) => item.product.name == widget.product.name,
    );

    if (existing.isNotEmpty) {
      existing.first.quantity++;
    } else {
      cart.add(CartItem(product: widget.product));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product added to cart'),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CartPage(),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 280,
              width: double.infinity,
              color: const Color(0xFFEAF2FF),
              child: Center(
                child: Text(
                  product.image,
                  style: const TextStyle(fontSize: 120),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category,
                    style: const TextStyle(
                      color: Color(0xFF1565C0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${product.rating} Rating',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '₹${product.oldPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: addToCart,
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                      ),
                      label: const Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 17),
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

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double get total {
    return cart.fold(
      0,
      (sum, item) =>
          sum + (item.product.price * item.quantity),
    );
  }

  void checkout() {
    if (cart.isEmpty) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Order Ready'),
        content: Text(
          'Your order total is ₹${total.toStringAsFixed(0)}.\n\nCheckout and payment will be connected when the backend is added.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: cart.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];

                      return Card(
                        margin:
                            const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFEAF2FF),
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    item.product.image,
                                    style: const TextStyle(
                                      fontSize: 32,
                                    ),
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
                                      item.product.name,
                                      style: const TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '₹${item.product.price.toStringAsFixed(0)}',
                                    ),
                                    const SizedBox(height: 7),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (item.quantity >
                                                  1) {
                                                item.quantity--;
                                              } else {
                                                cart.removeAt(index);
                                              }
                                            });
                                          },
                                          icon: const Icon(
                                            Icons
                                                .remove_circle_outline,
                                          ),
                                        ),
                                        Text(
                                          '${item.quantity}',
                                          style:
                                              const TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              item.quantity++;
                                            });
                                          },
                                          icon: const Icon(
                                            Icons
                                                .add_circle_outline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(22),
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
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '₹${total.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: checkout,
                          child: const Text(
                            'Proceed to Checkout',
                            style: TextStyle(fontSize: 16),
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

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                size: 85,
                color: Colors.grey,
              ),
              const SizedBox(height: 15),
              const Text(
                'No orders yet',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your orders will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomePage(),
                    ),
                    (route) => false,
                  );
                },
                child: const Text('Start Shopping'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 45,
                    color: Color(0xFF1565C0),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Welcome to Qwick Bazaar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          profileOption(
            Icons.person_outline,
            'My Account',
          ),
          profileOption(
            Icons.location_on_outlined,
            'My Addresses',
          ),
          profileOption(
            Icons.favorite_border,
            'Wishlist',
          ),
          profileOption(
            Icons.help_outline,
            'Help & Support',
          ),
          profileOption(
            Icons.settings_outlined,
            'Settings',
          ),
        ],
      ),
    );
  }

  Widget profileOption(IconData icon, String title) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
