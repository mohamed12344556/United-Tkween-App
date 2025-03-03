import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:united_formation_app/features/auth/login/data/models/login_model.dart';

import '../core.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;

  @POST(ApiConstants.signup)
  Future<LoginModel> signup(@Body() LoginModel request);

}

//! command to run the service file generator
//? flutter pub run build_runner build --delete-conflicting-outputs
