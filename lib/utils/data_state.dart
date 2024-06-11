abstract class DataState<T> {
  String? errorMessage;
  T? data;

  DataState({this.errorMessage, this.data});
}

class DataSucces<T> extends DataState<T> {
  DataSucces([T? data]) : super(data: data);
}

class DataError<T> extends DataState<T> {
  DataError(String message) : super(errorMessage: message);
}
