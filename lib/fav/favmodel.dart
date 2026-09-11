

class FavModel {
  final String image, productid, title, unit, unitvalue;
  final double price;
  int quantity;

  FavModel({
    required this.image,
  required this.productid, required this.title, required this.unit,
  required this.unitvalue, required this.price,
    this.quantity = 1,
  });
}