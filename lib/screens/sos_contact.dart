class SOSContact {
  final int? id;
  final String name;
  final String phoneNumber;

  SOSContact({this.id, required this.name, required this.phoneNumber});

  // Convert an SOSContact into a Map. The keys must correspond to the column names.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }

  // Convert a Map into an SOSContact
  static SOSContact fromMap(Map<String, dynamic> map) {
    return SOSContact(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
    );
  }
}
