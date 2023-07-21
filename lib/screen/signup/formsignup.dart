// ignore_for_file: camel_case_types, unrelated_type_equality_checks
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virgil_app/screen/utils/auth.dart';

bool containsUpperCase(String str) {
  return str
      .split('')
      .any((char) => char.toUpperCase() == char && char.toLowerCase() != char);
}

bool containsBlackList(String str) {
  List<String> blackList = [
    '/',
    '&',
    '|',
    '<',
    '>',
    '-',
    ';',
    '"',
    "'",
    "%",
    ")",
    "]",
    "(",
    "[",
    "{",
    "}",
    " ",
    '*'
  ];
  for (var i = 0; i < str.length; i++) {
    for (var char in str.split('')) {
      if (blackList.contains(char)) {
        return true;
      }
    }
  }
  return false;
}

String checker(String str) {
  List<String> listNumber = ['1', "2", "3", "4", "5", "6", "7", "8", "9", "0"];
  List<String> listSimbols = ['#', '_', '!', '.', '+', '@'];
  var error = "";
  if (str.length > 8) {
    if (!containsBlackList(str)) {
      if (containsUpperCase(str)) {
        if (listSimbols.any(str.contains)) {
          if (listNumber.any(str.contains)) {
            error = 'W';
          } else {
            error = 'N';
          }
        } else {
          error = 'S';
        }
      } else {
        error = 'U';
      }
    } else {
      error = 'B';
    }
  } else {
    error = 'L';
  }
  return error;
}

class formsignup extends StatefulWidget {
  const formsignup({super.key});

  @override
  State<formsignup> createState() => _formsignupState();
}

class _formsignupState extends State<formsignup> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLogin = true;

  Future<void> createUser() async {
    //print(_email.text);
    //print(_password.text);
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _email.text, password: _password.text);
    } on FirebaseAuthException catch (error) {
      print(error);
    }
  }

  //KEY FORM
  final formKey = GlobalKey<FormState>();

  //Varible for FORM
  bool obscure = true;
  String confirmPassword = "";
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Form(
        key: formKey,
        child: ListView(
          children: [
            //EMAIL
            TextFormField(
              //VALIDATE
              maxLength: 100,
              maxLines: 1,
              controller: _email,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@')) {
                  return "Insert a valid email";
                }
                return null;
              },
              //STYLE
              cursorColor: Colors.white,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.email),
                  suffixIconColor: Colors.white,
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: 'example@email.com',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.0, color: Colors.deepPurple))),
            ),

            //PASSWORD
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextFormField(
                  //VALIDATOR
                  controller: _password,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password not valid";
                    } else {
                      final String risultatoChecker = checker(value);
                      if (risultatoChecker == 'W') {
                        return null;
                      } else if (risultatoChecker == 'L') {
                        return "Invalid length (min:8)";
                      } else if (risultatoChecker == 'B') {
                        return "You cannot insert this character";
                      } else if (risultatoChecker == 'U') {
                        return "You must enter at least one upper character";
                      } else if (risultatoChecker == 'S') {
                        return "You must insert at least one character ('#', '_', '!', '.','+','@;')";
                      } else if (risultatoChecker == 'N') {
                        return "You must enter at least one number";
                      } else {
                        return "Sorry there was some error";
                      }
                    }
                  },
                  //STYLE
                  textInputAction: TextInputAction.next,
                  cursorColor: Colors.white,
                  obscureText: obscure,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: '',
                      labelStyle: const TextStyle(color: Colors.white),
                      suffixIconColor: Colors.white,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                          icon: obscure
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off)),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2.0, color: Colors.deepPurpleAccent)))),
            ),
            //CONFIRM
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: TextFormField(
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value != _password.text) {
                      return "The password don't match";
                    }
                    return null;
                  },
                  //STYLE
                  cursorColor: Colors.white,
                  obscureText: obscure,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      labelText: 'Confirm password',
                      hintText: '',
                      labelStyle: const TextStyle(color: Colors.white),
                      suffixIconColor: Colors.white,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                          icon: obscure
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off)),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2.0, color: Colors.deepPurpleAccent)))),
            ),
            //BUTTON
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    createUser();
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
                ),
                child: const Text('Sign up'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
