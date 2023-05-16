class UserModel {
  String id;
  final String fullname;
  final String password;
  final String email;
  final String? imageUrl;
  final String? dateOfBirth; // Add this line
  final String phoneNumber;

  UserModel({
    this.id = '',
    required this.email,
    required this.password,
    required this.fullname,
    required this.phoneNumber,
    this.imageUrl,
    this.dateOfBirth, // And this line
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "email": email,
        "phoneNumber": phoneNumber,
        "password": password,
        "imageUrl": imageUrl,
        "dateOfBirth": dateOfBirth, // And this line
      };
}