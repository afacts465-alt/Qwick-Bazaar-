import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:4000/api');
const navy = Color(0xFF102A56);
const orange = Color(0xFFFF6A00);

void main() => runApp(const AarvoApp());

class AarvoApp extends StatelessWidget {
  const AarvoApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'AARVO', debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: const Color(0xFFF7F8FA), colorScheme: ColorScheme.fromSeed(seedColor: orange)),
    home: const StoreShell(),
  );
}

class ApiClient {
  Future<List<Product>> products() async {
    final r = await http.get(Uri.parse('$apiBaseUrl/products'));
    if (r.statusCode != 200) throw Exception('Products unavailable');
    final data = jsonDecode(r.body) as List;
    return data.map((e) => Product.fromJson(e)).toList();
  }
  Future<String> login(String email, String password) async {
    final r = await http.post(Uri.parse('$apiBaseUrl/auth/login'), headers: {'content-type':'application/json'}, body: jsonEncode({'email':email,'password':password}));
    if (r.statusCode >= 300) throw Exception('Login failed');
    return (jsonDecode(r.body) as Map)['token'] as String;
  }
}

class Product {
  final String id, name, category, image;
  final int price;
  final double rating;
  const Product({required this.id, required this.name, required this.category, required this.image, required this.price, required this.rating});
  factory Product.fromJson(Map<String,dynamic> j) => Product(id:'${j['id']}',name:j['name'],category:j['category']['name'] ?? '',image:j['image'] ?? '',price:j['price'],rating:(j['rating'] ?? 0).toDouble());
}

const localProducts = [
  Product(id:'1',name:'Wireless Headphones',category:'Electronics',image:'🎧',price:1299,rating:4.6),
  Product(id:'2',name:'Classic Watch',category:'Fashion',image:'⌚',price:899,rating:4.4),
  Product(id:'3',name:'Smart Phone',category:'Electronics',image:'📱',price:12999,rating:4.5),
  Product(id:'4',name:'Running Shoes',category:'Fashion',image:'👟',price:1499,rating:4.3),
];

class StoreShell extends StatefulWidget { const StoreShell({super.key}); @override State<StoreShell> createState()=>_StoreShellState(); }
class _StoreShellState extends State<StoreShell> {
  int tab=0; List<Product> products=localProducts; final api=ApiClient();
  @override void initState(){super.initState(); _load();}
  Future<void> _load() async { try { final live=await api.products(); if(mounted && live.isNotEmpty)setState(()=>products=live); } catch (_) {} }
  @override Widget build(BuildContext context){
    final pages=[Home(products:products), const CartPage(), const OrdersPage(), const ProfilePage()];
    return Scaffold(body: pages[tab], bottomNavigationBar: NavigationBar(selectedIndex:tab,onDestinationSelected:(i)=>setState(()=>tab=i),destinations:const[
      NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home),label:'Home'),
      NavigationDestination(icon:Icon(Icons.shopping_bag_outlined),selectedIcon:Icon(Icons.shopping_bag),label:'Cart'),
      NavigationDestination(icon:Icon(Icons.local_shipping_outlined),selectedIcon:Icon(Icons.local_shipping),label:'Orders'),
      NavigationDestination(icon:Icon(Icons.person_outline),selectedIcon:Icon(Icons.person),label:'Account'),
    ]));
  }
}

class Home extends StatelessWidget { final List<Product> products; const Home({super.key,required this.products});
  @override Widget build(BuildContext c)=>SafeArea(child:CustomScrollView(slivers:[
    SliverToBoxAdapter(child:Padding(padding:const EdgeInsets.fromLTRB(20,18,20,8),child:Row(children:[
      Image.asset('assets/aarvo_logo.png',width:58,height:58,fit:BoxFit.cover), const SizedBox(width:10),
      const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('AARVO',style:TextStyle(fontSize:25,fontWeight:FontWeight.w900,color:navy)),Text('Sab Kuch, Ek Hi Jagah',style:TextStyle(fontSize:12,color:Colors.black54))])),
      IconButton(onPressed:(){},icon:const Icon(Icons.notifications_none_rounded))])),
    SliverToBoxAdapter(child:Padding(padding:const EdgeInsets.symmetric(horizontal:20,vertical:8),child:TextField(decoration:InputDecoration(hintText:'Search products, brands & more',prefixIcon:const Icon(Icons.search),filled:true,fillColor:Colors.white,border:OutlineInputBorder(borderRadius:BorderRadius.circular(16),borderSide:BorderSide.none))))),
    SliverToBoxAdapter(child:Container(margin:const EdgeInsets.all(20),padding:const EdgeInsets.all(22),decoration:BoxDecoration(gradient:const LinearGradient(colors:[navy,Color(0xFF244E8E)]),borderRadius:BorderRadius.circular(24)),child:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('AARVO BIG DEALS',style:TextStyle(color:Colors.white70,fontWeight:FontWeight.bold)),SizedBox(height:8),Text('Everything you need.\nOne trusted place.',style:TextStyle(color:Colors.white,fontSize:25,fontWeight:FontWeight.w900)),SizedBox(height:8),Text('Discover great products at great prices.',style:TextStyle(color:Colors.white70))]))),
    const SliverToBoxAdapter(child:Padding(padding:EdgeInsets.fromLTRB(20,0,20,12),child:Text('Shop by category',style:TextStyle(fontSize:20,fontWeight:FontWeight.w800)))),
    SliverToBoxAdapter(child:SizedBox(height:100,child:ListView(scrollDirection:Axis.horizontal,padding:const EdgeInsets.symmetric(horizontal:20),children:['Electronics','Fashion','Home','Beauty','Grocery'].map((x)=>Container(width:105,margin:const EdgeInsets.only(right:10),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(18)),child:Center(child:Text(x,textAlign:TextAlign.center,style:const TextStyle(fontWeight:FontWeight.w700)))).toList()))),
    const SliverToBoxAdapter(child:Padding(padding:EdgeInsets.fromLTRB(20,24,20,12),child:Text('Trending now',style:TextStyle(fontSize:20,fontWeight:FontWeight.w800)))),
    SliverPadding(padding:const EdgeInsets.symmetric(horizontal:20),sliver:SliverGrid(delegate:SliverChildBuilderDelegate((_,i)=>ProductCard(product:products[i]),childCount:products.length),gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:14,mainAxisSpacing:14,childAspectRatio:.72))),
    const SliverToBoxAdapter(child:SizedBox(height:30)),
  ]));
}

class ProductCard extends StatelessWidget { final Product product; const ProductCard({super.key,required this.product});
  @override Widget build(BuildContext c)=>InkWell(onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>ProductPage(product:product))),child:Container(padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(20)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Expanded(child:Center(child:Text(product.image,style:const TextStyle(fontSize:62)))),Text(product.category,style:const TextStyle(fontSize:11,color:Colors.black45)),const SizedBox(height:4),Text(product.name,maxLines:2,overflow:TextOverflow.ellipsis,style:const TextStyle(fontWeight:FontWeight.w800)),const SizedBox(height:6),Row(children:[Text('₹${product.price}',style:const TextStyle(fontWeight:FontWeight.w900,fontSize:16,color:navy)),const Spacer(),const Icon(Icons.star_rounded,size:17,color:orange),Text(product.rating.toString(),style:const TextStyle(fontSize:12))])
  ])));
}

class ProductPage extends StatelessWidget { final Product product; const ProductPage({super.key,required this.product}); @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('AARVO'),actions:[IconButton(onPressed:(){},icon:const Icon(Icons.favorite_border))]),body:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Container(height:280,width:double.infinity,decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(28)),child:Center(child:Text(product.image,style:const TextStyle(fontSize:120)))),const SizedBox(height:20),Text(product.category,style:const TextStyle(color:Colors.black54)),const SizedBox(height:5),Text(product.name,style:const TextStyle(fontSize:27,fontWeight:FontWeight.w900,color:navy)),const SizedBox(height:10),Text('₹${product.price}',style:const TextStyle(fontSize:24,fontWeight:FontWeight.w900)),const SizedBox(height:20),const Spacer(),SizedBox(width:double.infinity,height:54,child:FilledButton(style:FilledButton.styleFrom(backgroundColor:orange),onPressed:(){},child:const Text('ADD TO CART',style:TextStyle(fontWeight:FontWeight.w900))))])); }
class CartPage extends StatelessWidget { const CartPage({super.key}); @override Widget build(BuildContext c)=>const Center(child:Text('Your Cart',style:TextStyle(fontSize:25,fontWeight:FontWeight.w800))); }
class OrdersPage extends StatelessWidget { const OrdersPage({super.key}); @override Widget build(BuildContext c)=>const Center(child:Text('Your Orders',style:TextStyle(fontSize:25,fontWeight:FontWeight.w800))); }
class ProfilePage extends StatelessWidget { const ProfilePage({super.key}); @override Widget build(BuildContext c)=>Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[const Icon(Icons.person, size:70,color:navy),const SizedBox(height:12),const Text('AARVO Account',style:TextStyle(fontSize:24,fontWeight:FontWeight.w800)),const SizedBox(height:16),FilledButton(onPressed:()=>showDialog(context:c,builder:(_)=>const LoginDialog()),child:const Text('Login / Sign up'))])); }
class LoginDialog extends StatefulWidget { const LoginDialog({super.key}); @override State<LoginDialog> createState()=>_LoginDialogState(); }
class _LoginDialogState extends State<LoginDialog>{final email=TextEditingController(),pass=TextEditingController();bool loading=false;String? error;@override Widget build(BuildContext c)=>AlertDialog(title:const Text('Welcome to AARVO'),content:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:email,decoration:const InputDecoration(labelText:'Email')),TextField(controller:pass,obscureText:true,decoration:const InputDecoration(labelText:'Password')),if(error!=null)Text(error!,style:const TextStyle(color:Colors.red))]),actions:[TextButton(onPressed:()=>Navigator.pop(c),child:const Text('Cancel')),FilledButton(onPressed:loading?null:()async{setState(()=>loading=true);try{final token=await ApiClient().login(email.text.trim(),pass.text);final p=await SharedPreferences.getInstance();await p.setString('token',token);if(c.mounted)Navigator.pop(c);}catch(e){setState(()=>error='Login failed. Check details.');}finally{if(mounted)setState(()=>loading=false);}},child:Text(loading?'Please wait':'Login'))]);}
