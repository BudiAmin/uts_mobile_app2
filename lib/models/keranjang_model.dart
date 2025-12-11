import 'produk_model.dart';

class Keranjang {
  final int? id;
  final int userId;
  final int produkId;
  final int jumlah;
  final Produk? produk;

  Keranjang({
    this.id,
    required this.userId,
    required this.produkId,
    required this.jumlah,
    this.produk,
  });

  factory Keranjang.fromJson(Map<String, dynamic> json) {
    return Keranjang(
      id: json['id'],
      userId: json['user_id'],
      produkId: json['produk_id'],
      jumlah: json['jumlah'],
      produk: json['produk'] != null ? Produk.fromJson(json['produk']) : null,
    );
  }

  double get subtotal => (produk?.harga ?? 0) * jumlah;
}