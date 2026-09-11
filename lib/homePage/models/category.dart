

class Categories {
  final String id, title, catimg;
  Categories({
    required this.catimg,
    required this.id,
    required this.title
});
  factory Categories.fromJson(Map<String, dynamic> json){
    return Categories(catimg: json["cat_img"]?.toString() ?? "",
        id: json["id"]?.toString() ?? "",
        title: json["title"]?.toString() ?? "");
  }

}