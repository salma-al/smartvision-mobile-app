part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class MainProfileLoaded extends ProfileState {
  final String join, shift;

  MainProfileLoaded(this.join, this.shift);
}

final class PersonalInfoLoaded extends ProfileState {
  final ProfileInfoModel info;

  PersonalInfoLoaded(this.info);
}

final class CompanyLoaded extends ProfileState {
  final ProfileCompanyModel info;

  CompanyLoaded(this.info);
}

final class ProfileLoading extends ProfileState {}
final class ProfileLoaded extends ProfileState {}
final class ProfileError extends ProfileState {}
