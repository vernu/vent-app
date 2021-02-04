part of 'vents_bloc.dart';

enum Status { Initial, Loading, Loaded, LoadingFail }

class VentsState extends Equatable {
  final Status status;
  final List<Vent> vents;
  final String error;

  VentsState({
    this.status = Status.Initial,
    this.vents = const [],
    this.error,
  });

  VentsState copyWith({status, vents, error}) {
    return VentsState(
        status: status ?? this.status,
        vents: vents ?? this.vents,
        error: error ?? this.error);
  }

  @override
  List<Object> get props => [status, vents, error];
}
