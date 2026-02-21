import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_appbar.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class InternshipModel {
  final String id;
  final String title;
  final String company;
  final String location;
  final String duration;
  final String stipend;
  final String description;
  final List<String> requirements;
  final String postedDate;

  InternshipModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.duration,
    required this.stipend,
    required this.description,
    required this.requirements,
    required this.postedDate,
  });
}

class InternshipScreen extends ConsumerStatefulWidget {
  const InternshipScreen({super.key});

  @override
  ConsumerState<InternshipScreen> createState() => _InternshipScreenState();
}

class _InternshipScreenState extends ConsumerState<InternshipScreen> {
  // Mock data for internships
  final List<InternshipModel> internships = [
    InternshipModel(
      id: '1',
      title: 'Software Development Intern',
      company: 'Tech Corp',
      location: 'San Francisco, CA',
      duration: '3 months',
      stipend: '\$2000/month',
      description: 'Join our engineering team to work on cutting-edge web applications using modern technologies like React, Node.js, and cloud platforms.',
      requirements: [
        'Currently pursuing a degree in Computer Science or related field',
        'Strong programming skills in JavaScript/TypeScript',
        'Experience with React or similar frameworks',
        'Good problem-solving abilities',
        'Excellent communication skills'
      ],
      postedDate: '2024-02-01',
    ),
    InternshipModel(
      id: '2',
      title: 'Data Science Intern',
      company: 'Data Analytics Inc',
      location: 'New York, NY',
      duration: '6 months',
      stipend: '\$2500/month',
      description: 'Work with our data science team to analyze large datasets, build machine learning models, and create data visualizations.',
      requirements: [
        'Currently enrolled in a graduate program',
        'Strong background in statistics and mathematics',
        'Proficiency in Python and R',
        'Experience with machine learning frameworks',
        'Knowledge of SQL and data visualization tools'
      ],
      postedDate: '2024-02-05',
    ),
    InternshipModel(
      id: '3',
      title: 'Mobile App Development Intern',
      company: 'App Studio',
      location: 'Remote',
      duration: '4 months',
      stipend: '\$1800/month',
      description: 'Help design and develop mobile applications for iOS and Android platforms using Flutter and React Native.',
      requirements: [
        'Computer Science or Engineering student',
        'Experience with mobile app development',
        'Knowledge of Flutter or React Native',
        'Understanding of mobile UI/UX principles',
        'Ability to work independently'
      ],
      postedDate: '2024-02-08',
    ),
  ];

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
                    title: "Internships",
                    color: AppColors.kTextPrimary,
                    fontSize: 26.sp,
                    weight: FontWeight.w800,
                  ),
                  SizedBox(height: 0.4.h),
                  CustomText(
                    title: "Find exciting internship opportunities",
                    color: AppColors.kTextSecondary,
                    fontSize: 15.sp,
                  ),
                  SizedBox(height: 3.h),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                itemCount: internships.length,
                itemBuilder: (context, index) {
                  final internship = internships[index];
                  return _buildInternshipCard(internship);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInternshipCard(InternshipModel internship) {
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
                builder: (context) => InternshipDetailScreen(internship: internship),
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
                        color: AppColors.kEmerald.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.business_center,
                        color: AppColors.kEmerald,
                        size: 6.w,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: internship.title,
                            fontSize: 16.sp,
                            weight: FontWeight.w600,
                            color: AppColors.kTextPrimary,
                          ),
                          CustomText(
                            title: internship.company,
                            fontSize: 14.sp,
                            color: AppColors.kEmerald,
                            weight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: AppColors.kEmerald),
                    SizedBox(width: 1.w),
                    CustomText(
                      title: internship.location,
                      fontSize: 12.sp,
                      color: AppColors.kTextSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.schedule, size: 14, color: AppColors.kEmerald),
                    SizedBox(width: 1.w),
                    CustomText(
                      title: internship.duration,
                      fontSize: 12.sp,
                      color: AppColors.kTextSecondary,
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Icon(Icons.attach_money, size: 14, color: AppColors.kEmerald),
                    SizedBox(width: 1.w),
                    CustomText(
                      title: internship.stipend,
                      fontSize: 12.sp,
                      color: AppColors.kTextSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.calendar_today, size: 14, color: AppColors.kEmerald),
                    SizedBox(width: 1.w),
                    CustomText(
                      title: "Posted: ${internship.postedDate}",
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

class InternshipDetailScreen extends StatefulWidget {
  final InternshipModel internship;

  const InternshipDetailScreen({super.key, required this.internship});

  @override
  State<InternshipDetailScreen> createState() => _InternshipDetailScreenState();
}

class _InternshipDetailScreenState extends State<InternshipDetailScreen> {
  String? _cvFilePath;

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
          widget.internship.title,
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
                            color: AppColors.kEmerald.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.business_center,
                            color: AppColors.kEmerald,
                            size: 8.w,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                title: widget.internship.title,
                                fontSize: 20.sp,
                                weight: FontWeight.w700,
                                color: AppColors.kTextPrimary,
                              ),
                              CustomText(
                                title: widget.internship.company,
                                fontSize: 16.sp,
                                weight: FontWeight.w600,
                                color: AppColors.kEmerald,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    _buildDetailRow("Location", widget.internship.location, Icons.location_on),
                    _buildDetailRow("Duration", widget.internship.duration, Icons.schedule),
                    _buildDetailRow("Stipend", widget.internship.stipend, Icons.attach_money),
                    _buildDetailRow("Posted Date", widget.internship.postedDate, Icons.calendar_today),
                  ],
                ),
              ),
              SizedBox(height: 3.h),

              // Description
              _buildSectionCard("Description", Icons.description, [
                CustomText(
                  title: widget.internship.description,
                  fontSize: 14.sp,
                  color: AppColors.kTextSecondary,
                ),
              ]),
              SizedBox(height: 2.h),

              // Requirements
              _buildSectionCard("Requirements", Icons.list, [
                ...widget.internship.requirements.map((requirement) => Padding(
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
                          title: requirement,
                          fontSize: 14.sp,
                          color: AppColors.kTextSecondary,
                        ),
                      ),
                    ],
                  ),
                )),
              ]),
              SizedBox(height: 3.h),

              // CV Upload Section
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
                        Icon(Icons.upload_file, color: AppColors.kEmerald, size: 6.w),
                        SizedBox(width: 2.w),
                        CustomText(
                          title: "Upload CV",
                          fontSize: 16.sp,
                          weight: FontWeight.w600,
                          color: AppColors.kTextPrimary,
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    if (_cvFilePath != null) ...[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppColors.kEmerald.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.kEmerald.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.description, color: AppColors.kEmerald, size: 20),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: CustomText(
                                title: _cvFilePath!.split('/').last,
                                fontSize: 12.sp,
                                color: AppColors.kTextPrimary,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _cvFilePath = null;
                                });
                              },
                              icon: Icon(Icons.close, color: Colors.redAccent, size: 20),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      CustomButton(
                        text: "Choose CV File",
                        onPressed: _pickCVFile,
                        fontSize: 14.sp,
                        textColor: Colors.white,
                        backgroundColor: AppColors.kEmerald,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 3.h),

              // Apply Button
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _cvFilePath != null ? _applyForInternship : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _cvFilePath != null ? AppColors.kEmerald : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Apply for Internship",
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

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.kEmerald),
          SizedBox(width: 2.w),
          CustomText(
            title: "$label:",
            fontSize: 14.sp,
            color: AppColors.kTextSecondary,
            weight: FontWeight.w500,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: CustomText(
              title: value,
              fontSize: 14.sp,
              weight: FontWeight.w600,
              color: AppColors.kTextPrimary,
            ),
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

  Future<void> _pickCVFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _cvFilePath = result.files.single.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _applyForInternship() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kSurface.withOpacity(0.96),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Apply for Internship',
          style: TextStyle(
            color: AppColors.kTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Are you sure you want to apply for ${widget.internship.title} at ${widget.internship.company}?',
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
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Application submitted successfully!'),
                  backgroundColor: AppColors.kEmerald,
                ),
              );
              // Navigate back
              Navigator.pop(context);
            },
            child: Text(
              'Apply',
              style: TextStyle(color: AppColors.kEmerald),
            ),
          ),
        ],
      ),
    );
  }
}
