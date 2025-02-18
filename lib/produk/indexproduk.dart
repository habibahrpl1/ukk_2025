import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/produk/insertproduk.dart';
import 'package:ukk_2025/produk/updateproduk.dart';
import 'package:ukk_2025/penjualan/indexpenjualan.dart';

class Produk extends StatefulWidget {
  @override
  _ProdukState createState() => _ProdukState();
}

class _ProdukState extends State<Produk> {
  List<Map<String, dynamic>> produk = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProduk();
  }

  Future<void> fetchProduk() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response =
          await Supabase.instance.client.from('produk').select();
      setState(() {
        produk = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching produk: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteProduk(int id) async {
    try {
      await Supabase.instance.client
          .from('produk')
          .delete()
          .eq('ProdukID', id);
      fetchProduk(); 
    } catch (e) {
      print('Error deleting Produk: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.twoRotatingArc(
                  color: Colors.grey, size: 30),
            )
          : produk.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada produk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Jumlah kolom
                    crossAxisSpacing: 20, // Jarak horizontal antar item
                    mainAxisSpacing: 20, // Jarak vertikal antar item
                    childAspectRatio: 2 / 2, // Rasio lebar : tinggi
                  ),
                  padding: EdgeInsets.all(8),
                  itemCount: produk.length,
                  itemBuilder: (context, index) {
                    final langgan = produk[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              langgan['NamaProduk'] ?? 'Produk tidak tersedia',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              langgan['Harga']?.toString() ?? 'Harga tidak tersedia',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Text(
                              langgan['Stok']?.toString() ?? 'Stok tidak tersedia',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.grey),
                                  onPressed: () {
                                    final ProdukID = langgan['ProdukID'] ?? 0;
                                    if (ProdukID != 0) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProduk(
                                                      ProdukID:
                                                          ProdukID)));
                                    } else {
                                      print('ID produk tidak valid');
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.grey),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Hapus Produk'),
                                          content: const Text(
                                              'Apakah Anda yakin ingin menghapus produk ini?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context); // Tutup dialog
                                                deleteProduk(langgan['ProdukID']);
                                              },
                                              child: const Text('Hapus'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProduk()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.black,
      ),
    );
  }
}