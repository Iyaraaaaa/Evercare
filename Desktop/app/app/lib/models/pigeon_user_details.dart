class PigeonUserDetails {
  final String id;
  final String name;
  final String email;

  PigeonUserDetails({
    required this.id,
    required this.name,
    required this.email,
  });

  // Factory constructor to create an instance from JSON
  factory PigeonUserDetails.fromJson(Map<String, dynamic> json) {
    return PigeonUserDetails(
      id: json['id'] ?? 'unknown_id',  // Provide meaningful defaults
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? 'unknown@example.com',
    );
  }

  // Convert the object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  // Create a copy with updated fields
  PigeonUserDetails copyWith({String? id, String? name, String? email}) {
    return PigeonUserDetails(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  @override
  String toString() {
    return 'PigeonUserDetails(id: $id, name: $name, email: $email)';
  }
}
