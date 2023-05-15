class UserModel {
  String id;
  final String fullname;
  final String password;
  final String email;
  final String? imageUrl;
  final DateTime? dateOfBirth;
  final String phoneNumber; // Required phone number field

  UserModel({
    this.id = '',
    required this.email,
    required this.password,
    required this.fullname,
    required this.phoneNumber, // Make phone number a required field

    this.imageUrl,
    this.dateOfBirth,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "email": email,
        "imageUrl": imageUrl,
        //"dateOfBirth": dateOfBirth?.toIso8601String(),
        "phoneNumber": phoneNumber,
        "password": password,
        // Include phone number in the JSON representation
      };
}
