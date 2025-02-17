import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/produk/insertproduk.dart';
import 'package:ukk_2025/pelanggan/insertpelanggan.dart';
import 'package:ukk_2025/pelanggan/updatepelanggan.dart';

class Pelanggan extends StatefulWidget {
  const Pelanggan({super.key});
  
  @override
  _PelangganState createState() => _PelangganState();
}

class _PelangganState extends State<Pelanggan> {
  List<Map<String, dynamic>> pelanggan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
  }

  Future<void> fetchPelanggan() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response =
          await Supabase.instance.client.from('pelanggan').select();
      setState(() {
        pelanggan = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching pelanggan: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deletePelanggan(int id) async {
    try {
      await Supabase.instance.client
          .from('pelanggan')
          .delete()
          .eq('PelangganID', id);
      fetchPelanggan(); // Refresh data setelah hapus
    } catch (e) {
      print('Error deleting pelanggan: $e');
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
          : pelanggan.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada pelanggan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Jumlah kolom
                    crossAxisSpacing: 12, // Jarak horizontal antar item
                    mainAxisSpacing: 12, // Jarak vertikal antar item
                    childAspectRatio: 4 / 4, // Rasio lebar : tinggi
                  ),
                  padding: EdgeInsets.all(8),
                  itemCount: pelanggan.length,
                  itemBuilder: (context, index) {
                    final langgan = pelanggan[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              langgan['NamaPelanggan'] ?? 'Pelanggan tidak tersedia',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              langgan['Alamat'] ?? 'Alamat tidak tersedia',
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
                              langgan['NomorTelepon'] ?? 'Tidak tersedia',
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
                                    final PelangganID = langgan['PelangganID'] ?? 0;
                                    if (PelangganID != 0) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditPelanggan(
                                                      PelangganID:
                                                          PelangganID)));
                                    } else {
                                      print('ID pelanggan tidak valid');
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
                                          title: const Text('Hapus Pelanggan'),
                                          content: const Text(
                                              'Apakah Anda yakin ingin menghapus pelanggan ini?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context); // Tutup dialog
                                                deletePelanggan(langgan['PelangganID']);
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
            MaterialPageRoute(builder: (context) => AddPelanggan()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.black,
      ),
    );
  }
}