import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/user.dart';

class AuthService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://localhost:5000/api/v1';

  // Register a new user
  Future<ApiResponse<Map<String, dynamic>>> register({
    required String username,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/register',
        data: {
          'username': username,
          'email': email,
          'password': password,
          'phone_number': phoneNumber,
        },
      );

      if (response.statusCode == 201) {
        return ApiResponse.success(
          data: {
            'user': User.fromJson(response.data['data']['user']),
            'access_token': response.data['data']['access_token'],
            'refresh_token': response.data['data']['refresh_token'],
          },
        );
      } else {
        return ApiResponse.error(
          errorMessage: response.data['message'] ?? 'Registration failed',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Registration failed';
      
      if (e.response != null) {
        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx
        errorMessage = e.response!.data['error']['message'] ?? 
                      e.response!.statusMessage ?? 
                      'Registration failed';
      } else if (e.requestOptions != null) {
        // The request was made but no response was received
        errorMessage = 'No internet connection';
      }
      
      return ApiResponse.error(errorMessage: errorMessage);
    } catch (e) {
      return ApiResponse.error(errorMessage: 'An unexpected error occurred');
    }
  }

  // Login user
  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(
          data: {
            'user': User.fromJson(response.data['data']['user']),
            'access_token': response.data['data']['access_token'],
            'refresh_token': response.data['data']['refresh_token'],
          },
        );
      } else {
        return ApiResponse.error(
          errorMessage: response.data['message'] ?? 'Login failed',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Login failed';
      
      if (e.response != null) {
        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx
        errorMessage = e.response!.data['error']['message'] ?? 
                      e.response!.statusMessage ?? 
                      'Login failed';
      } else if (e.requestOptions != null) {
        // The request was made but no response was received
        errorMessage = 'No internet connection';
      }
      
      return ApiResponse.error(errorMessage: errorMessage);
    } catch (e) {
      return ApiResponse.error(errorMessage: 'An unexpected error occurred');
    }
  }

  // Update user profile
  Future<ApiResponse<User>> updateUserProfile({
    required String token,
    String? username,
    String? email,
    String? status,
    String? profilePictureUrl,
  }) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/users/profile',
        data: {
          if (username != null) 'username': username,
          if (email != null) 'email': email,
          if (status != null) 'status': status,
          if (profilePictureUrl != null) 'profile_picture_url': profilePictureUrl,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(
          data: User.fromJson(response.data['data']),
        );
      } else {
        return ApiResponse.error(
          errorMessage: response.data['message'] ?? 'Update failed',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Update failed';
      
      if (e.response != null) {
        errorMessage = e.response!.data['error']['message'] ?? 
                      e.response!.statusMessage ?? 
                      'Update failed';
      } else if (e.requestOptions != null) {
        errorMessage = 'No internet connection';
      }
      
      return ApiResponse.error(errorMessage: errorMessage);
    } catch (e) {
      return ApiResponse.error(errorMessage: 'An unexpected error occurred');
    }
  }
}

// Generic API response class
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? errorMessage;

  ApiResponse.success({this.data}) : success = true, errorMessage = null;
  
  ApiResponse.error({this.errorMessage}) : success = false, data = null;
}