class Product {
  static const String idKey = 'id';
  static const String descriptionKey = 'description';
  static const String priceKey = 'price';
  static const String availableKey = 'available';
  static const String imageUrlKey = 'imageUrl';
  static const String ratingKey = 'rating';

  final String? id;
  final String description;
  final double price;
  final DateTime available;
  final String imageUrl;
  final int rating;

  const Product({
    this.id,
    required this.description,
    required this.price,
    required this.available,
    required this.imageUrl,
    required this.rating,
  });

  Product.fromJson(Map<String, dynamic> json)
      : id = json[idKey],
        description = json[descriptionKey] != null
            ? json[descriptionKey].toString()
            : 'Sin descripción',
        price = double.tryParse(json[priceKey].toString()) ?? 0.0,
        available = json[availableKey] != null
            ? DateTime.parse(json[availableKey].toString())
            : DateTime.now(),
        imageUrl =
            json[imageUrlKey] != null ? json[imageUrlKey].toString() : '',
        rating = int.tryParse(json[ratingKey].toString()) ?? 0;

  Map<String, dynamic> toJson() {
    if (id == null) {
      return {
        descriptionKey: description,
        priceKey: price,
        availableKey: available.toIso8601String(),
        imageUrlKey: imageUrl,
        ratingKey: rating
      };
    } else {
      return {
        idKey: id,
        descriptionKey: description,
        priceKey: price,
        availableKey: available.toIso8601String(),
        imageUrlKey: imageUrl,
        ratingKey: rating
      };
    }
  }
}



//   const Product({
//     required this.id,
//     required this.description,
//     required this.price,
//     required this.available,
//     required this.imageUrl,
//     required this.rating,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'] as String,
//       description: json['description'] as String,
//       price: json['price'] as double,
//       available: DateTime.parse(json['available'] as String),
//       imageUrl: json['imageUrl'] as String,
//       rating: json['rating'] as int,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'description': description,
//       'price': price,
//       'available': available.toIso8601String(),
//       'imageUrl': imageUrl,
//       'rating': rating,
//     };
//   }
// }

// final List<Product> products = [
//   Product(
//     id: '1',
//     description: 'WD BLACK SN770 2TB NVMe SSD',
//     price: 115,
//     available: DateTime.parse('2023-10-03'),
//     imageUrl: 'https://picsum.photos/200/300',
//     rating: 4,
//   ),
//   Product(
//     id: '2',
//     description: 'MSI MPG B550 GAMING PLUS',
//     price: 139.9,
//     available: DateTime.parse('2023-09-05'),
//     imageUrl: 'https://picsum.photos/200/300',
//     rating: 5,
//   ),
//   Product(
//     id: '3',
//     description: 'Kingston FURY Beast DDR4 3200 MHz 16GB 2x8GB CL16',
//     price: 42.95,
//     available: DateTime.parse('2023-01-10'),
//     imageUrl: 'https://picsum.photos/200/300',
//     rating: 3,
//   ),
// ];
