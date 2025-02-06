part of 'employee_cubit.dart';

abstract class EmployeeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final String id;
  final String name;
  final String location;
  final String profileImageUrl;
  final String aboutMe;
  final String rating;
  final List<String> services;
  final bool isAvailable;
  final num reviewsNum;

  EmployeeLoaded({
    required this.id,
    required this.name,
    required this.location,
    required this.profileImageUrl,
    required this.aboutMe,
    required this.rating,
    required this.services,
    required this.isAvailable,
    required this.reviewsNum,
  });

  EmployeeLoaded copyWith({
    String? name,
    String? location,
    String? profileImageUrl,
    String? aboutMe,
    String? rating,
    List<String>? services,
    bool? isAvailable,
    num? reviewsNum,
  }) {
    return EmployeeLoaded(
      id: id,
      name: name ?? this.name,
      location: location ?? this.location,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      aboutMe: aboutMe ?? this.aboutMe,
      rating: rating ?? this.rating,
      services: services ?? this.services,
      isAvailable: isAvailable ?? this.isAvailable,
      reviewsNum: reviewsNum ?? this.reviewsNum,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        location,
        profileImageUrl,
        aboutMe,
        rating,
        services,
        isAvailable,
        reviewsNum,
      ];
}

class EmployeeError extends EmployeeState {
  final String message;
  EmployeeError(this.message);

  @override
  List<Object?> get props => [message];
}
