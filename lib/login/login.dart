import 'dart:convert';
import 'package:day2/bottomnavigation.dart';
import 'package:day2/login/signup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final formKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool obscurePassword = true;

  Future<void> login() async {
    final mobile = mobileController.text.trim();
    final password = passwordController.text.trim();

    if (mobile.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email/mobile number')),);
      return;
    }
    if (password.isEmpty) {
      ScaffoldMessenger.of(context,).showSnackBar(
          const SnackBar(content: Text('Please enter password')));
      return;
    }
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://purushothaman.haptrendmedia.com/app/uapi/d_user_login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mobile': mobile, 'password': password}),
      );

      print('Status Code: ${response.statusCode}');
      print('Response: ${response.body}');

      final data = jsonDecode(response.body);

      if (data['ResponseCode'].toString() == '200' &&
          data['Result'].toString() == 'true') {
        final user = data['UserLogin'];
        final addressExist = data['AddressExist'];
        'Login Success';
        'User ID: ${user['id']}';
        'Name: ${user['name']}';
        'Email: ${user['email']}';
        'Address Exist: $addressExist';
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['ResponseMsg'] ?? 'Login successfully!',)),
        );

        // Navigate to Home Screen
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNav(),
        // ),
        // );
      }
      // login failed
      else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['ResponseMsg'] ?? 'Login failed')),
        );
      }
    }
    // login error
    catch (e) {
      print('Login Error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context,).showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 170),
                    Text("Login",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: mobileController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email / Mobile Number',
                        hintText: 'Enter email or mobile number',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNav(),));
                        },
                        child: isLoading
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.all(10)),
                        Text("Don't have any account?",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        TextButton(
                          onPressed: (){
                           Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp(),));
                          },
                          child: Text("Sign up",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
