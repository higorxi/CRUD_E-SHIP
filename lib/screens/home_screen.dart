import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../database/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cepController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  String? _zip, _imageUrl;

  void _searchCep(String cep) async {
    final response =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _streetController.text = data['logradouro'] ?? '';
        _cityController.text = data['localidade'] ?? '';
        _stateController.text = data['uf'] ?? '';
        _zip = data['cep'];
      });
      _fetchCityImage(_cityController.text);
    }
  }

  void _fetchCityImage(String city) async {
    final response = await http.get(Uri.parse(
        'https://api.unsplash.com/photos/random?query=$city&client_id=NMNW9TG6hdHmCuKRWGb6yypN9jfPqRfvhZp-BNHzhbc'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _imageUrl = data['urls']['regular'];
      });
    }
  }

  void _addAddress() async {
    if (_formKey.currentState!.validate()) {
      await DatabaseHelper().insertAddress({
        'street': _streetController.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'zip': _zip,
      });
      _cepController.clear();
      _streetController.clear();
      _cityController.clear();
      _stateController.clear();
      setState(() {
        _zip = null;
        _imageUrl = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _cepController,
                    decoration: const InputDecoration(labelText: 'CEP'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o CEP';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      onPressed: () => _searchCep(_cepController.text),
                      color: Colors.black,
                      child: const Text('Buscar CEP'),
                    ),
                  ),
                  if (_zip != null) ...[
                    TextFormField(
                      controller: _streetController,
                      decoration: const InputDecoration(labelText: 'Rua'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a Rua';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(labelText: 'Cidade'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a Cidade';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _stateController,
                      decoration: const InputDecoration(labelText: 'Estado'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o Estado';
                        }
                        return null;
                      },
                    ),
                    Text('CEP: $_zip'),
                    if (_imageUrl != null) Image.network(_imageUrl!),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _addAddress,
                      child: const Text('Adicionar Endereço'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
