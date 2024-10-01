class RentalApplication {
  final String id; // Assuming it's a string, change type if needed
  final String? userId;
  final String? userName;
  final String? shopType;
  final String? driveLink;
  final String? status;

  RentalApplication({
    required this.id,
    this.userId,
    this.userName,
    this.shopType,
    this.driveLink,
    this.status,
  });

  // Add a factory constructor if you are converting from a map (e.g., from Firebase)
  factory RentalApplication.fromMap(Map<String, dynamic> data, String documentId) {
    return RentalApplication(
      id: documentId, // Use documentId or another unique identifier
      userId: data['userId'],
      userName: data['userName'],
      shopType: data['shopType'],
      driveLink: data['driveLink'],
      status: data['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'shopType': shopType,
      'driveLink': driveLink,
      'status': status,
    };
  }
}
