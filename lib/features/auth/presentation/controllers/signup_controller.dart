import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/core/network/api_exceptions.dart';
import 'package:lawyer_app/di/injection_container.dart';
import 'package:lawyer_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:lawyer_app/features/auth/presentation/states/signup_state.dart';

class SignupController extends StateNotifier<SignupState> {
  final SignupUseCase _signupUseCase;

  SignupController({SignupUseCase? useCase})
      : _signupUseCase = useCase ?? sl<SignupUseCase>(),
        super(SignupInitial());

  Future<int?> signup({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String address,
    required String userType,
  }) async {
    state = SignupLoading();
    try {
      final body = {
        "user": {
          "fullName": fullName,
          "email": email,
          "phone": phone,
          "password": password,
          "address": address,
          "profilePhoto": null,
          "userType": userType,
        }
      };

      final responseData = await _signupUseCase.execute(body);

      final Map<String, dynamic> data = responseData['data'] as Map<String, dynamic>;
      final int userId = data['id'] as int;
      final String message = responseData['message'] ?? 'Signup Successful';

      state = SignupSuccess(message);
      return userId;
    } on ApiException catch (e) {
      state = SignupFailure(e.message);
      return null;
    } catch (e) {
      state = SignupFailure("Network error - please try again.");
      return null;
    }
  }
}
