part of 'feed_bloc.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object> get props => [];
}

class FeedInitial extends FeedState {}

class LoadingFeedItems extends FeedState {}

class LoadedFeedItems extends FeedState {
  final List<Item> items;

  LoadedFeedItems({@required this.items});

  @override
  List<Object> get props => [items];
}

class ErrorFeedItems extends FeedState {
  final String message;

  ErrorFeedItems({@required this.message});

  @override
  List<Object> get props => [message];
}
