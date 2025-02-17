import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PenjualanPage extends StatefulWidget {
  const PenjualanPage({super.key});

  @override
  State<PenjualanPage> createState() => _PenjualanPageState();
}

class _PenjualanPageState extends State<PenjualanPage> {
  final SingleValueDropDownController nameController =
      SingleValueDropDownController();
  final SingleValueDropDownController produkController =
      SingleValueDropDownController();
  final TextEditingController quantityController = TextEditingController();
  List myproduct = [];
  List user = [];

  takeProduct() async {
    var product = await Supabase.instance.client.from('produk').select();
    setState(() {
      myproduct = product;
    });
  }

  takePelanggan() async {
    var pelanggan = await Supabase.instance.client.from('pelanggan').select();
    setState(() {
      user = pelanggan;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    takeProduct();
    takePelanggan();
  }

  void addPelanggan() {
    final String name = nameController.dropDownValue!.value;
    final int quantity = int.parse(quantityController.text);
    print('Pelanggan Name: $name, Quantity: $quantity');
    // Kembali ke layar sebelumnya setelah menambahkan produk
    Navigator.of(context).pop();
  }

  void addProduct() {
    // Implementasikan logika untuk menambahkan produk, misalnya, kirim data ke Supabase
    final String name = nameController.dropDownValue!.value;
    final int quantity = int.parse(quantityController.text);
    print('Product Name: $name, Quantity: $quantity');
    // Kembali ke layar sebelumnya setelah menambahkan produk
    Navigator.of(context).pop();
  }

  executeSales() async {
    var penjualan = await Supabase.instance.client
        .from('penjualan')
        .insert([
          {
            "Pelangganid": nameController.dropDownValue!.value["Pelangganid"],
            "TotalHarga": ((produkController.dropDownValue!.value["Harga"] *
                int.parse(quantityController.text)) as int)
          }
        ])
        .select()
        .single();
    if (penjualan.isNotEmpty) {
      var detailPenjualan =
          await Supabase.instance.client.from('detailpenjualan').insert([
        {
          "Penjualanid": penjualan["Penjualanid"],
          "Produkid": produkController.dropDownValue!.value["Produkid"],
          'JumlahProduk': int.parse(quantityController.text),
          'Subtotal': ((produkController.dropDownValue!.value["Harga"] *
              int.parse(quantityController.text)) as int)
        }
      ]);
      if (detailPenjualan == null) {
        var product = await Supabase.instance.client.from('produk').update({
          'Stok': produkController.dropDownValue!.value["Stok"] -
              int.parse(quantityController.text)
        }).eq('Produkid', produkController.dropDownValue!.value["Produkid"]);
        if (product == null) {
          Navigator.pop(context, true);
        }
      }
    }
  }
    @override
    Widget build (BuildContext context) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropDownTextField(
                dropDownList: [
                  ...List.generate(user.length, (index) {
                    return DropDownValueModel(
                        name: user[index]['NamaPelanggan'], value: user[index]);
                  })
                ],
                controller: nameController,
                textFieldDecoration: InputDecoration(labelText: "Select User"),
              ),
              DropDownTextField(
                dropDownList: [
                  ...List.generate(myproduct.length, (index) {
                    return DropDownValueModel(
                        name: myproduct[index]['NamaProduk'],
                        value: myproduct[index]);
                  })
                ],
                controller: produkController,
                textFieldDecoration:
                    InputDecoration(labelText: "Select Produk"),
              ),
              TextField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: (){
                  executeSales();
                },
                child: Text('Checkout'),
              ),
            ],
          ),
        ),
      );
    }
  }