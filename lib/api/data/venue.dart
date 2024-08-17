class Venue {
  final int id;
  final String name;
  final String location;
  final String workingHours;
  final double rating;
  final VenueType type;
  final String description;

  Venue({
    required this.id,
    required this.name,
    required this.location,
    required this.workingHours,
    required this.rating,
    required this.type,
    required this.description,
  });

  factory Venue.fromMap(Map<String, dynamic> map) {
    return Venue(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      workingHours: map['workingHours'],
      rating: map['rating'],
      type: map['type'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'workingHours': workingHours,
      'rating': rating,
      'type': type,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Venue(id: $id, name: $name, location: $location, workingHours: $workingHours, rating: $rating, type: $type, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Venue &&
        other.id == id &&
        other.name == name &&
        other.location == location &&
        other.workingHours == workingHours &&
        other.rating == rating &&
        other.type == type &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        location.hashCode ^
        workingHours.hashCode ^
        rating.hashCode ^
        type.hashCode ^
        description.hashCode;
  }
}

enum VenueType {
  italian,
  asian,
  gluten_free,
  cafe,
  traditional,
  japanese,
  middle_eastern,
  barbeque,
  greek,
  cocktail_bar,
  vegetarian,
  vegan,
  fine_dining,
  fast_food,
  seafood,
  mexican,
  indian,
  chinese,
  pizza,
  ice_cream;

  @override
  String toString() {
    return name[0].toUpperCase() + name.substring(1).replaceAll('_', ' ');
  }
}