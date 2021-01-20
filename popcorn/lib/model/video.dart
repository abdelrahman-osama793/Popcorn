class Video {
  final String id;
  final String name;
  final String key;
  final String type;
  final String site;

  Video(this.id, this.name, this.key, this.type, this.site);

  Video.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        key = json["key"],
        type = json["type"],
        site = json["site"];
}
