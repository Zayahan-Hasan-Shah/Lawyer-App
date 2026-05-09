import 'package:lawyer_app/features/lawyer/data/models/lawyer_model.dart';

sealed class ChatScreenState {
  const ChatScreenState();
}

class ChatScreenInitial extends ChatScreenState {}

class ChatScreenLoading extends ChatScreenState {}

class ChatScreenSuccess extends ChatScreenState {
  final List<LawyerModel> lawyers;
  const ChatScreenSuccess(this.lawyers);
}

class ChatScreenError extends ChatScreenState {
  final String message;
  const ChatScreenError(this.message);
}

