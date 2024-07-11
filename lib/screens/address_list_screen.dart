import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../database/address.dart';

class AddressListScreen extends StatefulWidget {
  @override
  _AddressListScreenState createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  List<Address> _addresses = [];

  @override
  void initState() {
    super.initState();
    _refreshAddressList();
  }

  void _refreshAddressList() async {
    final data = await DatabaseHelper().queryAllAddresses();
    setState(() {
      _addresses = data.map((item) => Address(
        id: item['id'],
        street: item['street'],
        city: item['city'],
        state: item['state'],
        zip: item['zip'],
      )).toList();
    });
  }

  void _deleteAddress(int id) async {
    await DatabaseHelper().deleteAddress(id);
    _refreshAddressList();
  }

  void _editAddress(Address address) {
    showDialog(
      context: context,
      builder: (context) {
        final _streetController = TextEditingController(text: address.street);
        final _cityController = TextEditingController(text: address.city);
        final _stateController = TextEditingController(text: address.state);
        final _zipController = TextEditingController(text: address.zip);

        return AlertDialog(
          title: Text('Editar Endereço'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _streetController,
                decoration: InputDecoration(labelText: 'Rua'),
              ),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'Cidade'),
              ),
              TextField(
                controller: _stateController,
                decoration: InputDecoration(labelText: 'Estado'),
              ),
              TextField(
                controller: _zipController,
                decoration: InputDecoration(labelText: 'CEP'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper().updateAddress(Address(
                  id: address.id,
                  street: _streetController.text,
                  city: _cityController.text,
                  state: _stateController.text,
                  zip: _zipController.text,
                ));
                _refreshAddressList();
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Endereços'),
      ),
      body: ListView.builder(
        itemCount: _addresses.length,
        itemBuilder: (context, index) {
          final address = _addresses[index];
          return ListTile(
            title: Text('${address.street}, ${address.city}, ${address.state} - ${address.zip}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editAddress(address),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteAddress(address.id!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
