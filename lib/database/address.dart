class Address {
  final int? id;
  final String street;
  final String city;
  final String state;
  final String zip;

  Address({this.id, required this.street, required this.city, required this.state, required this.zip});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
    };
  }
}
