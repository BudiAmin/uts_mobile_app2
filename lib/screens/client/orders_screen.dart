// lib/screens/client/orders_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile_uts/models/user_model.dart'; // Pastikan import User model

class OrdersScreen extends StatefulWidget {
  final User user; // Menerima objek User

  const OrdersScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // Contoh data pesanan (akan diganti dengan data dinamis dari API di masa depan)
  final List<Map<String, dynamic>> _orders = [
    {
      'id': 'ORD-20240101-001',
      'date': '2024-01-01',
      'total': 7500,
      'status': 'Selesai',
      'items': [
        {'name': 'Telur Gulung Original', 'quantity': 2, 'price': 2500},
        {'name': 'Telur Gulung Keju', 'quantity': 1, 'price': 2500},
      ]
    },
    {
      'id': 'ORD-20240105-002',
      'date': '2024-01-05',
      'total': 6000,
      'status': 'Diproses',
      'items': [
        {'name': 'Telur Gulung Pedas', 'quantity': 2, 'price': 3000},
      ]
    },
    {
      'id': 'ORD-20240110-003',
      'date': '2024-01-10',
      'total': 10000,
      'status': 'Dibatalkan',
      'items': [
        {'name': 'Telur Gulung Original', 'quantity': 4, 'price': 2500},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Pesanan'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'Anda belum memiliki pesanan.',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                Color statusColor;
                switch (order['status']) {
                  case 'Selesai':
                    statusColor = Colors.green;
                    break;
                  case 'Diproses':
                    statusColor = Colors.blue;
                    break;
                  case 'Dibatalkan':
                    statusColor = Colors.red;
                    break;
                  default:
                    statusColor = Colors.grey;
                }

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    leading: Icon(Icons.shopping_bag_outlined, color: Theme.of(context).primaryColor),
                    title: Text(
                      'Pesanan ID: ${order['id']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Tanggal: ${order['date']}'),
                    trailing: Chip(
                      label: Text(
                        order['status'],
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: statusColor,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detail Pesanan:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            ...order['items'].map<Widget>((item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${item['name']} x${item['quantity']}'),
                                      Text('Rp ${item['price'] * item['quantity']}'),
                                    ],
                                  ),
                                )),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Pembayaran:',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Rp ${order['total']}',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}