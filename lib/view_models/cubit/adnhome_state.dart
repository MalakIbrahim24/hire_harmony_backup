part of 'adnhome_cubit.dart';

sealed class AdnHomeState {}

final class AdnHomeInitial extends AdnHomeState {}

final class AdnHomeLoading extends AdnHomeState {}

final class AdnHomeSuccess extends AdnHomeState {
  final String message;
  AdnHomeSuccess(this.message);
}

final class AdnHomeLoaded extends AdnHomeState {
  final List<ControlCard> controlCards;

  AdnHomeLoaded(this.controlCards);
}

final class AdnHomeError extends AdnHomeState {
  final String message;

  AdnHomeError(this.message);
}
