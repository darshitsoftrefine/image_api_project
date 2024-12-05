class Recipes {
  late String title;
  late String imageUrl;

  Recipes(this.imageUrl, this.title);

  Recipes.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
    title = json['title'];
  }
}