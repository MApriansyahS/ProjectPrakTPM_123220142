import 'package:flutter/material.dart';
import '../network/auth_helper.dart';

// Kelas AuthPage adalah tampilan (halaman) untuk proses login dan registrasi pengguna aplikasi.
// Pengguna dapat memasukkan username dan password untuk masuk (login) atau membuat akun baru (register).
//
// Penjelasan bagian utama:
// - Form input: Terdiri dari kolom username dan password, lengkap dengan validasi agar tidak kosong.
// - Tombol Login/Register: Menyesuaikan mode, akan memproses login atau registrasi sesuai pilihan pengguna.
// - Pesan error/sukses: Menampilkan pesan jika login gagal atau registrasi berhasil.
// - Tombol ganti mode: Memungkinkan pengguna berpindah antara mode login dan registrasi.
//
// Proses autentikasi dilakukan secara lokal menggunakan AuthHelper, sehingga data login disimpan di perangkat.

class AuthPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  const AuthPage({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _authHelper = AuthHelper();
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _username = '';
  String _password = '';
  String? _error;

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      bool success = false;
      if (_isLogin) {
        success = await _authHelper.login(_username, _password);
        if (success) {
          widget.onLoginSuccess();
        } else {
          setState(() {
            _error = 'Username atau password salah';
          });
        }
      } else {
        success = await _authHelper.register(_username, _password);
        if (success) {
          setState(() {
            _isLogin = true; 
            _error = 'Registrasi berhasil, silakan login.';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Register'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isLogin ? Icons.login : Icons.person_add,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isLogin ? 'Silakan Login' : 'Registrasi Akun',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      onSaved: (v) => _username = v ?? '',
                      validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      onSaved: (v) => _password = v ?? '',
                      validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: Text(_isLogin ? 'Login' : 'Register'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _isLogin = !_isLogin),
                      child: Text(
                        _isLogin
                            ? 'Belum punya akun? Register'
                            : 'Sudah punya akun? Login',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}