part of 'temp_settings_bloc.dart';

enum TempUnit { celcius, farenheit }

class TempSettingsState extends Equatable {
  final TempUnit tempUnit;

  const TempSettingsState({
    this.tempUnit = TempUnit.celcius,
  });

  factory TempSettingsState.initial() {
    return const TempSettingsState();
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [tempUnit];

  TempSettingsState copyWith({
    TempUnit? tempUnit,
  }) {
    return TempSettingsState(
      tempUnit: tempUnit ?? this.tempUnit,
    );
  }
}
