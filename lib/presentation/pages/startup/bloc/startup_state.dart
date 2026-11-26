part of 'startup_cubit.dart';

@immutable
abstract class StartupState {}

class StartupLoading extends StartupState {}

class StartupHasStore extends StartupState {}

class StartupNoStore extends StartupState {}

class StartupFailure extends StartupState {
  final String message;

  StartupFailure(this.message);
}
