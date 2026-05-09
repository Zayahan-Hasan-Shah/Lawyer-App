abstract class LawyerRepository {
  Future<Map<String, dynamic>> getLawyers(int pageNumber, int pageSize);
}
