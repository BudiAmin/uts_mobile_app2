import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/produk_model.dart';
import '../../services/api_service.dart';

class ClientHomeScreen extends StatefulWidget {
  final User user;
  
  ClientHomeScreen({required this.user});

  @override
  _ClientHomeScreenState createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  List<Produk> _produkList = [];
  bool _isLoading = true;
  int _cartCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final produk = await ApiService.getProduk();
    final keranjang = await ApiService.getKeranjang(widget.user.id!);
    
    setState(() {
      _produkList = produk.where((p) => p.isActive).toList();
      _cartCount = keranjang.length;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toko Telur Gulung'),
        backgroundColor: Colors.orange,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () => Navigator.pushNamed(
                  context, 
                  '/client/cart',
                  arguments: widget.user,
                ),
              ),
              if (_cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '$_cartCount',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _produkList.length,
                itemBuilder: (context, index) {
                  final produk = _produkList[index];
                  return _buildProdukCard(produk);
                },
              ),
            ),
    );
  }

  Widget _buildProdukCard(Produk produk) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(
                child: Icon(Icons.egg_outlined, size: 80, color: Colors.orange),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produk.namaProduk,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  'Rp ${produk.harga.toStringAsFixed(0)}',
                  style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('Stok: ${produk.stok}', style: TextStyle(fontSize: 12, color: Colors.grey)),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: produk.stok > 0 ? () => _addToCart(produk) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text('Tambah', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addToCart(Produk produk) async {
    final result = await ApiService.addToKeranjang(widget.user.id!, produk.id!, 1);
    
    if (result['success']) {
      setState(() => _cartCount++);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${produk.namaProduk} ditambahkan ke keranjang')),
      );
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.nama),
            accountEmail: Text(widget.user.email),
            decoration: BoxDecoration(color: Colors.orange),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Keranjang'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/client/cart', arguments: widget.user);
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Riwayat Pesanan'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/client/orders', arguments: widget.user);
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Tentang'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/about');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
    );
  }
}