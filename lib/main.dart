import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';

String supabeseUrl = 'https://wfrpnwnzpcgtvkhyhnox.supabase.co';
String supabeseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndmcnBud256cGNndHZraHlobm94Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MDg4ODEsImV4cCI6MjA1NDk4NDg4MX0.xzf_Zmzs45M3CJ7YCTr2-CcaTa0dPQ4QtwfPudiqxWQ';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://wfrpnwnzpcgtvkhyhnox.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndmcnBud256cGNndHZraHlobm94Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MDg4ODEsImV4cCI6MjA1NDk4NDg4MX0.xzf_Zmzs45M3CJ7YCTr2-CcaTa0dPQ4QtwfPudiqxWQ',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  bool _isRememberMeChecked = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Fungsi untuk menangani tombol login
  void _handleLogin() async {
    String email = emailController.text;
    String password = passwordController.text;

    // Validasi input
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email dan Password tidak boleh kosong!'),
          backgroundColor: Colors.grey,
        ),
      );
      return;
    }

    // Jika login berhasil
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login Berhasil!'),
        backgroundColor: Colors.grey,
      ),
    );

    // Navigasi ke halaman Home
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(height: 40),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/boba.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(143, 148, 251, .2),
                        blurRadius: 30.0,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[100]!),
                          ),
                        ),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                            border: InputBorder.none,
                            hintText: "Username",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: Icon(Icons.person, color: Colors.grey[400]),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[100]!),
                          ),
                        ),
                        child: TextField(
                          controller: passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                            border: InputBorder.none,
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: Icon(Icons.lock, color: Colors.grey[400]),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey[400],
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.brown[300]),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isRememberMeChecked = !_isRememberMeChecked;
                            });
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _isRememberMeChecked
                                    ? Colors.brown
                                    : Colors.grey[400]!,
                                width: 2,
                              ),
                            ),
                            child: _isRememberMeChecked
                                ? Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.brown[300],
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Remember Me",
                          style: TextStyle(
                            color: Colors.brown[300],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: _handleLogin,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Colors.brown,
                          Colors.black,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}