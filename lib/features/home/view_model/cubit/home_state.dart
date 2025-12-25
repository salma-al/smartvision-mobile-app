part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoaded extends HomeState {
  final HomeModel home;

  HomeLoaded(this.home);
}

final class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
