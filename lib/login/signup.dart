import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final password = TextEditingController();
  final mobile = TextEditingController();
  final email = TextEditingController();
  final ccode = TextEditingController();
  final refercode = TextEditingController();
  bool obscurePassword = true;
  bool obscureEmail = true;
  bool isLoading = false;

  @override
  void dispose() {
    name.dispose();
    password.dispose();
    mobile.dispose();
    email.dispose();
    refercode.dispose();
    ccode.dispose();
    super.dispose();
  }

  Future<void> register() async {

    if (!formKey.currentState!.validate()){
      return;
    }
    if (name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter name')),
      );
      return;
    }
    if (mobile.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter mobile number')),
      );
      return;
    }
    if (password.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter password')),
      );
      return;
    }
    if (email.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Email')),
      );
      return;
    }
    if (ccode.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter ccode')),
      );
      return;
    }
    // if (refercode.text.trim().isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Please enter Refercode')),
    //   );
    //   return;
    // }
    setState(() {
      isLoading = false;
    });

    try {
      final response = await http.post(
        Uri.parse('https://purushothaman.haptrendmedia.com/app/uapi/d_reg_user.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name.text.trim(),
          'mobile': mobile.text.trim(),
          'password': password.text.trim(),
          'email': email.text.trim(),
          'ccode': ccode.text.trim(),
          'refercode': refercode.text.trim()}),
      );

      print('Status Code: ${response.statusCode}');
      print('Response: ${response.body}');

      if (response.statusCode != 200) {
        if (!mounted)
          return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar( content: Text( 'Server Error: ${response.statusCode}',
          ),
          ),
        );
        return;
      }
      final data = jsonDecode(response.body);
      'Decoded Data: $data';

      if (data['ResponseCode'].toString() == '200' &&
          data['Result'].toString() == 'true') {
        'register success';
        final user = data['UserLogin'];
        final addressExist = data['AddressExist'];

        'Login Success';
        'Name: ${user['name']}';
        'mobile: ${user['mobile']}';
        'password: ${user['password']}';
        'email: ${user['email']}';
        'ccode: ${user['ccode']}';
        'refercode: ${user['refercode']}';
        'Address Exist: $addressExist';

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['ResponseMsg'] ?? 'Login successfully!')),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login(),),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['ResponseMsg'] ?? 'Login failed')),
        );
      }
    } catch (e) {
      print('Login Error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context,).showSnackBar(
          SnackBar(content: Text('Something went wrong: $e')));
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
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(25),
            // height: 700,
            width: double.infinity,
            child: Card(
              elevation: 2,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text("Create Account",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your name";
                        }
                        return null;
                      },
                      controller: name,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter your mobile number";
                        }
                        if (value.length < 10) {
                          return "Password must be at least 10 characters";
                        }
                        return null;
                      },
                      controller: mobile,
                      // obscureText: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Mobile",
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty){
                          return "please enter your email";
                        }
                        if(value == r'^[a-zA-Z0-9._%+-]+@gmail\.com$'){
                          return "Please enter valid email";
                        }
                        return null;
                      },
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.alternate_email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        if (value.length > 6) {
                          return null;
                        }
                        return null;
                      },
                      controller: password,
                      obscureText: obscurePassword,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        // right side la varum suffixicon
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword ? Icons.visibility_off :  Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your ccode";
                        }if (value == "+") {
                          return "Please enter your Refer Code";
                        }
                        if (value.length <3) {
                          return "Please enter your Refer Code";
                        }
                        return null;
                      },
                      controller: ccode,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "CCode",
                        prefixIcon: Icon(Icons.numbers),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your Refer Code";
                        }

                        return null;
                      },
                      controller: refercode,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: "Refer Code",
                        prefixIcon: Icon(Icons.local_offer_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : register,
                        child: isLoading
                            ? const SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Text('Sign Up',
                          style: TextStyle(
                            fontSize:20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Already have an account?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Login(),));
                          },
                          child: Text("Sign In",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}