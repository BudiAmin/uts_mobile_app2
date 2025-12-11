class User {
  final int? id;
  final String npm;
  final String nama;
  final String email;
  final String? noTelp;
  final String? alamat;
  final String? kota;
  final String? kodePos;
  final bool isApproved;
  final DateTime? createdAt;

  User({
    this.id,
    required this.npm,
    required this.nama,
    required this.email,
    this.noTelp,
    this.alamat,
    this.kota,
    this.kodePos,
    this.isApproved = false,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      npm: json['npm'],
      nama: json['nama'],
      email: json['email'],
      noTelp: json['no_telp'],
      alamat: json['alamat'],
      kota: json['kota'],
      kodePos: json['kode_pos'],
      isApproved: json['is_approved'] == 1,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'npm': npm,
      'nama': nama,
      'email': email,
      'no_telp': noTelp,
      'alamat': alamat,
      'kota': kota,
      'kode_pos': kodePos,
      'is_approved': isApproved ? 1 : 0,
    };
  }
}