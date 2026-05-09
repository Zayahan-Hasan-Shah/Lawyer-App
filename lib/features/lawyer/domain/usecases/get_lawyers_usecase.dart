import 'package:lawyer_app/features/lawyer/domain/repositories/lawyer_repository.dart';

class GetLawyersUseCase {
  final LawyerRepository repository;

  GetLawyersUseCase(this.repository);

  Future<Map<String, dynamic>> execute(int pageNumber, int pageSize) async {
    return await repository.getLawyers(pageNumber, pageSize);
  }
}
