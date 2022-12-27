import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'temp_settings_state.dart';

class TempSettingsCubit extends Cubit<TempSettingsState> {
  TempSettingsCubit() : super(TempSettingsState.initial());

  void toggleTempSettings() {
    emit(
      state.copyWith(
        tempUnit: state.tempUnit == TempUnit.celcius
            ? TempUnit.farenheit
            : TempUnit.celcius,
      ),
    );
    print(state.tempUnit);
  }
}
