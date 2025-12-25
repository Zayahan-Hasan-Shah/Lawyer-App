import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/routing/route_names.dart';

List<Map<String, dynamic>> incomingUserData = [
  {
    "id": 1,
    "icon": Icons.person,
    "title": "Student",
    "description": "Enrolled as Student for \ncertification",
    "onTap": (WidgetRef ref, BuildContext context) {},
  },
  {
    "id": 2,
    "icon": Icons.person,
    "title": "Client",
    "description": "Hire professional \nLawyers",
    "onTap": (WidgetRef ref, BuildContext context) {
      context.go(RouteNames.signupScreen);
    },
  },
  {
    "id": 3,
    "icon": Icons.person,
    "title": "Lawyer",
    "description": "Subscribe as a \nLawyer",
    "onTap": (WidgetRef ref, BuildContext context) {},
  },
  {
    "id": 4,
    "icon": Icons.person,
    "title": "Donate",
    "description": "Donate to \nCharity",
    "onTap": (WidgetRef ref, BuildContext context) {},
  },
];
