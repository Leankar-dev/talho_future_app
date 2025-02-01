class ProductModel {
  String lotNumber;
  String meatType;
  DateTime expirationDate;
  DateTime receivedDate;
  String supplier;
  double quantity;

  ProductModel({
    required this.lotNumber,
    required this.meatType,
    required this.expirationDate,
    required this.receivedDate,
    required this.supplier,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'lotNumber': lotNumber,
      'meatType': meatType,
      'expirationDate': expirationDate.toIso8601String(),
      'receivedDate': receivedDate.toIso8601String(),
      'supplier': supplier,
      'quantity': quantity,
    };
  }

  static ProductModel fromJson(Map<String, dynamic> json) {
    return ProductModel(
      lotNumber: json['lotNumber'],
      meatType: json['meatType'],
      expirationDate: DateTime.parse(json['expirationDate']),
      receivedDate: DateTime.parse(json['receivedDate']),
      supplier: json['supplier'],
      quantity: json['quantity'],
    );
  }
}
