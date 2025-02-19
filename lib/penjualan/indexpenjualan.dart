import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/penjualan/insertpenjualan.dart';
import 'package:intl/intl.dart';

class Indexpenjualan extends StatefulWidget {
  const Indexpenjualan({super.key});

  @override
  State<Indexpenjualan> createState() => _IndexpenjualanState();
}

class _IndexpenjualanState extends State<Indexpenjualan> {
  List<Map<String, dynamic>> penjualan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPenjualan();
  }

  Future<void> fetchPenjualan() async {
    try {
      final response = await Supabase.instance.client
          .from('penjualan')
          .select('*, pelanggan(*)');

      setState(() {
        penjualan = List<Map<String, dynamic>>.from(response).map((item) {
          item['date'] = DateFormat('dd-MM-yyyy').format(DateTime.parse(item['TanggalPenjualan']));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Loading indicator
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: penjualan.length,
              itemBuilder: (context, index) {
                final item = penjualan[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.2),
                          blurRadius: 8.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text(
                        item['pelanggan']['NamaPelanggan'],
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        'Total Harga: ${item['TotalHarga']}\nTanggal Penjualan: ${item['date']}',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Insertpenjualan()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.black,
      ),
    );
  }
}
