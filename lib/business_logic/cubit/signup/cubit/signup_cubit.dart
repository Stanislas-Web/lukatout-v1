import 'package:bloc/bloc.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupState(field: initialState()));


  void updateField(context, {required String field, data}) {
    emit(SignupState(field: {
      ...state.field!,
      field: data,
    }));

  }
}
