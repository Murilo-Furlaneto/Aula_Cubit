abstract class ApiState {}

class InitialState extends ApiState {}

class LoadingState extends ApiState {}

class LoadedState<T> extends ApiState {
  final T data;

  LoadedState(this.data);
}

class ErrorState extends ApiState {
  final String message;

  ErrorState(this.message);
}