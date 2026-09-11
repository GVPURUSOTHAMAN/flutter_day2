class CartItem {
  final String image, productid, title, unit, unitValue, subscribePrice;
  final double price;
  int quantity;

  CartItem({
    required this.price,
    required this.image,
    required this.productid,
    required this.title,
    required this.unit,
    required this.unitValue,
    this.quantity = 1,
    required this.subscribePrice,
  });

  double get total => price * quantity;
}