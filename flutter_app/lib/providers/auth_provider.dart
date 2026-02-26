import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  AuthService _authService = AuthService();
  
  User? _currentUser;
  String? _accessToken;
  String? _refreshToken;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider(this._prefs) {
    _loadStoredCredentials();
  }

  // Getters
  User? get currentUser => _currentUser;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _accessToken != null && _currentUser != null;

  // Load stored credentials from SharedPreferences
  void _loadStoredCredentials() async {
    _accessToken = _prefs.getString('access_token');
    _refreshToken = _prefs.getString('refresh_token');
    
    if (_accessToken != null) {
      // Attempt to get user info from stored token
      // We'll implement this method in the AuthService later
    }
    
    notifyListeners();
  }

  // Register a new user
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.register(
        username: username,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );

      if (result.success) {
        _currentUser = result.data!['user'];
        _accessToken = result.data!['access_token'];
        _refreshToken = result.data!['refresh_token'];

        // Store tokens in SharedPreferences
        await _prefs.setString('access_token', _accessToken!);
        await _prefs.setString('refresh_token', _refreshToken!);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result.errorMessage;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login user
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.login(
        email: email,
        password: password,
      );

      if (result.success) {
        _currentUser = result.data!['user'];
        _accessToken = result.data!['access_token'];
        _refreshToken = result.data!['refresh_token'];

        // Store tokens in SharedPreferences
        await _prefs.setString('access_token', _accessToken!);
        await _prefs.setString('refresh_token', _refreshToken!);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result.errorMessage;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    _currentUser = null;
    _accessToken = null;
    _refreshToken = null;

    // Clear stored tokens
    await _prefs.remove('access_token');
    await _prefs.remove('refresh_token');

    notifyListeners();
  }

  // Update user profile
  Future<bool> updateUserProfile({
    String? username,
    String? email,
    String? status,
    String? profilePictureUrl,
  }) async {
    if (_accessToken == null) return false;

    try {
      final result = await _authService.updateUserProfile(
        token: _accessToken!,
        username: username,
        email: email,
        status: status,
        profilePictureUrl: profilePictureUrl,
      );

      if (result.success) {
        _currentUser = result.data!;
        
        // Update stored tokens if needed
        await _prefs.setString('access_token', _accessToken!);
        
        notifyListeners();
        return true;
      } else {
        _errorMessage = result.errorMessage;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}