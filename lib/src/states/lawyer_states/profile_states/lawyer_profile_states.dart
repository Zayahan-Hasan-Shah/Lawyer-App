import 'package:lawyer_app/src/models/lawyer_model/profile_model/lawyer_self_profile_model.dart';

sealed class LawyerProfileState {
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(String error) failure,
    required R Function(LawyerSelfProfileModel data) success,
  }) {
    if (this is LawyerProfileInitial) return initial();
    if (this is LawyerProfileLoading) return loading();
    if (this is LawyerProfileFailure) {
      return failure((this as LawyerProfileFailure).error);
    }
    if (this is LawyerProfileSuccess) {
      return success((this as LawyerProfileSuccess).data);
    }
    throw Exception('Unhandled state: $this');
  }
}

class LawyerProfileInitial extends LawyerProfileState {}

class LawyerProfileLoading extends LawyerProfileState {}

class LawyerProfileSuccess extends LawyerProfileState {
  final LawyerSelfProfileModel data;
  LawyerProfileSuccess({required this.data});
}

class LawyerProfileFailure extends LawyerProfileState {
  final String error;
  LawyerProfileFailure({required this.error});
}
