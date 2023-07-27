import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  String get message;

  const Failure([List properties = const <dynamic>[]]);
}

class ServerFailure extends Failure {
  final String failureMessage;

  const ServerFailure({required this.failureMessage});

  @override
  String get message => failureMessage;

  @override
  List<Object?> get props => [];
}

class InternetFailure extends Failure {
  @override
  String get message => "Please check your internet connection!";

  @override
  List<Object?> get props => [];
}

class NoCachedDataFoundFailure extends Failure {
  @override
  String get message => "No Data Found";

  @override
  List<Object?> get props => [];
}
