import 'package:flutter/material.dart';
import 'package:ukk_2025/home_page.dart';
import 'package:ukk_2025/register/sign.dart';
import 'package:ukk_2025/register/updateuser.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class userpage extends StatefulWidget {
  const userpage({super.key});

  @override
  State<userpage> createState() => _userpageState();
}

class _userpageState extends State<userpage> {
  List<Map<String, dynamic>> user = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchuser();
  }

  Future<void> deleteuser(int id) async {
    try {
      await Supabase.instance.client
      .from('user')
      .delete()
      .eq('id', id);
      fetchuser();
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> fetchuser() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.from('user').select();
      setState(() {
        user = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink[300],
          title: const Text("User D'Qasir"),
          centerTitle: true,
          leading: IconButton(
            icon:
                const Icon(Icons.chevron_left), // Ganti ikon panah menjadi '<'
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage())); // Fungsi untuk kembali ke halaman home.dart
            },
          ),
        ),
        body: isLoading
        ? Center(
          child: LoadingAnimationWidget.twoRotatingArc(
          color: Colors.grey, size: 30),
        )
        : user.isEmpty
        ?Center(
          child: const Text('User belum ditambahkan',
          style: TextStyle(fontSize: 18))
        )
        :Column(
          children: [
            //Bagian Header
            Card(
              margin: const EdgeInsets.all(10),
              color: Colors.pink[50],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: const [
                    Expanded(flex: 2, child: Text('Username', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(flex: 2, child: Text('Password', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(flex: 1, child: Text('Role', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(flex: 1, child: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                ),
              ),
            ),

            //User cards
            Expanded(
              child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: user.length,
              itemBuilder: (context, index) {
                final userdata = user[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(flex: 2, child: Text(userdata['username'] ?? '')),
                          Expanded(flex: 2, child: Text(userdata['password'] ?? '')),
                          Expanded(flex: 1, child: Text(userdata['role'] ?? '')),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    final id = userdata['id'] ?? 0;
                                    if (id != 0) {
                                      Navigator.push(
                                      context, MaterialPageRoute(builder: (context) =>updateuser(id: id)));
                                    }
                                  },
                                  icon: const Icon(Icons.edit, color: Colors.grey),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Hapus user'),
                                          content: const Text('Apakah anda yakin menghapus user?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Batal')
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                deleteuser(userdata['id']);
                                              },
                                              child: const Text('Hapus')
                                            ),
                                          ],
                                        );
                                      }
                                    );
                                  },
                                  icon: const Icon(Icons.delete, color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => insertuser()));
          },
          child: Icon(
            Icons.add, color: Colors.brown,
          )
        )
      );
  }
}