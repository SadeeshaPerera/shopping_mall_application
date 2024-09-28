class RentalApplication {
  final String id; // Assuming it's a string, change type if needed
  final String? userName;
  final String? shopType;
  final String? driveLink;

  RentalApplication({
    required this.id,
    this.userName,
    this.shopType,
    this.driveLink
  });

  // Add a factory constructor if you are converting from a map (e.g., from Firebase)
  factory RentalApplication.fromMap(Map<String, dynamic> data, String documentId) {
    return RentalApplication(
      id: documentId, // Use documentId or another unique identifier
      userName: data['userName'],
      shopType: data['shopType'],
      driveLink: data['driveLink'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'shopType': shopType,
      'driveLink': driveLink,
    };
  }
}
