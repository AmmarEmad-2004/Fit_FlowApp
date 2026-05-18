import 'package:fit_flow/core/failures/failure.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

class ErrorHandler {
  static Failure handle(dynamic error) {
    if (error is FirebaseException) {
      return ServerFailure(error.message ?? 'Unknown Firebase error occurred.');
    } else if (error is PlatformException) {
      return AppFailure(error.message ?? 'A platform error occurred.');
    } else if (error is Exception) {
      return AppFailure(error.toString());
    } else {
      return AppFailure('An unexpected error occurred: $error');
    }
  }
}
