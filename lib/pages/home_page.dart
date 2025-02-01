import 'package:flutter/material.dart';
import 'product_form_page.dart';
import '../controllers/product_controller.dart';
import '../models/product_model.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductController _controller = ProductController();

  late Future<List<ProductModel>> _products;

  @override
  void initState() {
    super.initState();
    _products = _controller.getProducts();
  }

  void _refresh() {
    setState(() {
      _products = _controller.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Talho do Futuro'),
            const Text(
              'Só aqui você encontra a melhor carne!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.yellow,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum produto cadastrado.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final product = snapshot.data![index];
              final formattedDate =
                  DateFormat('dd/MM/yyyy').format(product.expirationDate);

              final daysUntilExpiration =
                  product.expirationDate.difference(DateTime.now()).inDays;
              final textColor =
                  daysUntilExpiration < 15 ? Colors.red : Colors.black;

              return ListTile(
                title: Text(
                    'Carne: ${product.meatType} - Lote: ${product.lotNumber} '),
                subtitle: Text(
                  'Validade: $formattedDate',
                  style: TextStyle(color: textColor),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_forever_outlined,
                      color: Colors.red),
                  onPressed: () async {
                    await _controller.deleteProduct(product.lotNumber);
                    _refresh();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProductFormPage(),
            ),
          );
          _refresh();
        },
        child: Icon(
          Icons.add,
          color: Colors.blue[900],
        ),
      ),
    );
  }
}
