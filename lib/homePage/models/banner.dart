

class Banner {
  final String id, catid, title, img, catimg;
  Banner({
    required this.title,
    required this.id,
    required this.catid,
    required this.catimg,
    required this.img
});
  factory Banner. fromJson(Map<String, dynamic> json){
    return Banner(title: json["title"]?.toString() ?? "",
        id: json["id"]?.toString() ?? "",
        catid: json["cat_id"]?.toString() ?? "0",
        catimg: json["cat_img"]?.toString() ?? "",
        img: json["img"]?.toString() ?? "",
    );
  }
}