part of 'adnhome_cubit.dart';

abstract class AdnHomeState {}

class AdnHomeInitial extends AdnHomeState {}

class AdnHomeLoading extends AdnHomeState {}

class AdnHomeLoaded extends AdnHomeState {
  final List<ControlCard> controlCards;
  final int unreadNotificationsCount;

  AdnHomeLoaded(this.controlCards, {required this.unreadNotificationsCount});
}

class AdnHomeError extends AdnHomeState {
  final String message;
  AdnHomeError(this.message);
}

class AdnHomeSuccess extends AdnHomeState {
  final String message;
  AdnHomeSuccess(this.message);
}
