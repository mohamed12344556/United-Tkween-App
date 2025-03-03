import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;

  // @POST(ApiConstants.signup)
  // Future<AuthResponse> signup(@Body() AuthRequest request);

}

//! command to run the service file generator
//? flutter pub run build_runner build --delete-conflicting-outputs
