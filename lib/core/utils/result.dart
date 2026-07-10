/// Result type for error handling
sealed class Result<T> {
  const Result();
}

/// Represents a successful result
class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

/// Represents a failed result
class Failure<T> extends Result<T> {
  const Failure(this.message, [this.exception]);
  final String message;
  final Exception? exception;
}
