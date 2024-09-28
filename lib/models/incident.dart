class Incident {
  String? id;
  String? name;
  String? description;
  DateTime? date;
  String? location;
  String? contactNumber;
  String? status;

  Incident({
    this.id,
    this.name,
    this.description,
    this.date,
    this.location,
    this.contactNumber,
    this.status,
  });

  // Method to convert Incident object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': date?.toIso8601String(),
      'location': location,
      'contactNumber': contactNumber,
      'status': status,
    };
  }

  // Method to create an Incident object from a map
  factory Incident.fromMap(Map<String, dynamic> map) {
    return Incident(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      location: map['location'],
      contactNumber: map['contactNumber'],
      status: map['status'],
    );
  }
}
