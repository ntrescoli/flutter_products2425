import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../models/product.dart';
import '../provider/products_service.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({super.key});

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  final ProductsService productsService = ProductsService();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _availableController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _availableController.dispose();
    _imageUrlController.dispose();
    _ratingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    File? image;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Nuevo Producto',
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.description_outlined),
                  labelText: 'Descripción',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduzca una descripción';
                  }
                  if (value.length < 5) {
                    return 'La descripción debe tener al menos 5 caracteres';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.attach_money_outlined),
                  labelText: 'Precio',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduzca un precio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Introduzca un valor numérico';
                  }
                  if (double.tryParse(value)! <= 0) {
                    return 'Introduzca un valor mayor que 0';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _availableController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  labelText: 'Disponible',
                ),
                readOnly: true,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _availableController.text =
                          DateFormat('yyyy-MM-dd').format(picked);
                    });
                  }
                },
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.image_outlined),
                  labelText: 'Image URL',
                ),
                keyboardType: TextInputType.url,
                readOnly: true,
                onTap: () async {
                  XFile? pickedImage = await pickImage();
                  if (pickedImage != null) {
                    image = File(pickedImage.path);
                    setState(() {
                      _imageUrlController.text = image!.path;
                    });
                  }
                },
              ),
              TextFormField(
                controller: _ratingController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.star_outline),
                  labelText: 'Rating',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final regex = RegExp('[0-5]');
                  if (value != null &&
                      value.isNotEmpty &&
                      !regex.hasMatch(value)) {
                    return 'El valor debe estar entre 0 y 5';
                  }
                  return null;
                },
              ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Producto añadido')),
                      );
                      productsService
                          .addProduct(Product(
                              description: _descriptionController.text,
                              price: double.tryParse(_priceController.text)!,
                              available: _availableController.text.isNotEmpty
                                  ? DateTime.parse(_availableController.text)
                                  : DateTime.now(),
                              imageUrl: _imageUrlController.text,
                              rating: _ratingController.text.isNotEmpty
                                  ? int.parse(_ratingController.text)
                                  : 0))
                          .then((value) => {
                                if (value != null)
                                  {Navigator.pop(context)}
                                else
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Revise los datos')),
                                    )
                                  }
                              });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Revise los datos')),
                      );
                    }
                  },
                  child: const Text('Crear'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future pickImage() async {
    final XFile? image;
    try {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
      return image;
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }
}
