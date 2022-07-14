import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController? _email;
  TextEditingController? _pwd;

  @override
  void initState() {
    //<nn>
    // During initialization we create a instance for both txtController
    //</nn>
    print('Initstate runs now....');
    _email = TextEditingController();
    _pwd = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    //<nn>
    // As we overload the initState functrion and created some variables in it, we also have to
    // overload the dispose function as well, and in it, we have to destroy the manually initiali-
    // zed variables.
    //</nn>
    //_email.dispose();
    //_pwd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: 'Enter your email please'),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    controller: _pwd,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                        hintText: 'Input your password here'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final email = _email!.text;
                      final pwd = _pwd!.text;
                      try {
                        final userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email, password: pwd);
                        print(userCredential);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print(
                              'Pasword is not secure, please choose a longer one!');
                          //print('E: {$e}');
                        } else if (e.code == 'email-already-in-use') {
                          print(
                              'This email is already taken, use diffrent one please!');
                          //print('E: {$e}');
                        } else if (e.code == 'invalid-email') {
                          print('Invalid (wrong formatted) email!');
                          //print('E: {$e}');
                        } else {
                          print('AUTHORIZATION ERROR:');
                          print('E: {$e}');
                        }
                      } catch (e) {
                        print('UNKNOWN ERROR:');
                        print('E: {$e}');
                      }
                    },
                    child: const Text('Register'),
                  ),
                ],
              );
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}
