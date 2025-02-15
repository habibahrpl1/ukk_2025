import 'package:flutter/material.dart';
import 'package:ukk_2025/register/indexuser.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/home_page.dart';

class insertuser extends StatefulWidget {
  const insertuser({super.key});

  @override
  State<insertuser> createState() => insertuserState();
}

class insertuserState extends State<insertuser> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _role = TextEditingController();

  //method utk insert data user ke supabases
  Future<void> _adduser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final username = _username.text;
    final password = _password.text;
    final role = _role.text;

    //validasi input
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua wajib diisi')),
      );
      return;
    }

    final response = await Supabase.instance.client.from('user').insert([
      {
        'username': username,
        'password': password,
        'role': 'petugas',
      }
    ]);

    if (response != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.error!.message}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User berhasil ditambahkan')),
      );
    }

    //jika form sudah selesai input maka kosongkan form dg cara perintah ini
    _username.clear();
    _password.clear();

    //navigasi jika kembali ke halaman sebelumnya dan refresh list
    Navigator.pop(context, true);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => userpage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _username,
                  decoration: InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan Username dulu';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _password,
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan Password dulu';
                    }
                    return null;
                  },
                ),
                const SizedBox( height: 16),
                TextFormField(
                  controller: _role,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _adduser();
                    }
                  },
                  child: Text('Tambah User'),
                )
              ],
            )),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: Colors.pink[300],
  //       title: const Text("D'Qasir"),
  //       centerTitle: true,
  //       leading: IconButton(
  //         icon: const Icon(Icons.chevron_left), // Ganti ikon panah menjadi '<'
  //         onPressed: () {
  //           Navigator.pop(
  //               context, true); // Fungsi untuk kembali ke halaman sebelumnya
  //         },
  //       ),
  //     ),
  //     body: Container(
  //       child: Column(
  //         children: [
  //           SizedBox(height: 10),
  //           TextField(
  //             decoration: InputDecoration(
  //               prefixIcon: Icon(Icons.person),
  //               hintText: 'Masukkan Nama Anda',
  //               filled: true,
  //               fillColor: Colors.white,
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //                 borderSide: BorderSide.none,
  //               ),
  //             ),
  //           ),
  //           SizedBox(height: 10),
  //           TextField(
  //             decoration: InputDecoration(
  //               prefixIcon: Icon(Icons.email),
  //               hintText: 'Email',
  //               filled: true,
  //               fillColor: Colors.white,
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //                 borderSide: BorderSide.none,
  //               ),
  //             ),
  //           ),
  //           SizedBox(height: 10),
  //           TextField(
  //             decoration: InputDecoration(
  //               prefixIcon: Icon(Icons.phone),
  //               hintText: 'Nomor Whatshapp',
  //               filled: true,
  //               fillColor: Colors.white,
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //                 borderSide: BorderSide.none,
  //               ),
  //             ),
  //           ),
  //           SizedBox(height: 10),
  //           TextField(
  //             obscureText: true, //agar pasword titik titik
  //             decoration: InputDecoration(
  //               prefixIcon: Icon(Icons.lock),
  //               hintText: 'Masukkan kata sandi ',
  //               filled: true,
  //               fillColor: Colors.white,
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //                 borderSide: BorderSide.none,
  //               ),
  //             ),
  //           ),
  //           SizedBox(height: 10),
  //           SizedBox(height: 10),
  //           ElevatedButton(
  //               onPressed: () {
  //                 // Arahkan ke halaman Home setelah klik Register
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) =>
  //                         homepage(), // Arahkan ke halaman home.dart
  //                   ),
  //                 );
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: Colors.white,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 minimumSize: Size(double.infinity, 50),
  //               ),
  //               child: Text('Register',
  //                   style: TextStyle(
  //                     fontSize: 15,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.black,
  //                   )))
  //         ],
  //       ),
  //     ),
  //   );
  // }
}