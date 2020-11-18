class Artist {
  Artist({
    this.name,
  });

  String name;

  factory Artist.fromMap(String json) => Artist(
        name: json,
      );

  Map<String, dynamic> toMap() => {
        'Name': name,
      };
}
