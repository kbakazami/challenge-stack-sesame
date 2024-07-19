class Bathrooms {
  final String id;
  final String label;
  final int state;
  final double locationX;
  final double locationY;

  Bathrooms({
    required this.id,
    required this.label,
    required this.state,
    required this.locationX,
    required this.locationY,
  });

  Bathrooms.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        label = data['label'],
        state = data['state'],
        locationX = data['locationX'],
        locationY = data['locationY'];
}