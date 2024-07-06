import 'package:bloc/bloc.dart';
import 'package:insurance_map/core/app_navigator.dart';
import 'package:insurance_map/data/remote/model/category.dart';
import 'package:insurance_map/repo/main_repository.dart';
import 'package:insurance_map/utils/data_state.dart';
import 'package:meta/meta.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final MainRepository _repository;

  final Map<String, Map<String, dynamic>> _categoriesData = {
    '': {'data': [], 'isEnd': false, 'isLoading': false, 'page': 1}
  };

  CategoriesBloc(this._repository) : super(CategoriesInitial()) {
    on<CategoriesFetch>((event, emit) async {
      if (!_categoriesData.containsKey(event.parentId)){
        _categoriesData[event.parentId] = {'data': [], 'isEnd': false, 'isLoading': false, 'page': 1};
      } else if (_categoriesData[event.parentId]!['isEnd'] || _categoriesData[event.parentId]!['isLoading']) {
        return;
      }
      
      _categoriesData[event.parentId]!['isLoading'] = true;
      DataState<List<Category>> result = await _repository.getCategories(event.parentId, _categoriesData[event.parentId]!['page'], 20);
      _categoriesData[event.parentId]!['isLoading'] = false;
      
      if (result is DataError) {
        emit(CategoriesShow(categories: _categoriesData[event.parentId]!['data'], currentCategoryId: event.parentId));
        return;
      }

      _categoriesData[event.parentId]!['data'].addAll(result.data!);
      _categoriesData[event.parentId]!['isEnd'] = result.data!.length < 20;

      emit(CategoriesShow(categories: _categoriesData[event.parentId]!['data'].cast<Category>(), currentCategoryId: event.parentId));
    });

    on<CategoriesBack>((event, emit) {
      if (_categoriesData.length == 1) {
        _categoriesData[''] = {'data': [], 'isEnd': false, 'isLoading': false, 'page': 1};
        AppNavigator.pop();
        return;
      }

      String lastId = _categoriesData.keys.last;
      _categoriesData.remove(lastId);
      lastId = _categoriesData.keys.last;
      emit(CategoriesShow(categories: _categoriesData[lastId]!['data'].cast<Category>(), currentCategoryId: lastId));
    });
  }
}
