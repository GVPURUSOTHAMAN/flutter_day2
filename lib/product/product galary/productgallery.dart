class ProductGallery {
  final String id;
  final String productId;
  final String image;
  final String status;

  ProductGallery({
    required this.id,
    required this.productId,
    required this.image,
    required this.status,
  });

  factory ProductGallery.fromJson(Map<String, dynamic> json) {
    return ProductGallery(
      id: json['id']?.toString() ?? '',
      productId: json['pid']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}
