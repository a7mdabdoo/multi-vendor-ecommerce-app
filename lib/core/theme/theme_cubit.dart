import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/storage_service.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final StorageService _storageService;

  ThemeCubit(this._storageService) : super(ThemeMode.dark) {
    _loadTheme();
  }

  void _loadTheme() {
    final saved = _storageService.getThemeMode();
    if (saved == 'light') {
      emit(ThemeMode.light);
    } else if (saved == 'system') {
      emit(ThemeMode.system);
    } else {
      emit(ThemeMode.dark);
    }
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final modeString = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.system
            ? 'system'
            : 'dark';
    await _storageService.saveThemeMode(modeString);
    emit(mode);
  }
}
