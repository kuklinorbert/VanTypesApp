import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/features/domain/usecases/register.dart';
import 'package:easy_localization/easy_localization.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final Register _register;

  RegistrationBloc({@required Register register})
      : _register = register,
        super(RegistrationInitial());

  Stream<RegistrationState> mapEventToState(RegistrationEvent event) async* {
    if (event is RegisterEvent) {
      final result = await _register.call(Params(
          userName: event.userName,
          email: event.email,
          password: event.password));
      yield* _eitherRegistrationOrErrorState(result);
    }
  }

  Stream<RegistrationState> _eitherRegistrationOrErrorState(
    Either<Failure, UserCredential> failureOrRegistration,
  ) async* {
    yield failureOrRegistration.fold(
      (failure) => RegistrationError(message: _mapFailureToMessage(failure)),
      (user) {
        return RegistrationSuccess();
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case RegistrationFailure:
        return 'registration_fail'.tr();
      case RegistrationInvalidEmailFailure:
        return 'registration_inv_email'.tr();
      case RegistrationWeakPasswordFailure:
        return 'registration_weak_passw'.tr();
      case RegistrationEmailAlreadyInUseFailure:
        return 'registration_email_in_use'.tr();
      case RegistrationUsernameTakenFailure:
        return 'registration_user_taken'.tr();
      case NetworkFailure:
        return 'network_fail'.tr();
      default:
        return 'unexp_error'.tr();
    }
  }
}
