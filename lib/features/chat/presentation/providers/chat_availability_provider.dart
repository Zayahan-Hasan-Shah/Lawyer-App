import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/features/chat/data/repositories/chat_availability_repository_impl.dart';
import 'package:lawyer_app/features/chat/domain/repositories/chat_availability_repository.dart';

final chatAvailabilityRepositoryProvider = Provider<ChatAvailabilityRepository>((ref) {
  return ChatAvailabilityRepositoryImpl();
});

final chatAvailabilityProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(chatAvailabilityRepositoryProvider);
  return repository.hasActiveCases();
});
