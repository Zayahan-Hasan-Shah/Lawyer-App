import 'package:lawyer_app/features/lawyer/domain/entities/lawyer_entity.dart';

sealed class ChatScreenState {
  const ChatScreenState();
}

class ChatScreenInitial extends ChatScreenState {}

class ChatScreenLoading extends ChatScreenState {}

class ChatScreenSuccess extends ChatScreenState {
  final List<LawyerEntity> lawyers;
  const ChatScreenSuccess(this.lawyers);
}

class ChatScreenError extends ChatScreenState {
  final String message;
  const ChatScreenError(this.message);
}
