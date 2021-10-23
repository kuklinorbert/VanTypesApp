part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class GetFeedItemsEvent extends FeedEvent {
  final String type;

  GetFeedItemsEvent({@required this.type});

  @override
  List<Object> get props => [type];
}
