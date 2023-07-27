import 'package:equatable/equatable.dart';

class InternetException extends Equatable implements Exception {
  @override
  List<Object> get props => [];
}

class ServerException extends Equatable implements Exception {
  final String exceptionMessage;

  const ServerException({required this.exceptionMessage});

  @override
  List<Object?> get props => [exceptionMessage];
}

class NoCachedDataFoundException implements Exception {}
