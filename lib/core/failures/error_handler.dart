import 'failure.dart';

class ErrorHandler {
  static Failure handle(dynamic error) {
    if (error is Exception) {
      return ServerFailure(error.toString());
    } else if (error is Failure) {
      return error;
    }
    return ServerFailure('An unexpected error occurred: ${error.toString()}');
  }
}
