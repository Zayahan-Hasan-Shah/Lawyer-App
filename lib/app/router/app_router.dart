import 'package:go_router/go_router.dart';
import 'package:lawyer_app/features/client/presentation/screens/chat/chat_screen.dart';
import 'package:lawyer_app/features/lawyer/domain/entities/lawyer_entity.dart';
import 'package:lawyer_app/features/student/data/models/certification_model.dart';
import 'package:lawyer_app/features/student/data/models/internship_model/internship_model.dart';
import 'package:lawyer_app/app/router/route_names.dart';
import 'package:lawyer_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:lawyer_app/features/auth/presentation/screens/incoming_user_type_screen.dart';
import 'package:lawyer_app/features/auth/presentation/screens/login_screen.dart';
import 'package:lawyer_app/features/auth/presentation/screens/otp_screen.dart';
import 'package:lawyer_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:lawyer_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:lawyer_app/features/client/presentation/screens/bottom_navigation_screen.dart';
import 'package:lawyer_app/features/client/presentation/screens/video/video_screen.dart';
import 'package:lawyer_app/features/client/presentation/screens/home/court_info_screen.dart';
import 'package:lawyer_app/features/client/presentation/screens/support/support_form_screen.dart';
import 'package:lawyer_app/features/client/presentation/screens/home/home_screen.dart';
import 'package:lawyer_app/features/client/presentation/screens/notifications/notification_screen.dart';
import 'package:lawyer_app/features/client/presentation/screens/search/search_screen.dart';
import 'package:lawyer_app/features/chat/presentation/screens/video_list_screen.dart';
import 'package:lawyer_app/features/chat/presentation/screens/video_call_screen.dart';
import 'package:lawyer_app/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:lawyer_app/features/chat/presentation/screens/chat_detail_screen.dart' as shared_chat;
import 'package:lawyer_app/features/lawyer/presentation/screens/settings/lawyer_settings_screen.dart';
import 'package:lawyer_app/features/lawyer/presentation/screens/lawyer_login.dart';
import 'package:lawyer_app/features/lawyer/presentation/screens/lawyer_signup.dart';
import 'package:lawyer_app/features/lawyer/presentation/screens/lawyer_bottom_navigation_screen.dart';
import 'package:lawyer_app/features/onboarding/presentation/screens/on_boarding_screen.dart';
import 'package:lawyer_app/features/onboarding/presentation/screens/role_overview_screen.dart';
import 'package:lawyer_app/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:lawyer_app/features/profile/presentation/screens/lawyer_profile_screen.dart';
import 'package:lawyer_app/features/lawyer/presentation/screens/lawyer_profile_screen.dart'
    as self_profile;
import 'package:lawyer_app/features/student/presentation/screens/student_login_screen.dart';
import 'package:lawyer_app/features/student/presentation/screens/student_signup_screen.dart';
import 'package:lawyer_app/features/student/presentation/screens/certification_screens/certification_detail_screen.dart';
import 'package:lawyer_app/features/student/presentation/screens/internship_screens/internship_detail_screen.dart';
import 'package:lawyer_app/features/student/presentation/screens/student_bottom_navigation_screen.dart';
import 'package:lawyer_app/features/student/presentation/screens/student_dashboard_screen.dart';
import 'package:lawyer_app/features/student/presentation/screens/certification_screens/certification_screen.dart';
import 'package:lawyer_app/features/student/presentation/screens/tasks_screen.dart';
import 'package:lawyer_app/features/student/presentation/screens/research_screen.dart';
import 'package:lawyer_app/features/student/presentation/screens/student_profile_screen.dart';
import 'package:lawyer_app/features/student/presentation/screens/internship_screens/internship_screen.dart';
import 'package:lawyer_app/features/student/presentation/screens/programs_screen.dart';
import 'package:lawyer_app/features/student/presentation/screens/settings/student_settings_screen.dart';
import 'package:lawyer_app/shared/screens/help_support_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RouteNames.splashScreen,
    routes: [
      GoRoute(
        path: RouteNames.splashScreen,
        name: RouteNames.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboardingScreen,
        name: RouteNames.onboardingScreen,
        builder: (context, state) => const OnBoardingScreen(),
      ),
      GoRoute(
        path: RouteNames.roleOverviewScreen,
        name: RouteNames.roleOverviewScreen,
        builder: (context, state) => const RoleOverviewScreen(),
      ),
      GoRoute(
        path: RouteNames.incomingUserScreen,
        name: RouteNames.incomingUserScreen,
        builder: (context, state) => const IncomingUserTypeScreen(),
      ),
      GoRoute(
        path: RouteNames.signupScreen,
        name: RouteNames.signupScreen,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: RouteNames.loginScreen,
        name: RouteNames.loginScreen,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.forgotPasswordScreen,
        name: RouteNames.forgotPasswordScreen,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.otpScreen,
        name: RouteNames.otpScreen,
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: RouteNames.resetPasswordScreen,
        name: RouteNames.resetPasswordScreen,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.bottomNavigationScreen,
        name: RouteNames.bottomNavigationScreen,
        builder: (context, state) => const BottomNavigationScreen(),
      ),
      GoRoute(
        path: RouteNames.homeScreen,
        name: RouteNames.homeScreen,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.courtInfoScreen,
        name: RouteNames.courtInfoScreen,
        builder: (context, state) => const CourtInfoScreen(),
      ),
      GoRoute(
        path: RouteNames.supportFormScreen,
        name: RouteNames.supportFormScreen,
        builder: (context, state) => const SupportFormScreen(),
      ),
      GoRoute(
        path: RouteNames.chatScreen,
        name: RouteNames.chatScreen,
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: RouteNames.chatDetailScreen,
        name: RouteNames.chatDetailScreen,
        builder: (context, state) {
          final chatId = state.pathParameters['chatId'] ?? 'default';
          return shared_chat.ChatDetailScreen(chatId: chatId);
        },
      ),
      GoRoute(
        path: RouteNames.chatListScreen,
        name: RouteNames.chatListScreen,
        builder: (context, state) => const ChatListScreen(),
      ),
      GoRoute(
        path: RouteNames.videoScreen,
        name: RouteNames.videoScreen,
        builder: (context, state) => const VideoListScreen(),
      ),
      GoRoute(
        path: '/video-call',
        builder: (context, state) => const VideoCallScreen(),
      ),
      GoRoute(
        path: RouteNames.searchScreen,
        name: RouteNames.searchScreen,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: RouteNames.notificationScreen,
        name: RouteNames.notificationScreen,
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: RouteNames.lawyerScreen,
        name: RouteNames.lawyerScreen,
        builder: (context, state) {
          // 1. Grab the lawyer that was passed via `extra`
          final lawyer = state.extra as LawyerEntity;

          // 2. Return the screen with the required (non-nullable) lawyer
          return LawyerProfileScreen(lawyer: lawyer);
        },
      ),

      // Lawyer's Screens
      GoRoute(
        path: RouteNames.lawyerSignupScreen,
        name: RouteNames.lawyerSignupScreen,
        builder: (context, state) => LawyerSignup(),
      ),
      GoRoute(
        path: RouteNames.lawyerloginScreen,
        name: RouteNames.lawyerloginScreen,
        builder: (context, state) => LawyerLogin(),
      ),
      GoRoute(
        path: RouteNames.lawyerBottomNavigationScreen,
        name: RouteNames.lawyerBottomNavigationScreen,
        builder: (context, state) => const LawyerBottomNavigationScreen(),
      ),
      GoRoute(
        path: RouteNames.lawyerPrfoileScreen,
        name: RouteNames.lawyerPrfoileScreen,
        builder: (context, state) => const self_profile.LawyerProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.lawyerSettingsScreen,
        name: RouteNames.lawyerSettingsScreen,
        builder: (context, state) => const LawyerSettingsScreen(),
      ),

      // Student's screen
      GoRoute(
        path: RouteNames.studentSignupScreen,
        name: RouteNames.studentSignupScreen,
        builder: (context, state) => StudentSignupScreen(),
      ),
      GoRoute(
        path: RouteNames.studentLoginScreen,
        name: RouteNames.studentLoginScreen,
        builder: (context, state) => StudentLoginScreen(),
      ),
      GoRoute(
        path: RouteNames.studentBottomNavigationScreen,
        name: RouteNames.studentBottomNavigationScreen,
        builder: (context, state) => const StudentBottomNavigationScreen(),
      ),
      GoRoute(
        path: RouteNames.studentDashboardScreen,
        name: RouteNames.studentDashboardScreen,
        builder: (context, state) => const StudentDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.certificationScreen,
        name: RouteNames.certificationScreen,
        builder: (context, state) => const CertificationScreen(),
      ),
      GoRoute(
        path: RouteNames.certificationDetailScreen,
        name: RouteNames.certificationDetailScreen,
        builder: (context, state) {
          final certDetail = state.extra as CertificationModel;
          return CertificationDetailScreen(certification: certDetail);
        },
      ),
      GoRoute(
        path: RouteNames.tasksScreen,
        name: RouteNames.tasksScreen,
        builder: (context, state) => const TasksScreen(),
      ),
      GoRoute(
        path: RouteNames.researchScreen,
        name: RouteNames.researchScreen,
        builder: (context, state) => const ResearchScreen(),
      ),
      GoRoute(
        path: RouteNames.studentProfileScreen,
        name: RouteNames.studentProfileScreen,
        builder: (context, state) => const StudentProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.studentSettingsScreen,
        name: RouteNames.studentSettingsScreen,
        builder: (context, state) => const StudentSettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.helpSupportScreen,
        name: RouteNames.helpSupportScreen,
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: RouteNames.internshipScreen,
        name: RouteNames.internshipScreen,
        builder: (context, state) => const InternshipScreen(),
      ),
      GoRoute(
        path: RouteNames.internshipDetailScreen,
        name: RouteNames.internshipDetailScreen,
        builder: (context, state) {
          final internship = state.extra as InternshipModel;
          return InternshipDetailScreen(internship: internship);
        },
      ),
      GoRoute(
        path: RouteNames.programsScreen,
        name: RouteNames.programsScreen,
        builder: (context, state) => const ProgramsScreen(),
      ),
    ],
  );
}

