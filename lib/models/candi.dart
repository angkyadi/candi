class Candi {
  final int? id; // ✅ TAMBAHKAN INI - nullable karena auto increment
  final String name;
  final String location;
  final String description;
  final String built;
  final String type;
  final String imageAsset;
  final List<String> imageUrls;
  bool isFavorite;
  final String visitingHours;
  final int sumFavorite;

  Candi({
    this.id, // ✅ TAMBAHKAN INI
    required this.name,
    required this.location,
    required this.description,
    required this.built,
    required this.type,
    required this.imageAsset,
    required this.imageUrls,
    this.isFavorite = false,
    required this.visitingHours,
    required this.sumFavorite,
  });

  // Konversi object Candi ke Map untuk disimpan ke database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'description': description,
      'built': built,
      'type': type,
      'imageAsset': imageAsset,
      'imageUrls': imageUrls.join(','), // Convert List ke String
      'isFavorite': isFavorite ? 1 : 0, // Convert bool ke int
    };
  }

  // Konversi Map dari database ke object Candi
  factory Candi.fromMap(Map<String, dynamic> map) {
    return Candi(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      description: map['description'],
      built: map['built'],
      type: map['type'],
      imageAsset: map['imageAsset'],
      imageUrls: map['imageUrls'].split(','), // Convert String ke List
      isFavorite: map['isFavorite'] == 1, // Convert int ke bool
      visitingHours: '-', // Default value (tidak disimpan di DB)
      sumFavorite: 0, // Default value (tidak disimpan di DB)
    );
  }
}
