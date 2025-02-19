import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/detailpenjualan/cetakpdf.dart';

class IndexDetail extends StatefulWidget {
  const IndexDetail({super.key});

  @override
  State<IndexDetail> createState() => _IndexDetailState();
}

class _IndexDetailState extends State<IndexDetail> {
  List<Map<String, dynamic>> detailPenjualan = [];

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    try {
      final data = await Supabase.instance.client
          .from('detailpenjualan')
          .select('*, penjualan(*, pelanggan(*)), produk(*)');
      setState(() {
        detailPenjualan = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void showPrintDialog(Map<String, dynamic> detail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Riwayat Transaksi'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Nama Pelanggan: ${detail['penjualan']['pelanggan']['NamaPelanggan'] ?? 'Tidak tersedia'}'),
                const SizedBox(height: 8),
                Text('Nama Produk: ${detail['produk']['NamaProduk'] ?? 'Tidak tersedia'}'),
                const SizedBox(height: 8),
                Text('Jumlah Produk: ${detail['JumlahProduk']?.toString() ?? 'Tidak tersedia'}'),
                const SizedBox(height: 8),
                Text('Subtotal: ${detail['Subtotal']?.toString() ?? 'Tidak tersedia'}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cetak Struk'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => cetakpdf(
                      cetak: detail,
                      PenjualanID: detail['penjualan']['PenjualanID'].toString(),
                    ),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: detailPenjualan.length,
          itemBuilder: (context, index) {
            final detail = detailPenjualan[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail['penjualan']['pelanggan']['NamaPelanggan']?.toString() ?? 'Pelanggan tidak tersedia',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        detail['produk']['NamaProduk'] ?? 'Produk tidak tersedia',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Jumlah Produk: ${detail['JumlahProduk']?.toString() ?? 'Tidak tersedia'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Subtotal: ${detail['Subtotal']?.toString() ?? 'Tidak tersedia'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () => showPrintDialog(detail),
                            child: const Icon(
                              Icons.print,
                              color: Colors.brown,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}