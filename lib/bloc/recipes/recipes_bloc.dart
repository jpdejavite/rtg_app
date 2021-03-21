import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/repository/recipes_repository.dart';
import 'package:rtg_app/bloc/recipes/events.dart';
import 'package:rtg_app/bloc/recipes/states.dart';

class RecipesBloc extends Bloc<RecipesEvents, RecipesState> {
  final RecipesRepository recipesRepo;
  RecipesCollection _recipesCollection = RecipesCollection();
  RecipesBloc({this.recipesRepo}) : super(RecipesInitState());
  @override
  Stream<RecipesState> mapEventToState(RecipesEvents event) async* {
    if (event is StartFetchRecipesEvent) {
      yield RecipesLoading();
      await recipesRepo.populateDB();
      _recipesCollection =
          await recipesRepo.search(searchParams: event.searchParams);
      yield RecipesLoaded(recipesCollection: _recipesCollection);
    } else if (event is FetchRecipesEvent) {
      if (_recipesCollection.recipes.length == 0) {
        yield RecipesLoading();
      } else {
        yield RecipesLoadingMore(recipesCollection: _recipesCollection);
      }
      RecipesCollection recipesCollection =
          await recipesRepo.search(searchParams: event.searchParams);

      _recipesCollection.recipes.addAll(recipesCollection.recipes);
      _recipesCollection.total = recipesCollection.total;
      yield RecipesLoaded(recipesCollection: _recipesCollection);
    }
  }
}
