import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../models/product_model.dart';
import '../controllers/product_controller.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _lotControllerEC = TextEditingController();
  final _meatTypeControllerEC = TextEditingController();
  final _supplierControllerEC = TextEditingController();
  final _quantityControllerEC = TextEditingController();
  final _controller = ProductController();

  DateTime? _expirationDate;
  DateTime? _receivedDate;

  Future<void> _selectDate(BuildContext context, bool isExpiration) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2200),
    );

    if (picked != null) {
      setState(() {
        if (isExpiration) {
          _expirationDate = picked;
        } else {
          _receivedDate = picked;
        }
      });
    }
  }

  void _saveProduct() async {
    if (_lotControllerEC.text.isEmpty ||
        _meatTypeControllerEC.text.isEmpty ||
        _supplierControllerEC.text.isEmpty ||
        _quantityControllerEC.text.isEmpty ||
        _expirationDate == null ||
        _receivedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preencha todos os campos.')));
      return;
    }

    final product = ProductModel(
      lotNumber: _lotControllerEC.text,
      meatType: _meatTypeControllerEC.text,
      expirationDate: _expirationDate!,
      receivedDate: _receivedDate!,
      supplier: _supplierControllerEC.text,
      quantity: double.parse(_quantityControllerEC.text),
    );

    await _controller.addProduct(product);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    _lotControllerEC.dispose();
    _meatTypeControllerEC.dispose();
    _supplierControllerEC.dispose();
    _quantityControllerEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Produto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _lotControllerEC,
              label: 'Numero do Lote',
              keyboardType: TextInputType.text,
            ),
            CustomTextField(
              controller: _meatTypeControllerEC,
              label: 'Tipo de Carne',
              keyboardType: TextInputType.text,
            ),
            CustomTextField(
              controller: _supplierControllerEC,
              label: 'Fornecedor',
              keyboardType: TextInputType.text,
            ),
            CustomTextField(
              controller: _quantityControllerEC,
              label: 'Quantidade (kg)',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            Divider(),
            ListTile(
              title: const Text('Data de Recebimento'),
              subtitle: Text(_receivedDate == null
                  ? 'Selecione a Data'
                  : _receivedDate!.toLocal().toString().split(' ')[0]),
              onTap: () => _selectDate(context, false),
            ),
            Divider(),
            ListTile(
              title: const Text('Data de Validade'),
              subtitle: Text(_expirationDate == null
                  ? 'Selecione a Data'
                  : _expirationDate!.toLocal().toString().split(' ')[0]),
              onTap: () => _selectDate(context, true),
            ),
            Divider(),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _saveProduct,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
