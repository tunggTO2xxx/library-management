enum Gender {
  male,
  female;

  String get name {
    return switch (this) {
      male => 'Male',
      female => 'Female',
    };
  }
}
