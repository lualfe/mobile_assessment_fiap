class Measurement {
  int? id;
  String bodyPart;
  double value;
  int updatedAt;

  Measurement(this.id, this.bodyPart, this.value, this.updatedAt);
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bodyPart': bodyPart,
      'value': value,
      'updatedAt': updatedAt,
    };
  }
}
