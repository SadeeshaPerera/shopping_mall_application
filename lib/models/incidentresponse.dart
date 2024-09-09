import 'incident.dart'; // Ensure you import the Incident model

class IncidentResponse {
  int? code;
  String? message;
  List<Incident>? incidents;

  IncidentResponse({this.code, this.message, this.incidents});

  // Method to convert IncidentResponse object to a map
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
      'incidents': incidents?.map((incident) => incident.toMap()).toList(),
    };
  }

  // Method to create an IncidentResponse object from a map
  factory IncidentResponse.fromMap(Map<String, dynamic> map) {
    return IncidentResponse(
      code: map['code'],
      message: map['message'],
      incidents: map['incidents'] != null
          ? List<Incident>.from(map['incidents']
              .map((incidentMap) => Incident.fromMap(incidentMap)))
          : null,
    );
  }
}
