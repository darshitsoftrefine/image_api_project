class Recipes {
  final String title;
  final String imageUrl;

  Recipes({required this.imageUrl, required this.title});

  factory Recipes.fromJson(Map<String, dynamic> json) {
    return Recipes(
        imageUrl: json['image_url'],
        title: json['title']);
  }
}