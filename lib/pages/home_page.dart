import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/auth.dart';

import '../pages/add_product_page.dart';
import '../widgets/product_item.dart';
import 'image_picker.dart';

class HomePage extends StatefulWidget {
  static const route = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isInit = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (isInit) {
      isLoading = true;
      Provider.of<Products>(context, listen: false).inisialData().then((value) {
        setState(() {
          isLoading = false;
        });
      }).catchError(
        (err) {
          print(err);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Error Occured"),
                content: Text(err.toString()),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.pop(context);
                    },
                    child: Text("Okay"),
                  ),
                ],
              );
            },
          );
        },
      );

      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Products>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ImagePicker()),
          );
        },
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () => Provider.of<Auth>(context, listen: false).logout(),
        ),
        title: Text("All Products"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, AddProductPage.route),
          ),
        ],
      ),
      body: (isLoading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (prov.allProduct.length == 0)
              ? Center(
                  child: Text(
                    "No Data",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: prov.allProduct.length,
                  itemBuilder: (context, i) => ProductItem(
                    prov.allProduct[i].id,
                    prov.allProduct[i].title,
                    prov.allProduct[i].price,
                    prov.allProduct[i].updatedAt,
                  ),
                ),
    );
  }
}