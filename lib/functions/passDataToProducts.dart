class PassDataToProduct {
  final String title;
  final int productId;
  final String imagePath;
  final String price;
  final String oldPrice;
  final String offer;
  final String uniqueId;

  PassDataToProduct(this.productId, this.imagePath, this.title, this.price,
      this.oldPrice, this.offer, this.uniqueId);
}