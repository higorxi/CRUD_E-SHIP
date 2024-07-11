import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../database/address.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
        final streetController = TextEditingController(text: address.street);
        final cityController = TextEditingController(text: address.city);
        final stateController = TextEditingController(text: address.state);
        final zipController = TextEditingController(text: address.zip);

        return AlertDialog(
          title: const Text('Editar Endereço'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: streetController,
                decoration: const InputDecoration(labelText: 'Rua'),
              ),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'Cidade'),
              ),
              TextField(
                controller: stateController,
                decoration: const InputDecoration(labelText: 'Estado'),
              ),
              TextField(
                controller: zipController,
                decoration: const InputDecoration(labelText: 'CEP'),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 9.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 9.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffe4e2dd),foregroundColor: Colors.black,
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 9.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Colors.black,
                           foregroundColor:const Color(0xffe4e2dd),
                        ),
                        onPressed: () async {
                          await DatabaseHelper().updateAddress(Address(
                            id: address.id,
                            street: streetController.text,
                            city: cityController.text,
                            state: stateController.text,
                            zip: zipController.text,
                          ));
                          _refreshAddressList();
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        },
                        child: const Text('Salvar'),
                      ),
                    ),
                  ),
                ],
              ),
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
        title: const Text('Endereços'),
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
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editAddress(address),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
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
