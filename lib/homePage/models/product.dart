import 'package:day2/product/product%20galary/productgallery.dart';

class Product {
  final String productid, cityid, catid, catname, subcatid, discount, variation, regularprice, subscriberprice, title,
      hsncode, unitvalue, unit, productimg, pdesc;
  final List<ProductGallery> gallery;
  Product({
    required this.title,
    required this.catid,
    required this.productid,
    required this.unit,
    required this.cityid,
    required this.catname,
    required this.discount,
    required this.hsncode,
    required this.productimg,
    required this.regularprice,
    required this.subcatid,
    required this.subscriberprice,
    required this.unitvalue,
    required this.variation,
    required this.pdesc, required this.gallery,
  });

  factory Product.fromJson(Map<String, dynamic> json){
    final galleryJson = json['products_gallery'] as List? ?? [];
    return Product(
      title: json["product_title"]?.toString() ?? "",
      catid: json["catid"]?.toString() ?? "",
      productid: json["product_id"]?.toString() ?? "",
      unit: json["unit"]?.toString() ?? "",
      cityid: json["cityid"]?.toString() ?? "",
      catname: json["catname"]?.toString() ?? "",
      discount: json["product_discount"]?.toString() ?? "0",
      hsncode: json["hsn_code"]?.toString() ?? "",
      productimg: json["product_img"]?.toString() ?? "",
      regularprice: json["product_regularprice"]?.toString() ?? "0",
      subcatid: json["subcatid"]?.toString() ?? "",
      subscriberprice: json["product_subscribeprice"]?.toString() ?? "",
      unitvalue: json["unit_value"]?.toString() ?? "",
      variation: json["product_variation"]?.toString() ?? "",
      pdesc: json["pdesc"]?.toString() ?? "",
      gallery: galleryJson.map((item) => ProductGallery.fromJson(item)).toList(),
    );
  }
}