import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

import 'api_routes.dart';
import 'data/api_user.dart';
import 'data/basic_response.dart';
import 'data/notification_settings.dart';
import 'data/user.dart';
import 'data/user_location.dart';
import 'data/user_response.dart';
import 'dio_setup.dart';

final dio = setupDio(ApiRoutes.user);
final logger = Logger();

class AccountApi {
  Future<UserResponse?> getUser(String email) async {
    try {
      Response response = await dio.get('${ApiRoutes.getUser}?email=$email');

      APIUser apiUser = APIUser.fromMap(response.data);
      if (apiUser.lastKnownLatitude != null &&
          apiUser.lastKnownLongitude != null) {
        Position position = Position(
          latitude: apiUser.lastKnownLatitude!,
          longitude: apiUser.lastKnownLongitude!,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );

        User user = User(
            id: apiUser.id,
            username: apiUser.username,
            email: apiUser.email,
            password: apiUser.password,
            notificationOptions: apiUser.notificationOptions,
            lastKnownLocation: position);
        return UserResponse(success: true, message: 'User found', user: user);
      } else {
        return UserResponse(
            success: true,
            message: 'User found',
            user: User(
                id: apiUser.id,
                username: apiUser.username,
                email: apiUser.email,
                password: apiUser.password,
                notificationOptions: apiUser.notificationOptions,
                lastKnownLocation: null));
      }
    } catch (e) {
      return UserResponse(
        success: false,
        message: 'User not found',
        user: null,
      );
    }
  }

  Future<BasicResponse> signUp(
    String username,
    String email,
    String password,
  ) async {
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      return BasicResponse(
          success: false, message: 'Please fill in all fields');
    }

    try {
      final response = await dio.post(
          '${ApiRoutes.signUp}?email=$email&username=$username&password=$password');
      return BasicResponse.fromJson(response.data);
    } catch (e) {
      return BasicResponse(success: false, message: e.toString());
    }
  }

  Future<BasicResponse> logIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return BasicResponse(
          success: false, message: 'Please fill in all fields');
    }

    try {
      final response =
          await dio.get('${ApiRoutes.logIn}?email=$email&password=$password');
      return BasicResponse.fromJson(response.data);
    } catch (e) {
      return BasicResponse(success: false, message: e.toString());
    }
  }

  Future<NotificationOptions?> getNotificationOptions(String email) async {
    try {
      final response =
          await dio.get('${ApiRoutes.getNotificationOptions}?email=$email');

      return NotificationOptions.fromMap(response.data);
    } catch (e) {
      logger.e('Error fetching notification options: $e');
      return null;
    }
  }

  Future<UserLocation?> getLastKnownLocation(String email) async {
    try {
      final response = await dio.get('${ApiRoutes.getLocation}?email=$email');

      return UserLocation.fromMap(response.data);
    } catch (e) {
      logger.e('Error fetching last known location: $e');
      return null;
    }
  }

  Future<BasicResponse> updateUserNotificationOptions(
    String email,
    bool pushNotificationsTurnedOn,
    bool emailNotificationsTurnedOn,
    bool locationServicesTurnedOn,
  ) async {
    try {
      final response = await dio.patch(
          '${ApiRoutes.updateNotificationOptions}?email=$email&pushNotificationsTurnedOn=$pushNotificationsTurnedOn&emailNotificationsTurnedOn=$emailNotificationsTurnedOn&locationServicesTurnedOn=$locationServicesTurnedOn');

      return BasicResponse.fromJson(response.data);
    } catch (e) {
      logger.e('Error updating notification options: $e');
      return BasicResponse(success: false, message: e.toString());
    }
  }

  Future<BasicResponse> updateUserLocation(
    String userEmail,
    Position? position,
  ) async {
    try {
      final response = await dio.patch(
          '${ApiRoutes.updateLocation}?email=$userEmail&latitude=${position!.latitude}&longitude=${position.longitude}');

      return BasicResponse.fromJson(response.data);
    } catch (e) {
      logger.e('Error updating user location: $e');
      return BasicResponse(success: false, message: e.toString());
    }
  }

  Future<BasicResponse> changePassword(String email, String newPassword) async {
    try {
      Response response = await dio.patch(
          '${ApiRoutes.updatePassword}?email=$email&newPassword=$newPassword');
      BasicResponse basicResponse = BasicResponse.fromJson(response.data);
      return basicResponse;
    } catch (e) {
      logger.e('Error changing password: $e');
      return BasicResponse(success: false, message: e.toString());
    }
  }

  Future<BasicResponse> changeUsername(String email, String newUsername) async {
    try {
      Response response = await dio.patch(
          '${ApiRoutes.updateUsername}?email=$email&newUsername=$newUsername');
      BasicResponse basicResponse = BasicResponse.fromJson(response.data);
      return basicResponse;
    } catch (e) {
      logger.e('Error changing username: $e');
      return BasicResponse(success: false, message: e.toString());
    }
  }

  Future<BasicResponse> changeEmail(String email, String newEmail) async {
    try {
      Response response = await dio
          .patch('${ApiRoutes.updateEmail}?email=$email&newEmail=$newEmail');
      BasicResponse basicResponse = BasicResponse.fromJson(response.data);
      return basicResponse;
    } catch (e) {
      logger.e('Error changing email: $e');
      return BasicResponse(success: false, message: e.toString());
    }
  }
}
