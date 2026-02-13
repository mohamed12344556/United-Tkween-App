import 'package:hive_ce/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? fullName;

  @HiveField(3)
  final int? age;

  @HiveField(4)
  final String? job;

  @HiveField(5)
  final String? gender;

  @HiveField(6)
  final int? points;

  @HiveField(7)
  final String? email;

  @HiveField(8)
  final String? password;

  @HiveField(9)
  final String? profilePicture;

  @HiveField(10)
  final String? fbToken;

  @HiveField(11)
  final String? token;

  @HiveField(12)
  final String? privacy;

  @HiveField(13)
  final int? smLogin;

  @HiveField(14)
  final String? smToken;

  @HiveField(15)
  final String? googleId;

  @HiveField(16)
  final String? facebookId;

  @HiveField(17)
  final String? message;

  @HiveField(18)
  final String? birthday;

  @HiveField(19)
  final String? appleId;

  UserModel({
    this.id,
    this.name,
    this.fullName,
    this.age,
    this.job,
    this.gender,
    this.points,
    this.email,
    this.password,
    this.profilePicture,
    this.fbToken,
    this.token,
    this.privacy,
    this.smLogin,
    this.smToken,
    this.googleId,
    this.facebookId,
    this.message,
    this.appleId,
    this.birthday,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] != null ? json['id'] as int : null,
      name: json['name'] as String?,
      fullName: json['full_name'] as String?,
      age: json['age'] != null ? json['age'] as int : null,
      job: json['job'] as String?,
      gender: json['gender'] as String?,
      points: json['points'] != null ? json['points'] as int : null,
      email: json['email'] as String?,
      profilePicture: json['profile_picture'] as String?,
      fbToken: json['fb_token'] as String?,
      token: json['token'] as String?,
      privacy: json['privacy'] as String?,
      smLogin: json['sm_login'] != null ? json['sm_login'] as int : null,
      smToken: json['sm_token'] as String?,
      googleId: json['google_id'] as String?,
      facebookId: json['facebook_id'] as String?,
      appleId: json['apple_id'] as String?,
      birthday: json['birthday'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'full_name': fullName,
      'age': age,
      'job': job,
      'gender': gender,
      'points': points,
      'email': email,
      'profile_picture': profilePicture,
      'fb_token': fbToken,
      'token': token,
      'privacy': privacy,
      'sm_login': smLogin,
      'sm_token': smToken,
      'google_id': googleId,
      'facebook_id': facebookId,
      'apple_id': appleId,
      'birthday': birthday,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'UserLoginResponseModel(id: $id, name: $name, fullName: $fullName, age: $age, job: $job, gender: $gender, points: $points, email: $email, profilePicture: $profilePicture, fbToken: $fbToken, token: $token, privacy: $privacy, smLogin: $smLogin, smToken: $smToken, googleId: $googleId, facebookId: $facebookId,appleId:$appleId ,birthday $birthday , message: $message)';
  }
}