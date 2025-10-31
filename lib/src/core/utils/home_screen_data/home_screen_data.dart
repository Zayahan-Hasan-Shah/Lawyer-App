import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';

List<Map<String, dynamic>> homeScreenData = [
  {
    "id": 1,
    "case": "Pending Case",
    "laywer_type": "Criminal Lawyers",
    "location": "Karachi, Pakistan",
    "image": AppAssets.criminalLawyerImage,
    "onTap": (WidgetRef ref, BuildContext context) {},
  },
  {
    "id": 2,
    "case": "Case",
    "laywer_type": "Civil Lawyers",
    "location": "Hyderabad, Pakistan",
    "image": AppAssets.civilLawyerImage,
    "onTap": (WidgetRef ref, BuildContext context) {},
  },
  {
    "id": 3,
    "case": "Pending Case",
    "laywer_type": "Family Lawyers",
    "location": "Thatta, Pakistan",
    "image": AppAssets.familyLawyerImage,
    "onTap": (WidgetRef ref, BuildContext context) {},
  },
  {
    "id": 4,
    "case": "Case",
    "laywer_type": "Tax Lawyers",
    "location": "Karachi, Pakistan",
    "image": AppAssets.taxLawyerImage,
    "onTap": (WidgetRef ref, BuildContext context) {},
  },
  {
    "id": 5,
    "case": "Case",
    "laywer_type": "Immigration Lawyers",
    "location": "Larkana, Pakistan",
    "image": AppAssets.immigrationLawyerImage,
    "onTap": (WidgetRef ref, BuildContext context) {},
  },
  {
    "id": 6,
    "case": "Pending Case",
    "laywer_type": "Business Lawyers",
    "location": "Karachi, Pakistan",
    "image": AppAssets.businessLawyerImage,
    "onTap": (WidgetRef ref, BuildContext context) {},
  },
];
