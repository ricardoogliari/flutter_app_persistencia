class Person {
  int id;
  final String firstName;
  final String lastName;

  Person({this.id, this.firstName, this.lastName});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}