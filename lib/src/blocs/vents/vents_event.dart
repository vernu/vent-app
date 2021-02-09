part of 'vents_bloc.dart';

abstract class VentsEvent extends Equatable {
  const VentsEvent();

  @override
  List<Object> get props => [];
}

class VentsLoadRequested extends VentsEvent {
  final String userId, categoryId;
  final List<String> tags;
  VentsLoadRequested({this.userId, this.categoryId, this.tags});
}
