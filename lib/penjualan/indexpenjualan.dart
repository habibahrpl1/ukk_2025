import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/penjualan/insertpenjualan.dart';

class Penjualan extends StatefulWidget {
  const Penjualan({super.key});

  @override
  State<Penjualan> createState() => _PenjualanState();
}

class _PenjualanState extends State<Penjualan> {
  List<Map<String, dynamic>> penjualan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPenjualan();
  }

  Future<void> fetchPenjualan() async {
    // setState(() {
    //   isLoading = true;
    // });
    try {
      final response = await Supabase.instance.client
          .from('penjualan')
          .select('*, pelanggan(*)');
      setState(() {
        penjualan = List<Map<String, dynamic>>.from(response).map((item) {
          item['date'] = DateTime.now().toString();
          return item;
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching penjualan: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deletePenjualan(int id) async {
    try {
      await Supabase.instance.client
          .from('penjualan')
          .delete()
          .eq('PenjualanID', id);
      fetchPenjualan();
    } catch (e) {
      print('Error deleting penjualan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: penjualan.length,
        itemBuilder: (context, index) {
          final item = penjualan[index];
          return ListTile(
            title: Text(item['pelanggan']['NamaPelanggan']),
            subtitle: Text('Total harga: ${item['TotalHarga']}\nTanggal: ${item['date']}'),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Hapus Pelanggan'),
                        content: const Text(
                            'Apakah anda yakin ingin menghapus data penjualan ini?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () {
                              deletePenjualan(item['PenjualanID']);
                              Navigator.pop(context);
                              setState(() {
                                penjualan.removeAt(index);
                              });
                            },
                            child: const Text('Hapus'),
                          )
                        ],
                      );
                    });
              },
              // onPressed: () => deletePenjualan(item['Penjualanid']
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var sales = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PenjualanPage()),
          );

          if (sales == true) {
            fetchPenjualan();
          }
        },
        child: Icon(Icons.add),
          backgroundColor: Colors.brown,
          foregroundColor: Colors.black,
      ),
    );
  }
}