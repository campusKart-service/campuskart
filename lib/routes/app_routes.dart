import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/campus_verification/campus_verification.dart';
import '../presentation/product_detail/product_detail.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/product_listing/product_listing.dart';
import '../presentation/signup_screen/signup_screen.dart';
import '../presentation/chat_screen/chat_screen.dart';
import '../presentation/search_screen/search_screen.dart';
import '../presentation/messages_list_screen/messages_list_screen.dart';

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
  static const String chatScreen = '/chat-screen';
  static const String searchScreen = '/search-screen';
  static const String messagesListScreen = '/messages-list-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => LoginScreen(),
    loginScreen: (context) => LoginScreen(),
    signupScreen: (context) => SignupScreen(),
    campusVerification: (context) => CampusVerification(),
    productDetail: (context) => ProductDetail(),
    homeScreen: (context) => HomeScreen(),
    userProfile: (context) => UserProfile(),
    productListing: (context) => ProductListing(),
    chatScreen: (context) => const ChatScreen(),
    searchScreen: (context) => const SearchScreen(),
    messagesListScreen: (context) => const MessagesListScreen(),
    // TODO: Add your other routes here
  };
}
