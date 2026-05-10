import 'package:lawyer_app/features/chat/domain/repositories/chat_availability_repository.dart';

class ChatAvailabilityRepositoryImpl implements ChatAvailabilityRepository {
  @override
  Future<bool> hasActiveCases() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    // Dummy logic: return true to show chat, or false to test empty state
    return true; 
  }
}
