// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `About`
  String get about {
    return Intl.message('About', name: 'about', desc: '', args: []);
  }

  /// `Account created successfully!`
  String get account_created_successfully {
    return Intl.message(
      'Account created successfully!',
      name: 'account_created_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `Address is required`
  String get address_is_required {
    return Intl.message(
      'Address is required',
      name: 'address_is_required',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get already_have_an_account {
    return Intl.message(
      'Already have an account?',
      name: 'already_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Animation`
  String get animation {
    return Intl.message('Animation', name: 'animation', desc: '', args: []);
  }

  /// `Are you sure you want to logout?`
  String get are_you_sure_you_want_to_logout {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'are_you_sure_you_want_to_logout',
      desc: '',
      args: [],
    );
  }

  /// `Audio`
  String get audio {
    return Intl.message('Audio', name: 'audio', desc: '', args: []);
  }

  /// `Back to Login`
  String get back_to_login {
    return Intl.message(
      'Back to Login',
      name: 'back_to_login',
      desc: '',
      args: [],
    );
  }

  /// `Browse as Guest`
  String get browse_as_guest {
    return Intl.message(
      'Browse as Guest',
      name: 'browse_as_guest',
      desc: '',
      args: [],
    );
  }

  /// `Business & Management`
  String get business_and_management {
    return Intl.message(
      'Business & Management',
      name: 'business_and_management',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Cancelled`
  String get cancelled {
    return Intl.message('Cancelled', name: 'cancelled', desc: '', args: []);
  }

  /// `Change Password`
  String get change_password {
    return Intl.message(
      'Change Password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get confirm_new_password {
    return Intl.message(
      'Confirm New Password',
      name: 'confirm_new_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password is required`
  String get confirm_password_is_required {
    return Intl.message(
      'Confirm password is required',
      name: 'confirm_password_is_required',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continue1 {
    return Intl.message('Continue', name: 'continue1', desc: '', args: []);
  }

  /// `Continue with Apple`
  String get continue_with_apple {
    return Intl.message(
      'Continue with Apple',
      name: 'continue_with_apple',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Facebook`
  String get continue_with_facebook {
    return Intl.message(
      'Continue with Facebook',
      name: 'continue_with_facebook',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Google`
  String get continue_with_google {
    return Intl.message(
      'Continue with Google',
      name: 'continue_with_google',
      desc: '',
      args: [],
    );
  }

  /// `Create a new password for your account`
  String get create_a_new_password_for_your_account {
    return Intl.message(
      'Create a new password for your account',
      name: 'create_a_new_password_for_your_account',
      desc: '',
      args: [],
    );
  }

  /// `Create an account`
  String get create_account {
    return Intl.message(
      'Create an account',
      name: 'create_account',
      desc: '',
      args: [],
    );
  }

  /// `Create an Account`
  String get create_an_account {
    return Intl.message(
      'Create an Account',
      name: 'create_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Create your account; it takes less than a minute. Enter your email and password`
  String
  get create_your_account_it_takes_less_than_a_minute_enter_your_email_and_password {
    return Intl.message(
      'Create your account; it takes less than a minute. Enter your email and password',
      name:
          'create_your_account_it_takes_less_than_a_minute_enter_your_email_and_password',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get dark_mode {
    return Intl.message('Dark Mode', name: 'dark_mode', desc: '', args: []);
  }

  /// `Delivered`
  String get delivered {
    return Intl.message('Delivered', name: 'delivered', desc: '', args: []);
  }

  /// `Didn't receive code?`
  String get didnt_receive_code {
    return Intl.message(
      'Didn\'t receive code?',
      name: 'didnt_receive_code',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get download {
    return Intl.message('Download', name: 'download', desc: '', args: []);
  }

  /// `Edit Profile`
  String get edit_profile {
    return Intl.message(
      'Edit Profile',
      name: 'edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Email is required`
  String get email_is_required {
    return Intl.message(
      'Email is required',
      name: 'email_is_required',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address and we'll send you a link to reset your password`
  String
  get enter_your_email_address_and_we_will_send_you_a_link_to_reset_your_password {
    return Intl.message(
      'Enter your email address and we\'ll send you a link to reset your password',
      name:
          'enter_your_email_address_and_we_will_send_you_a_link_to_reset_your_password',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address to reset your password`
  String get enter_your_email_address_to_reset_your_password {
    return Intl.message(
      'Enter your email address to reset your password',
      name: 'enter_your_email_address_to_reset_your_password',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Error loading library`
  String get error_loading_library {
    return Intl.message(
      'Error loading library',
      name: 'error_loading_library',
      desc: '',
      args: [],
    );
  }

  /// `Error loading orders`
  String get error_loading_orders {
    return Intl.message(
      'Error loading orders',
      name: 'error_loading_orders',
      desc: '',
      args: [],
    );
  }

  /// `Error loading profile`
  String get error_loading_profile {
    return Intl.message(
      'Error loading profile',
      name: 'error_loading_profile',
      desc: '',
      args: [],
    );
  }

  /// `Error sending message`
  String get error_sending_message {
    return Intl.message(
      'Error sending message',
      name: 'error_sending_message',
      desc: '',
      args: [],
    );
  }

  /// `Error updating profile`
  String get error_updating_profile {
    return Intl.message(
      'Error updating profile',
      name: 'error_updating_profile',
      desc: '',
      args: [],
    );
  }

  /// `Explore Courses`
  String get explore_courses {
    return Intl.message(
      'Explore Courses',
      name: 'explore_courses',
      desc: '',
      args: [],
    );
  }

  /// `File Type`
  String get file_type {
    return Intl.message('File Type', name: 'file_type', desc: '', args: []);
  }

  /// `Film & Video`
  String get film_and_video {
    return Intl.message(
      'Film & Video',
      name: 'film_and_video',
      desc: '',
      args: [],
    );
  }

  /// `Fine Art`
  String get fine_art {
    return Intl.message('Fine Art', name: 'fine_art', desc: '', args: []);
  }

  /// `Forgot password?`
  String get forgot_password {
    return Intl.message(
      'Forgot password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get forgot_password_title {
    return Intl.message(
      'Forgot Password',
      name: 'forgot_password_title',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get full_name {
    return Intl.message('Full Name', name: 'full_name', desc: '', args: []);
  }

  /// `Get Verification Code`
  String get get_verification_code {
    return Intl.message(
      'Get Verification Code',
      name: 'get_verification_code',
      desc: '',
      args: [],
    );
  }

  /// `Got it`
  String get got_it {
    return Intl.message('Got it', name: 'got_it', desc: '', args: []);
  }

  /// `Graphic Design`
  String get graphic_design {
    return Intl.message(
      'Graphic Design',
      name: 'graphic_design',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get hello {
    return Intl.message('Hello', name: 'hello', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `How Can We Help You?`
  String get how_can_we_help_you {
    return Intl.message(
      'How Can We Help You?',
      name: 'how_can_we_help_you',
      desc: '',
      args: [],
    );
  }

  /// `Illustration`
  String get illustration {
    return Intl.message(
      'Illustration',
      name: 'illustration',
      desc: '',
      args: [],
    );
  }

  /// `Image`
  String get image {
    return Intl.message('Image', name: 'image', desc: '', args: []);
  }

  /// `In Progress`
  String get in_progress {
    return Intl.message('In Progress', name: 'in_progress', desc: '', args: []);
  }

  /// `Invalid email address`
  String get invalid_email_address {
    return Intl.message(
      'Invalid email address',
      name: 'invalid_email_address',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Lifestyle`
  String get lifestyle {
    return Intl.message('Lifestyle', name: 'lifestyle', desc: '', args: []);
  }

  /// `Light Mode`
  String get light_mode {
    return Intl.message('Light Mode', name: 'light_mode', desc: '', args: []);
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Log In`
  String get log_in {
    return Intl.message('Log In', name: 'log_in', desc: '', args: []);
  }

  /// `Login successful!`
  String get login_successful {
    return Intl.message(
      'Login successful!',
      name: 'login_successful',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Main Store`
  String get main_store {
    return Intl.message('Main Store', name: 'main_store', desc: '', args: []);
  }

  /// `Marketing`
  String get marketing {
    return Intl.message('Marketing', name: 'marketing', desc: '', args: []);
  }

  /// `Your message has been sent successfully`
  String get message_sent_successfully {
    return Intl.message(
      'Your message has been sent successfully',
      name: 'message_sent_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Music`
  String get music {
    return Intl.message('Music', name: 'music', desc: '', args: []);
  }

  /// `My Library`
  String get my_library {
    return Intl.message('My Library', name: 'my_library', desc: '', args: []);
  }

  /// `My Orders`
  String get my_orders {
    return Intl.message('My Orders', name: 'my_orders', desc: '', args: []);
  }

  /// `Name is required`
  String get name_is_required {
    return Intl.message(
      'Name is required',
      name: 'name_is_required',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get new_password {
    return Intl.message(
      'New Password',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `No library items found`
  String get no_library_items {
    return Intl.message(
      'No library items found',
      name: 'no_library_items',
      desc: '',
      args: [],
    );
  }

  /// `No orders found`
  String get no_orders {
    return Intl.message(
      'No orders found',
      name: 'no_orders',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get or {
    return Intl.message('or', name: 'or', desc: '', args: []);
  }

  /// `Order Date`
  String get order_date {
    return Intl.message('Order Date', name: 'order_date', desc: '', args: []);
  }

  /// `OTP resent successfully!`
  String get otp_resent_successfully {
    return Intl.message(
      'OTP resent successfully!',
      name: 'otp_resent_successfully',
      desc: '',
      args: [],
    );
  }

  /// `OTP sent successfully!`
  String get otp_sent_successfully {
    return Intl.message(
      'OTP sent successfully!',
      name: 'otp_sent_successfully',
      desc: '',
      args: [],
    );
  }

  /// `OTP verified successfully!`
  String get otp_verified_successfully {
    return Intl.message(
      'OTP verified successfully!',
      name: 'otp_verified_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Paper`
  String get paper {
    return Intl.message('Paper', name: 'paper', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Password is required`
  String get password_is_required {
    return Intl.message(
      'Password is required',
      name: 'password_is_required',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters long`
  String get password_must_be_at_least_6_characters_long {
    return Intl.message(
      'Password must be at least 6 characters long',
      name: 'password_must_be_at_least_6_characters_long',
      desc: '',
      args: [],
    );
  }

  /// `Password reset successful!`
  String get password_reset_successful {
    return Intl.message(
      'Password reset successful!',
      name: 'password_reset_successful',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwords_do_not_match {
    return Intl.message(
      'Passwords do not match',
      name: 'passwords_do_not_match',
      desc: '',
      args: [],
    );
  }

  /// `PDF`
  String get pdf {
    return Intl.message('PDF', name: 'pdf', desc: '', args: []);
  }

  /// `Phone`
  String get phone {
    return Intl.message('Phone', name: 'phone', desc: '', args: []);
  }

  /// `Phone is required`
  String get phone_is_required {
    return Intl.message(
      'Phone is required',
      name: 'phone_is_required',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number 1`
  String get phone_number_1 {
    return Intl.message(
      'Phone Number 1',
      name: 'phone_number_1',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number 2 (Optional)`
  String get phone_number_2 {
    return Intl.message(
      'Phone Number 2 (Optional)',
      name: 'phone_number_2',
      desc: '',
      args: [],
    );
  }

  /// `Photography`
  String get photography {
    return Intl.message('Photography', name: 'photography', desc: '', args: []);
  }

  /// `Please enter the 4-digit code sent to your email address`
  String get please_enter_the_4_digit_code_sent_to_your_email_address {
    return Intl.message(
      'Please enter the 4-digit code sent to your email address',
      name: 'please_enter_the_4_digit_code_sent_to_your_email_address',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid OTP`
  String get please_enter_valid_otp {
    return Intl.message(
      'Please enter valid OTP',
      name: 'please_enter_valid_otp',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one option`
  String get please_select_at_least_one_option {
    return Intl.message(
      'Please select at least one option',
      name: 'please_select_at_least_one_option',
      desc: '',
      args: [],
    );
  }

  /// `Previous`
  String get previous {
    return Intl.message('Previous', name: 'previous', desc: '', args: []);
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `Processing`
  String get processing {
    return Intl.message('Processing', name: 'processing', desc: '', args: []);
  }

  /// `Productivity`
  String get productivity {
    return Intl.message(
      'Productivity',
      name: 'productivity',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Profile`
  String get profile_title {
    return Intl.message('Profile', name: 'profile_title', desc: '', args: []);
  }

  /// `Resend`
  String get resend {
    return Intl.message('Resend', name: 'resend', desc: '', args: []);
  }

  /// `Reset Password`
  String get reset_password {
    return Intl.message(
      'Reset Password',
      name: 'reset_password',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Select your areas of courses you would like to learn`
  String get select_your_areas_of_courses_you_would_like_to_learn {
    return Intl.message(
      'Select your areas of courses you would like to learn',
      name: 'select_your_areas_of_courses_you_would_like_to_learn',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Shipped`
  String get shipped {
    return Intl.message('Shipped', name: 'shipped', desc: '', args: []);
  }

  /// `Something went wrong, please try again`
  String get something_went_wrong_please_try_again {
    return Intl.message(
      'Something went wrong, please try again',
      name: 'something_went_wrong_please_try_again',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Store Support`
  String get store_support {
    return Intl.message(
      'Store Support',
      name: 'store_support',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message('Success', name: 'success', desc: '', args: []);
  }

  /// `test`
  String get test {
    return Intl.message('test', name: 'test', desc: '', args: []);
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `UI Design`
  String get ui_design {
    return Intl.message('UI Design', name: 'ui_design', desc: '', args: []);
  }

  /// `UX Design`
  String get ux_design {
    return Intl.message('UX Design', name: 'ux_design', desc: '', args: []);
  }

  /// `Verify`
  String get verify {
    return Intl.message('Verify', name: 'verify', desc: '', args: []);
  }

  /// `Verify Your Email`
  String get verify_your_email {
    return Intl.message(
      'Verify Your Email',
      name: 'verify_your_email',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get video {
    return Intl.message('Video', name: 'video', desc: '', args: []);
  }

  /// `Warning`
  String get warning {
    return Intl.message('Warning', name: 'warning', desc: '', args: []);
  }

  /// `We happy to see you here again. Enter your email address and password`
  String
  get we_happy_to_see_you_here_again_enter_your_email_address_and_password {
    return Intl.message(
      'We happy to see you here again. Enter your email address and password',
      name:
          'we_happy_to_see_you_here_again_enter_your_email_address_and_password',
      desc: '',
      args: [],
    );
  }

  /// `Web Development`
  String get web_development {
    return Intl.message(
      'Web Development',
      name: 'web_development',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back,`
  String get welcome_back {
    return Intl.message(
      'Welcome back,',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to our app`
  String get welcome_to_our_app {
    return Intl.message(
      'Welcome to our app',
      name: 'welcome_to_our_app',
      desc: '',
      args: [],
    );
  }

  /// `Welcome, User!`
  String get welcome_user {
    return Intl.message(
      'Welcome, User!',
      name: 'welcome_user',
      desc: '',
      args: [],
    );
  }

  /// `What do you want to learn?`
  String get what_do_you_want_to_learn {
    return Intl.message(
      'What do you want to learn?',
      name: 'what_do_you_want_to_learn',
      desc: '',
      args: [],
    );
  }

  /// `Write your message here...`
  String get write_your_message_here {
    return Intl.message(
      'Write your message here...',
      name: 'write_your_message_here',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
