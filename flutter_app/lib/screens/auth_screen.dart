import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLogin = true; // Toggle between login and register
  bool _isPasswordVisible = false;
  String? _errorMessage;
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleFormMode() {
    setState(() {
      _isLogin = !_isLogin;
      _errorMessage = null;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);
    
    try {
      if (authService.appMode == AppMode.development) {
        await authService.signInDevelopment();
      } else {
        if (_isLogin) {
          await authService.signInWithEmail(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
        } else {
          await authService.registerWithEmail(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    try {
      if (authService.appMode == AppMode.development) {
        await authService.signInDevelopment();
      } else {
        await authService.signInWithGoogle();
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final isDevelopmentMode = authService.appMode == AppMode.development;
    
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo or Icon
                const Icon(
                  Icons.sports_martial_arts,
                  size: 80,
                  color: Colors.indigo,
                ),
                const SizedBox(height: 24),
                
                // App Title
                const Text(
                  'Bristol Jiu Jitsu',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Mode indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isDevelopmentMode ? Colors.amber[100] : Colors.blue[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isDevelopmentMode ? Icons.code : Icons.verified_user,
                        size: 16,
                        color: isDevelopmentMode ? Colors.amber[900] : Colors.blue[900],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isDevelopmentMode ? 'DEVELOPMENT MODE' : 'PRODUCTION MODE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDevelopmentMode ? Colors.amber[900] : Colors.blue[900],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                
                // Mode Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Development'),
                    Switch(
                      value: authService.appMode == AppMode.production,
                      onChanged: (value) {
                        authService.setAppMode(
                          value ? AppMode.production : AppMode.development,
                        );
                      },
                    ),
                    const Text('Production'),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Error message if any
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                
                // Quick Dev Sign-in Button
                if (isDevelopmentMode)
                  ElevatedButton(
                    onPressed: authService.isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: authService.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('QUICK SIGN IN (DEV MODE)'),
                  ),
                
                // Form for production mode
                if (!isDevelopmentMode)
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          enabled: !authService.isLoading,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          obscureText: !_isPasswordVisible,
                          enabled: !authService.isLoading,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (!_isLogin && value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        
                        // Submit Button
                        ElevatedButton(
                          onPressed: authService.isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: authService.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(_isLogin ? 'SIGN IN' : 'REGISTER'),
                        ),
                        const SizedBox(height: 16),
                        
                        // Toggle between login and register
                        TextButton(
                          onPressed: authService.isLoading ? null : _toggleFormMode,
                          child: Text(
                            _isLogin
                                ? 'Need an account? Register'
                                : 'Already have an account? Sign in',
                          ),
                        ),
                        
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text('OR'),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Google Sign In Button
                OutlinedButton.icon(
                  onPressed: authService.isLoading ? null : _signInWithGoogle,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  icon: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Center(
                      child: Text(
                        'G',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  label: const Text('Sign in with Google'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}