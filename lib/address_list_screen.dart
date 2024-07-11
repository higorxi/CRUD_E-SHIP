import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'address.dart';

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
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteAddress(address.id!),
            ),
          );
        },
      ),
    );
  }
}
