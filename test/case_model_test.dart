import 'package:flutter_test/flutter_test.dart';
import 'package:lawyer_app/features/client/domain/entities/case_entity.dart';
import 'package:lawyer_app/features/client/data/models/case_model/case_model.dart';
import 'package:lawyer_app/features/lawyer/data/models/case_model/lawyer_case_model.dart';

void main() {
  group('CaseNote Parsing Tests', () {
    test('should parse valid JSON with all fields', () {
      final json = {
        'id': 2,
        'caseId': 'CASE-20260520-AA2AEE38',
        'date': '2026-06-05T15:56:57.888025',
        'notes': 'new test note',
        'createdBy': 'Okasha Zubair',
        'createdOn': '2026-06-05T15:56:57.891844',
        'updatedBy': 'system',
        'updatedOn': '2026-06-05T15:56:57.8925813'
      };

      final note = CaseNoteModel.fromJson(json);

      expect(note.id, 2);
      expect(note.caseId, 'CASE-20260520-AA2AEE38');
      expect(note.notes, 'new test note');
      expect(note.createdBy, 'Okasha Zubair');
      expect(note.createdOn, '2026-06-05T15:56:57.891844');
      expect(note.updatedBy, 'system');
      expect(note.updatedOn, '2026-06-05T15:56:57.8925813');
    });

    test('should handle nullable metadata and empty note keys safely', () {
      final json = {
        'id': 1,
        'caseId': 'CASE-20260520-F6F5EA0B',
        'date': '2026-05-20T18:05:00.8834224',
        'notes': null,
        'createdBy': null,
        'createdOn': null,
        'updatedBy': null,
        'updatedOn': null
      };

      final note = CaseNoteModel.fromJson(json);

      expect(note.id, 1);
      expect(note.caseId, 'CASE-20260520-F6F5EA0B');
      expect(note.notes, '');
      expect(note.createdBy, isNull);
      expect(note.createdOn, isNull);
      expect(note.updatedBy, isNull);
      expect(note.updatedOn, isNull);
    });

    test('should fallback to alternate note key aliases', () {
      final json1 = {'id': 1, 'content': 'content note text'};
      final json2 = {'id': 2, 'note': 'note note text'};

      final note1 = CaseNoteModel.fromJson(json1);
      final note2 = CaseNoteModel.fromJson(json2);

      expect(note1.notes, 'content note text');
      expect(note2.notes, 'note note text');
    });
  });

  group('LawyerCaseModel Parsing Tests', () {
    test('should parse correctly with advocate and notes parameters', () {
      final caseJson = {
        'id': 1,
        'caseId': 'CASE-123456',
        'caseType': 'Civil',
        'court': 'Delhi High Court',
        'status': 'Pending',
        'createdBy': 'Client Name',
        'appointment_Type': 'WalkIn',
        'appointmentDate': '2026-05-28T09:00:00',
        'advocate': 'Advocate John Doe',
        'file_Path': 'Uploads/file.png'
      };

      final notes = [
        CaseNoteEntity(
          id: 10,
          caseId: 'CASE-123456',
          date: DateTime.now(),
          notes: 'Test Note',
        )
      ];

      final model = LawyerCaseModel.fromJson(caseJson, notes: notes);

      expect(model.id, 1);
      expect(model.caseNo, 'CASE-123456');
      expect(model.court, 'Delhi High Court');
      expect(model.status, 'Pending');
      expect(model.client, 'Client Name');
      expect(model.category, 'Civil');
      expect(model.appointmentType, 'WalkIn');
      expect(model.advocate, 'Advocate John Doe');
      expect(model.notes, notes);
      expect(model.documents, ['Uploads/file.png']);
    });

    test('should handle missing advocate and notes safely', () {
      final caseJson = {
        'id': 2,
        'caseId': 'CASE-7890',
        'caseType': 'Criminal',
        'court': 'District Court',
        'status': 'Disposed',
        'createdBy': 'Okasha',
        'appointment_Type': 'Video',
        'appointmentDate': '2026-05-28T09:00:00'
      };

      final model = LawyerCaseModel.fromJson(caseJson);

      expect(model.id, 2);
      expect(model.caseNo, 'CASE-7890');
      expect(model.advocate, isNull);
      expect(model.notes, isEmpty);
    });
  });

  group('CaseModel Parsing Tests', () {
    test('should parse advocate and notes for client CaseModel correctly', () {
      final caseJson = {
        'id': 5,
        'caseId': 'CASE-555',
        'caseType': 'Family',
        'court': 'Supreme Court',
        'status': 'Pending',
        'createdBy': 'Alice',
        'appointment_Type': 'WalkIn',
        'appointmentDate': '2026-05-28T09:00:00',
        'advocate': 'Senior Advocate Bob'
      };

      final notes = [
        CaseNoteEntity(id: 1, caseId: 'CASE-555', date: DateTime.now(), notes: 'Client case note')
      ];

      final model = CaseModel.fromJson(caseJson, notes: notes);

      expect(model.id, 5);
      expect(model.caseNo, 'CASE-555');
      expect(model.advocate, 'Senior Advocate Bob');
      expect(model.lawyerName, 'Senior Advocate Bob');
      expect(model.notes, notes);
    });

    test('should fallback to Not Assigned if advocate is null', () {
      final caseJson = {
        'id': 6,
        'caseId': 'CASE-666',
        'caseType': 'Corporate',
        'court': 'High Court',
        'status': 'Pending',
      };

      final model = CaseModel.fromJson(caseJson);

      expect(model.id, 6);
      expect(model.caseNo, 'CASE-666');
      expect(model.advocate, isNull);
      expect(model.lawyerName, 'Not Assigned');
    });
  });
}
