part of 'categories_and_tags_bloc.dart';

enum Status { Initial, Loading, Loaded, LoadingFail }

class CategoriesAndTagsState extends Equatable {
  final Status status;
  final String error;
  final List<VentCategory> categories;
  final List<Tag> tags;

  CategoriesAndTagsState(
      {this.status = Status.Initial,
      this.error,
      this.categories = const [],
      this.tags = const []});

  CategoriesAndTagsState copyWith({status, error, categories, tags}) {
    return CategoriesAndTagsState(
        status: status ?? this.status,
        error: error ?? this.error,
        categories: categories ?? this.categories,
        tags: tags ?? this.tags);
  }

  @override
  List<Object> get props => [status, error, categories, tags];
}
