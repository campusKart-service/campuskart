import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/campus_verification/campus_verification.dart';
import '../presentation/product_detail/product_detail.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/product_listing/product_listing.dart';
import '../presentation/signup_screen/signup_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String signupScreen = '/signup-screen';
  static const String campusVerification = '/campus-verification';
  static const String productDetail = '/product-detail';
  static const String homeScreen = '/home-screen';
  static const String userProfile = '/user-profile';
  static const String productListing = '/product-listing';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => LoginScreen(),
    loginScreen: (context) => LoginScreen(),
    signupScreen: (context) => SignupScreen(),
    campusVerification: (context) => CampusVerification(),
    productDetail: (context) => ProductDetail(),
    homeScreen: (context) => HomeScreen(),
    userProfile: (context) => UserProfile(),
    productListing: (context) => ProductListing(),
    // TODO: Add your other routes here
  };
}
