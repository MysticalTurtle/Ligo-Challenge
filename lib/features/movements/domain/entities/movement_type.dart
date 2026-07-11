enum MovementType {
  incoming('in'),
  outgoing('out');

  const MovementType(this.value);

  final String value;

  static MovementType fromString(String value) {
    return MovementType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw ArgumentError('Invalid movement type: $value'),
    );
  }
}

extension MovementTypeExtension on MovementType {
  bool get isIncoming => this == MovementType.incoming;
  bool get isOutgoing => this == MovementType.outgoing;
}
