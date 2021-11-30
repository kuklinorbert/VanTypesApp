import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'floating_button_event.dart';
part 'floating_button_state.dart';

class FloatingButtonBloc
    extends Bloc<FloatingButtonEvent, FloatingButtonState> {
  FloatingButtonBloc() : super(FloatingButtonInitial());

  bool isVisible = true;

  @override
  Stream<FloatingButtonState> mapEventToState(
      FloatingButtonEvent event) async* {
    if (event is FloatingVisible) {
      yield FloatingVisibleState();
    }
    if (event is FloatingNotVisible) {
      yield FloatingNotVisibleState();
    }
  }
}
