import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/models/lawyer_model/profile_model/lawyer_self_profile_model.dart';

final LawyerSelfProfileModel mockLawyerSelfProfile = LawyerSelfProfileModel(
  fullName: 'Adv. Zayahan Hasan Shah',
  title: 'High Court Lawyer  Criminal & Civil Litigation',
  location: 'Lahore, Pakistan',
  yearsOfPractice: 8,
  casesHandled: 240,
  overallWinRate: 0.76,
  activeMatters: 18,
  practiceAreas: [
    'Criminal Law',
    'Civil Litigation',
    'Contract Law',
    'Family Law',
    'Arbitration',
  ],
  about:
      'Dedicated litigation counsel with a focus on strategic case planning, evidence-driven arguments, and client-centric advocacy across trial and appellate forums.',
  email: 'ayesha.khan@legalsuite.com',
  phone: '+92 300 1234567',
  officeHours: 'Mon - Fri  10:00 AM - 6:00 PM',
  profileImage: AppAssets.civilLawyerImage,
);
