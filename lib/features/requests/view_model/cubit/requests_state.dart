part of 'requests_cubit.dart';

@immutable
sealed class RequestsState {}

final class RequestsInitial extends RequestsState {}

final class RequestsLoading extends RequestsState {}
final class RequestsLoaded extends RequestsState {}

final class RequestsFilterToggled extends RequestsState {}
final class RequestDateChanged extends RequestsState {}
final class RequestsTypeChanged extends RequestsState {}
final class RequestsNeedActionToggled extends RequestsState {}
final class RequestsFiltered extends RequestsState {}