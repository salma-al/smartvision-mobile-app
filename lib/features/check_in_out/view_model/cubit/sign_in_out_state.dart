part of 'sign_in_out_cubit.dart';

@immutable
sealed class SignInOutState {}

final class SignInOutInitial extends SignInOutState {}

final class GetLastCheckSuccess extends SignInOutState {}
final class GetLastCheckError extends SignInOutState {}

final class UpdateElapsedTime extends SignInOutState {}

final class CheckInOutLoading extends SignInOutState {}
final class CheckInOutSuccess extends SignInOutState {}
final class CheckInOutError extends SignInOutState {}
