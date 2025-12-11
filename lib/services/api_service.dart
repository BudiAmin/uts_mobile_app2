import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/produk_model.dart';
import '../models/keranjang_model.dart';
import '../models/pesanan_model.dart';
import '../models/ongkir_model.dart';
import '../models/laporan_model.dart';
import '../models/detail_pesanan_model.dart';

class ApiService {
  // Ganti dengan URL API Anda
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Headers
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // ==================== AUTH SERVICES ====================

  // Register User
  static Future<Map<String, dynamic>> registerUser(
      Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register.php'),
        headers: headers,
        body: json.encode(data),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Login User
  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login_user.php'),
        headers: headers,
        body: json.encode({'email': email, 'password': password}),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Login Admin
  static Future<Map<String, dynamic>> loginAdmin(
      String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login_admin.php'),
        headers: headers,
        body: json.encode({'username': username, 'password': password}),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // ==================== USER SERVICES ====================

  // Get pending users (for admin approval)
  static Future<List<User>> getPendingUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/get_pending.php'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return (data['data'] as List)
              .map((user) => User.fromJson(user))
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Approve user
  static Future<Map<String, dynamic>> approveUser(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/approve.php'),
        headers: headers,
        body: json.encode({'user_id': userId}),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // ==================== PRODUK SERVICES ====================

  // Get all products
  static Future<List<Produk>> getProduk() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/produk/get_all.php'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return (data['data'] as List)
              .map((produk) => Produk.fromJson(produk))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getProduk: $e');
      return [];
    }
  }

  // Create product (admin)
  static Future<Map<String, dynamic>> createProduk(Produk produk) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/produk/create.php'),
        headers: headers,
        body: json.encode(produk.toJson()),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Update product (admin)
  static Future<Map<String, dynamic>> updateProduk(Produk produk) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/produk/update.php'),
        headers: headers,
        body: json.encode(produk.toJson()),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Delete product (admin)
  static Future<Map<String, dynamic>> deleteProduk(int produkId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/produk/delete.php?id=$produkId'),
        headers: headers,
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // ==================== KERANJANG SERVICES ====================

  // Get cart by user
  static Future<List<Keranjang>> getKeranjang(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/keranjang/get_by_user.php?user_id=$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return (data['data'] as List)
              .map((item) => Keranjang.fromJson(item))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getKeranjang: $e');
      return [];
    }
  }

  // Add to cart
  static Future<Map<String, dynamic>> addToKeranjang(
      int userId, int produkId, int jumlah) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/keranjang/add.php'),
        headers: headers,
        body: json.encode({
          'user_id': userId,
          'produk_id': produkId,
          'jumlah': jumlah,
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Update cart
  static Future<Map<String, dynamic>> updateKeranjang(
      int keranjangId, int jumlah) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/keranjang/update.php'),
        headers: headers,
        body: json.encode({
          'id': keranjangId,
          'jumlah': jumlah,
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Remove from cart
  static Future<Map<String, dynamic>> removeFromKeranjang(
      int keranjangId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/keranjang/delete.php?id=$keranjangId'),
        headers: headers,
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Clear cart
  static Future<Map<String, dynamic>> clearKeranjang(int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/keranjang/clear.php?user_id=$userId'),
        headers: headers,
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // ==================== PESANAN SERVICES ====================

  // Create order
  static Future<Map<String, dynamic>> createPesanan(
      Pesanan pesanan, List<DetailPesanan> details) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pesanan/create.php'),
        headers: headers,
        body: json.encode({
          'pesanan': pesanan.toJson(),
          'details': details.map((d) => d.toJson()).toList(),
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Get orders by user
  static Future<List<Pesanan>> getPesananByUser(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pesanan/get_by_user.php?user_id=$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return (data['data'] as List)
              .map((pesanan) => Pesanan.fromJson(pesanan))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getPesananByUser: $e');
      return [];
    }
  }

  // Get all orders (admin)
  static Future<List<Pesanan>> getAllPesanan() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pesanan/get_all.php'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return (data['data'] as List)
              .map((pesanan) => Pesanan.fromJson(pesanan))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getAllPesanan: $e');
      return [];
    }
  }

  // Update order status (admin)
  static Future<Map<String, dynamic>> updateStatusPesanan(
      int pesananId, String status) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/pesanan/update_status.php'),
        headers: headers,
        body: json.encode({
          'pesanan_id': pesananId,
          'status': status,
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // ==================== ONGKIR SERVICE (RajaOngkir API) ====================

  static Future<List<OngkirResult>> getOngkir(
      String origin, String destination, int weight) async {
    try {
      // Ganti dengan API KEY RajaOngkir Anda
      const String apiKey = 'YOUR_RAJAONGKIR_API_KEY';

      final response = await http.post(
        Uri.parse('https://api.rajaongkir.com/starter/cost'),
        headers: {
          'key': apiKey,
          'content-type': 'application/x-www-form-urlencoded',
        },
        body: {
          'origin': origin, // ID kota asal (misal: 23 untuk Bandung)
          'destination': destination, // ID kota tujuan
          'weight': weight.toString(), // dalam gram
          'courier': 'jne', // bisa jne, pos, tiki
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['rajaongkir']['status']['code'] == 200) {
          final results = data['rajaongkir']['results'][0]['costs'] as List;
          return results.map((cost) => OngkirResult.fromJson(cost)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getOngkir: $e');
      return [];
    }
  }

  // ==================== LAPORAN SERVICES (ADMIN) ====================

  static Future<List<LaporanPenjualan>> getLaporanPenjualan() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/laporan/penjualan.php'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return (data['data'] as List)
              .map((laporan) => LaporanPenjualan.fromJson(laporan))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getLaporanPenjualan: $e');
      return [];
    }
  }

  // Get dashboard statistics
  static Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/laporan/dashboard_stats.php'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'success': false};
    } catch (e) {
      print('Error getDashboardStats: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
