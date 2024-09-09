class UserModal {
  String email;
  String userName;
  DateTime date;
  String? address;
  String? profileUrl;
  String? phoneNumber;
  String userId;
  String? dob;
  String role;

  UserModal({
    required this.userName,
    required this.email,
    required this.date,
    this.profileUrl,
    this.address,
    this.dob,
    this.phoneNumber,
    required this.userId,
    required this.role
  });

  // Convert UserModal instance to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'role':role,
      'email': email,
      'userName': userName,
      'date': date.toIso8601String(), // Convert DateTime to String
      'address': address,
      'profileUrl': profileUrl,
      'phoneNumber': phoneNumber,
      'userId': userId,
      'dob': dob,
    };
  }

  // Create a UserModal instance from a JSON-compatible map
  factory UserModal.fromJson(Map<String, dynamic> json) {
    return UserModal(
      role: json['role'],
      email: json['email'],
      userName: json['userName'],
      date: DateTime.parse(json['date']), // Parse String to DateTime
      address: json['address'],
      profileUrl: json['profileUrl'],
      phoneNumber: json['phoneNumber'],
      userId: json['userId'],
      dob: json['dob'],
    );
  }
}
