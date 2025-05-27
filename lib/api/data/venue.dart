class Venue {
  final int id;
  final String name;
  final String location;
  final String workingHours;
  final int maximumCapacity;
  final int availableCapacity;
  double rating;
  final int typeId;
  String? description;

  // final List<String> imageLinks;

  Venue({
    required this.id,
    required this.name,
    required this.location,
    required this.workingHours,
    required this.maximumCapacity,
    required this.availableCapacity,
    required this.rating,
    required this.typeId,
    this.description,
    // required this.imageLinks,
  });

  factory Venue.fromMap(Map<String, dynamic> map) {
    return Venue(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      workingHours: map['workingHours'],
      maximumCapacity: map['maximumCapacity'],
      availableCapacity: map['availableCapacity'],
      rating: map['averageRating'],
      typeId: map['venueTypeId'],
      description: map['description'],
      // imageLinks: map['imageLinks'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'workingHours': workingHours,
      'maximumCapacity': maximumCapacity,
      'availableCapacity': availableCapacity,
      'rating': rating,
      'type': typeId,
      'description': description,
      // 'imageLinks': imageLinks,
    };
  }

  @override
  String toString() {
    return 'Venue(id: $id, name: $name, location: $location, workingHours: $workingHours, rating: $rating, type: $typeId, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Venue &&
        other.id == id &&
        other.name == name &&
        other.location == location &&
        other.workingHours == workingHours &&
        other.maximumCapacity == maximumCapacity &&
        other.availableCapacity == availableCapacity &&
        other.rating == rating &&
        other.typeId == typeId &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        location.hashCode ^
        workingHours.hashCode ^
        maximumCapacity.hashCode ^
        availableCapacity.hashCode ^
        rating.hashCode ^
        typeId.hashCode ^
        description.hashCode;
  }
}
