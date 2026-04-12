import 'package:flutter_riverpod/legacy.dart';
import '../models/theater_model.dart';
import '../services/admin_service.dart';

class AdminState {
  final List<TheaterModel> theaters;
  final bool isLoading;
  final String? error;

  const AdminState({
    this.theaters = const [],
    this.isLoading = true,
    this.error,
  });

  AdminState copyWith({
    List<TheaterModel>? theaters,
    bool? isLoading,
    String? error,
  }) => AdminState(
    theaters: theaters ?? this.theaters,
    isLoading: isLoading ?? this.isLoading,
    error: error,
  );
}

class AdminNotifier extends StateNotifier<AdminState> {
  AdminNotifier() : super(const AdminState()) {
    fetchTheaters();
  }
  Future<void> fetchTheaters() async {
    state = state.copyWith(isLoading: true);
    try {
      final data = await AdminService.fetchMyTheaters();
      state = state.copyWith(theaters: data, isLoading: false);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load theaters',
      );
    }
  }
 
  Future<bool> createTheater(String name, String location) async {
    try {
      final theater = await AdminService.createTheater(name, location);
      state = state.copyWith(theaters: [...state.theaters, theater]);
      return true;
    } catch (_) {
      return false;
    }
  }
}

final adminProvider = StateNotifierProvider<AdminNotifier, AdminState>(
  (ref) => AdminNotifier(),
);
