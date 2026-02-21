import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_appbar.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class ProgramModel {
  final String id;
  final String title;
  final String description;
  final String duration;
  final String price;
  final String level;
  final String instructor;
  final List<String> topics;
  final bool isPaid;

  ProgramModel({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.price,
    required this.level,
    required this.instructor,
    required this.topics,
    required this.isPaid,
  });
}

class ProgramsScreen extends ConsumerStatefulWidget {
  const ProgramsScreen({super.key});

  @override
  ConsumerState<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends ConsumerState<ProgramsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data for paid programs
  final List<ProgramModel> paidPrograms = [
    ProgramModel(
      id: '1',
      title: 'Advanced Web Development Bootcamp',
      description: 'Master modern web development with React, Node.js, and cloud deployment',
      duration: '12 weeks',
      price: '\$299',
      level: 'Advanced',
      instructor: 'John Smith',
      isPaid: true,
      topics: ['React Advanced', 'Node.js', 'MongoDB', 'AWS Deployment', 'GraphQL'],
    ),
    ProgramModel(
      id: '2',
      title: 'Machine Learning Engineering',
      description: 'Complete ML engineering program from basics to production deployment',
      duration: '16 weeks',
      price: '\$499',
      level: 'Intermediate',
      instructor: 'Dr. Sarah Johnson',
      isPaid: true,
      topics: ['Python ML', 'TensorFlow', 'MLOps', 'Model Deployment', 'Data Engineering'],
    ),
    ProgramModel(
      id: '3',
      title: 'Mobile App Development Masterclass',
      description: 'Build professional mobile apps for iOS and Android',
      duration: '10 weeks',
      price: '\$199',
      level: 'Intermediate',
      instructor: 'Mike Chen',
      isPaid: true,
      topics: ['Flutter', 'React Native', 'State Management', 'API Integration', 'App Store Deployment'],
    ),
  ];

  // Mock data for free programs
  final List<ProgramModel> freePrograms = [
    ProgramModel(
      id: '4',
      title: 'Introduction to Programming',
      description: 'Learn programming fundamentals with Python',
      duration: '6 weeks',
      price: 'Free',
      level: 'Beginner',
      instructor: 'Emily Davis',
      isPaid: false,
      topics: ['Python Basics', 'Data Types', 'Control Flow', 'Functions', 'Basic OOP'],
    ),
    ProgramModel(
      id: '5',
      title: 'Web Development Basics',
      description: 'Start your journey in web development',
      duration: '8 weeks',
      price: 'Free',
      level: 'Beginner',
      instructor: 'Alex Wilson',
      isPaid: false,
      topics: ['HTML5', 'CSS3', 'JavaScript Basics', 'DOM Manipulation', 'Responsive Design'],
    ),
    ProgramModel(
      id: '6',
      title: 'Data Science Fundamentals',
      description: 'Introduction to data science and analytics',
      duration: '4 weeks',
      price: 'Free',
      level: 'Beginner',
      instructor: 'Dr. Lisa Brown',
      isPaid: false,
      topics: ['Data Analysis', 'Statistics', 'Python for Data Science', 'Data Visualization', 'Basic ML'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0D1117),
            Color(0xFF0A1F24),
            Color(0xFF08151A),
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppbar(
              logoImage: AppAssets.logoImage,
              backgroundColor: Colors.transparent,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  CustomText(
                    title: "Learning Programs",
                    color: AppColors.kTextPrimary,
                    fontSize: 26.sp,
                    weight: FontWeight.w800,
                  ),
                  SizedBox(height: 0.4.h),
                  CustomText(
                    title: "Expand your knowledge with our comprehensive programs",
                    color: AppColors.kTextSecondary,
                    fontSize: 15.sp,
                  ),
                  SizedBox(height: 3.h),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 6.w),
              decoration: BoxDecoration(
                color: AppColors.kSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.kEmerald.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: AppColors.kEmerald,
                unselectedLabelColor: AppColors.kTextSecondary,
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.video_library, size: 18),
                        SizedBox(width: 1.w),
                        Text('Paid Programs'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.card_giftcard, size: 18),
                        SizedBox(width: 1.w),
                        Text('Free Programs'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildProgramsList(paidPrograms, true),
                  _buildProgramsList(freePrograms, false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramsList(List<ProgramModel> programs, bool isPaid) {
    if (programs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 12.h,
              color: AppColors.kTextSecondary,
            ),
            SizedBox(height: 2.h),
            CustomText(
              title: "No programs available",
              fontSize: 18.sp,
              color: AppColors.kTextPrimary,
              weight: FontWeight.w600,
            ),
            SizedBox(height: 1.h),
            CustomText(
              title: "Check back later for new programs",
              fontSize: 14.sp,
              color: AppColors.kTextSecondary,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      itemCount: programs.length,
      itemBuilder: (context, index) {
        final program = programs[index];
        return _buildProgramCard(program);
      },
    );
  }

  Widget _buildProgramCard(ProgramModel program) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.kSurface.withOpacity(0.8),
            AppColors.kSurfaceElevated.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.kEmerald.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProgramDetailScreen(program: program),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: program.isPaid 
                            ? Colors.orangeAccent.withOpacity(0.2)
                            : AppColors.kEmerald.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        program.isPaid ? Icons.star : Icons.card_giftcard,
                        color: program.isPaid ? Colors.orangeAccent : AppColors.kEmerald,
                        size: 6.w,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: program.title,
                            fontSize: 16.sp,
                            weight: FontWeight.w600,
                            color: AppColors.kTextPrimary,
                          ),
                          CustomText(
                            title: program.instructor,
                            fontSize: 12.sp,
                            color: AppColors.kTextSecondary,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: program.isPaid 
                            ? Colors.orangeAccent.withOpacity(0.2)
                            : AppColors.kEmerald.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomText(
                        title: program.price,
                        fontSize: 12.sp,
                        color: program.isPaid ? Colors.orangeAccent : AppColors.kEmerald,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                CustomText(
                  title: program.description,
                  fontSize: 14.sp,
                  color: AppColors.kTextSecondary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: AppColors.kEmerald),
                    SizedBox(width: 1.w),
                    CustomText(
                      title: program.duration,
                      fontSize: 12.sp,
                      color: AppColors.kTextSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.signal_cellular_alt, size: 14, color: AppColors.kEmerald),
                    SizedBox(width: 1.w),
                    CustomText(
                      title: program.level,
                      fontSize: 12.sp,
                      color: AppColors.kTextSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProgramDetailScreen extends StatelessWidget {
  final ProgramModel program;

  const ProgramDetailScreen({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.kTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          program.title,
          style: TextStyle(
            color: AppColors.kTextPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D1117),
              Color(0xFF0A1F24),
              Color(0xFF08151A),
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.kSurface.withOpacity(0.8),
                      AppColors.kSurfaceElevated.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.kEmerald.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: program.isPaid 
                                ? Colors.orangeAccent.withOpacity(0.2)
                                : AppColors.kEmerald.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            program.isPaid ? Icons.star : Icons.card_giftcard,
                            color: program.isPaid ? Colors.orangeAccent : AppColors.kEmerald,
                            size: 8.w,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                title: program.title,
                                fontSize: 20.sp,
                                weight: FontWeight.w700,
                                color: AppColors.kTextPrimary,
                              ),
                              CustomText(
                                title: "Instructor: ${program.instructor}",
                                fontSize: 14.sp,
                                color: AppColors.kTextSecondary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                            "Duration",
                            program.duration,
                            Icons.schedule,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: _buildDetailItem(
                            "Level",
                            program.level,
                            Icons.signal_cellular_alt,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    _buildDetailItem(
                      "Price",
                      program.price,
                      program.isPaid ? Icons.attach_money : Icons.card_giftcard,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),

              // Description
              _buildSectionCard("Description", Icons.description, [
                CustomText(
                  title: program.description,
                  fontSize: 14.sp,
                  color: AppColors.kTextSecondary,
                ),
              ]),
              SizedBox(height: 2.h),

              // Topics
              _buildSectionCard("Topics Covered", Icons.topic, [
                ...program.topics.map((topic) => Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: AppColors.kEmerald,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: CustomText(
                          title: topic,
                          fontSize: 14.sp,
                          color: AppColors.kTextSecondary,
                        ),
                      ),
                    ],
                  ),
                )),
              ]),
              SizedBox(height: 3.h),

              // Apply Button
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _applyForProgram(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: program.isPaid ? Colors.orangeAccent : AppColors.kEmerald,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    program.isPaid ? "Enroll Now" : "Start Learning",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppColors.kSurface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.kEmerald),
              SizedBox(width: 1.w),
              CustomText(
                title: label,
                fontSize: 12.sp,
                color: AppColors.kTextSecondary,
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          CustomText(
            title: value,
            fontSize: 14.sp,
            weight: FontWeight.w600,
            color: AppColors.kTextPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.kSurface.withOpacity(0.8),
            AppColors.kSurfaceElevated.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.kEmerald.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.kEmerald, size: 6.w),
              SizedBox(width: 2.w),
              CustomText(
                title: title,
                fontSize: 16.sp,
                weight: FontWeight.w600,
                color: AppColors.kTextPrimary,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ...children,
        ],
      ),
    );
  }

  void _applyForProgram(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kSurface.withOpacity(0.96),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          program.isPaid ? 'Enroll in Program' : 'Start Learning',
          style: TextStyle(
            color: AppColors.kTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          program.isPaid 
              ? 'Are you sure you want to enroll in ${program.title} for ${program.price}?'
              : 'Are you sure you want to start learning ${program.title}?',
          style: TextStyle(color: AppColors.kTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.kTextSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    program.isPaid 
                        ? 'Successfully enrolled in ${program.title}!'
                        : 'Started learning ${program.title}!',
                  ),
                  backgroundColor: program.isPaid ? Colors.orangeAccent : AppColors.kEmerald,
                ),
              );
            },
            child: Text(
              program.isPaid ? 'Enroll' : 'Start',
              style: TextStyle(color: program.isPaid ? Colors.orangeAccent : AppColors.kEmerald),
            ),
          ),
        ],
      ),
    );
  }
}
