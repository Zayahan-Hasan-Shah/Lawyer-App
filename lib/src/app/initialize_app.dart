import 'package:flutter/material.dart';
import 'package:lawyer_app/src/routing/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Lawyer',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
