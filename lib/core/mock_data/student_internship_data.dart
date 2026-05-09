import 'package:lawyer_app/features/student/data/models/internship_model/internship_model.dart';

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
