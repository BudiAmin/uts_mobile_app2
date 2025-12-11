import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _npmController = TextEditingController();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _noTelpController = TextEditingController();
  final _alamatController = TextEditingController();
  final _kotaController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final result = await ApiService.registerUser({
        'npm': _npmController.text,
        'nama': _namaController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'no_telp': _noTelpController.text,
        'alamat': _alamatController.text,
        'kota': _kotaController.text,
      });

      setState(() => _isLoading = false);

      if (result['success']) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Registrasi Berhasil'),
            content: Text(
                'Akun Anda sedang menunggu persetujuan admin. Silakan login setelah disetujui.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrasi')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _npmController,
                decoration: InputDecoration(
                    labelText: 'NPM/NRP', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'NPM harus diisi' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                    labelText: 'Nama Lengkap', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Nama harus diisi' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: 'Email', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Email harus diisi' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Password harus diisi' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _noTelpController,
                decoration: InputDecoration(
                    labelText: 'No. Telepon', border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _alamatController,
                maxLines: 3,
                decoration: InputDecoration(
                    labelText: 'Alamat', border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _kotaController,
                decoration: InputDecoration(
                    labelText: 'Kota', border: OutlineInputBorder()),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Daftar', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
