import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/home_page.dart';

class EditProduk extends StatefulWidget {
  final int ProdukID;

  const EditProduk({super.key, required this.ProdukID});

  @override
  State<EditProduk> createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  final _nmproduk = TextEditingController();
  final _harga = TextEditingController();
  final _stok = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadProdukData();
  }

  // Memuat data produk berdasarkan ProdukID
  Future<void> _loadProdukData() async {
    final data = await Supabase.instance.client
        .from('produk')
        .select()
        .eq('ProdukID', widget.ProdukID)
        .single();

    setState(() {
      _nmproduk.text = data['NamaProduk'] ?? '';
      _harga.text = data['Harga']?.toString() ?? '';  
      _stok.text = data['Stok']?.toString() ?? '';    
    });
  }

  // Update produk setelah perubahan
  Future<void> updateProduk() async {
    if (_formKey.currentState!.validate()) {
      // Update produk di database
      await Supabase.instance.client.from('produk').update({
        'NamaProduk': _nmproduk.text,
        'Harga': double.tryParse(_harga.text),  
        'Stok': int.tryParse(_stok.text),      
      }).eq('ProdukID', widget.ProdukID);

      // Setelah berhasil update, kembali ke halaman utama produk
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), 
        (route) => false, 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nmproduk,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama produk tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _harga,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan harga yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stok,
                decoration: const InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Masukkan jumlah stok yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: updateProduk,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}