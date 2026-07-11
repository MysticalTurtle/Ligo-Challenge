enum MovementStatus {
  completed('completed'),
  pending('pending');

  const MovementStatus(this.value);

  final String value;

  static MovementStatus fromString(String value) {
    return MovementStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => throw ArgumentError('Invalid movement status: $value'),
    );
  }
}
