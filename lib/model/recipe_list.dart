import 'dart:convert';

List<Recipe> recipesFromJson(String str) =>
    List<Recipe>.from(json.decode(str).map((x) => Recipe.fromJson(x)));

String recipesToJson(List<Recipe> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Recipe {
  Recipe({
    this.createdAt,
    this.title,
  });

  String createdAt;
  String title;

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        createdAt: json["createdAt"],
        title: json["title"],
      );
  Map<String, dynamic> toJson() => {
        "createdAt": createdAt,
        "title": title,
      };
}
