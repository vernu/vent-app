part of 'categories_and_tags_bloc.dart';

abstract class CategoriesAndTagsEvent extends Equatable {
  const CategoriesAndTagsEvent();

  @override
  List<Object> get props => [];
}

class CategoriesAndTagsLoadRequested extends CategoriesAndTagsEvent {}
