class Response<T> {
  final bool success;
  final String message;
  final T? data;

  Response({
    required this.success,
    required this.message,
    required this.data,
  });

  factory Response.success(T data) {
    return Response(
      success: true,
      message: '',
      data: data,
    );
  }

  factory Response.fail(String message) {
    return Response(
      success: false,
      message: message,
      data: null,
    );
  }
}
