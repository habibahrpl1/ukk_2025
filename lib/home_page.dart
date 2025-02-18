import 'package:flutter/material.dart';
import 'package:ukk_2025/penjualan/indexpenjualan.dart';
import 'package:ukk_2025/login.dart';
import 'package:ukk_2025/main.dart';
import 'package:ukk_2025/pelanggan/indexpelanggan.dart';
import 'package:ukk_2025/pelanggan/insertpelanggan.dart';
import 'package:ukk_2025/produk/indexproduk.dart';
import 'package:ukk_2025/penjualan/indexpenjualan.dart';
import 'package:ukk_2025/penjualan/insertpenjualan.dart';
import 'package:ukk_2025/register/indexuser.dart';
import 'package:ukk_2025/register/updateuser.dart';
import 'package:ukk_2025/penjualan/detailpenjualan.dart';
import 'package:ukk_2025/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; 

  final List<Widget> _pages = [
    Produk(),   
    Pelanggan(),
    PenjualanTab(),
    DetailPenjualanTab(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KoalaTea'),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.brown,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Beranda'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Registrasi'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.arrow_back_rounded),
              title: Text('Logout'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Splash()));
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Pelanggan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Penjualan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Detail Penjualan',
          ),
        ],
      ),
    );
  }
}