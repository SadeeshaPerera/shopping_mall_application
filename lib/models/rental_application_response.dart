// models/rental_application_response.dart

class RentalApplicationResponse {
  final bool success;
  final String message;
  final dynamic data;

  RentalApplicationResponse({
    required this.success,
    required this.message,
    this.data,
  });

  // Factory constructor to handle success response with data
  factory RentalApplicationResponse.success({required String message, dynamic data}) {
    return RentalApplicationResponse(
      success: true,
      message: message,
      data: data,
    );
  }

  // Factory constructor to handle error response
  factory RentalApplicationResponse.error({required String message}) {
    return RentalApplicationResponse(
      success: false,
      message: message,
    );
  }

  // Method to convert to a map if needed (optional)
  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'data': data,
    };
  }

  @override
  String toString() {
    return 'RentalApplicationResponse(success: $success, message: $message, data: $data)';
  }
}
