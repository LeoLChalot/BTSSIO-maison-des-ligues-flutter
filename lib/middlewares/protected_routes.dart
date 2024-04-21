import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_services.dart';
import '../utils/navigation.dart';

class ProtectedRoutes extends GetMiddleware {
  final authService = Get.find<AuthService>();

  @override
  RouteSettings? redirect(String? route) {
    return authService.isPremium.value == true
        ? null
        : const RouteSettings(name: Routes.loginPage);
  }
}
