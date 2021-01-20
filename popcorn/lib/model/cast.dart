class Cast {
  final int id;
  final String name;
  final String character;
  final String profileImg;

  Cast(
    this.id,
    this.name,
    this.character,
    this.profileImg,
  );

  Cast.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        character = json["character"],
        profileImg = json["profile_path"];
}
