part of 'on_boarding_cubit.dart';

@freezed
class OnBoardingState with _$OnBoardingState {
  const factory OnBoardingState.initial({
    @Default('main store') String name,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default('') String exceptionError
  }) = _Initial;
}