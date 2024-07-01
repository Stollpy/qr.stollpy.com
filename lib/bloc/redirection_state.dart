part of "redirection_bloc.dart";

class RedirectionState extends Equatable
{
  final bool isLoading;
  final bool isSuccess;
  final bool isInit;
  final String redirection;
  final List<String> errors;

  const RedirectionState({
    this.isLoading = true,
    this.isSuccess = false,
    this.isInit = false,
    this.errors = const [],
    this.redirection = "",
  });

  RedirectionState copy({
    bool? isLoading,
    bool? isSuccess,
    bool? isInit,
    String? redirection,
    List<String>? errors,
  }) {
    return RedirectionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isInit: isInit ?? this.isInit,
      redirection: redirection ?? this.redirection,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object> get props => [
    isLoading,
    isSuccess,
    errors,
    redirection
  ];
}