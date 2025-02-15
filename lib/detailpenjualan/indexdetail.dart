import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class detailpage extends StatefulWidget {
  const detailpage({super.key});

  @override
  State<detailpage> createState() => _detailpageState();
}

class _detailpageState extends State<detailpage> {
  List<Map<String, dynamic>> detailpenjualan = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchdetail();
  }

  Future<void> fetchdetail() async {
    try {
      final data = await Supabase.instance.client
          .from('detailpenjualan')
          .select('*, penjualan(*,pelanggan(*)), produk(*)');
      setState(() {
        detailpenjualan = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        
        padding: EdgeInsets.all(8),
        itemCount: detailpenjualan.length,
        itemBuilder: (context, index) {
          final detail = detailpenjualan[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail['penjualan']['pelanggan']['NamaPelanggan']?.toString() ??
                        'Pelanggan tidak tersedia',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    detail['produk']['NamaProduk'] ?? 'produk Tidak tersedia',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    detail['JumlahProduk']?.toString() ?? 'Tidak tersedia',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 8),
                  Text(
                    detail['Subtotal']?.toString() ?? 'Tidak tersedia',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}