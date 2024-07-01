part of "redirection_bloc.dart";

sealed class RedirectionEvent extends Equatable
{
  @override
  List<Object> get props => [];

}

class InitRedirection extends RedirectionEvent {}

class RedirectionChange extends RedirectionEvent
{
  final String redirection;

  RedirectionChange({
    required this.redirection,
  });
  
  @override
  List<Object> get props => [redirection];
}