class UserModel {
  String id;
  final String firstname;
  final String lastname;
  final String email;
  //final String password;

  UserModel(
      {this.id = '',
      required this.email,
      required this.firstname,
      required this.lastname});

  Map<String, dynamic> TOjSON() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
      };
}
