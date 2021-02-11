import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vent/src/models/vent_category.dart';
import 'package:vent/src/models/tag.dart';
import 'package:vent/src/repository/category_repository.dart';
import 'package:vent/src/repository/tag_repository.dart';

part 'categories_and_tags_event.dart';
part 'categories_and_tags_state.dart';

class CategoriesAndTagsBloc
    extends Bloc<CategoriesAndTagsEvent, CategoriesAndTagsState> {
  CategoriesAndTagsBloc() : super(CategoriesAndTagsState());

  @override
  Stream<CategoriesAndTagsState> mapEventToState(
    CategoriesAndTagsEvent event,
  ) async* {
    if (event is CategoriesAndTagsLoadRequested) {
      yield this.state.copyWith(status: Status.Loading);
      try {
        List<VentCategory> categories = await CategoryRepository().getCategories();
        List<Tag> tags = await TagRepository().getTags();

        yield CategoriesAndTagsState(
            status: Status.Loaded, categories: categories, tags: tags);
      } catch (e) {
        yield this
            .state
            .copyWith(status: Status.LoadingFail, error: e.toString());
      }
    }
  }
}
