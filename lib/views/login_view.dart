import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';

class LginView extends StatefulWidget {
  const LginView({Key? key}) : super(key: key);

  @override
  State<LginView> createState() => _LginViewState();
}

class _LginViewState extends State<LginView> {
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
        title: const Text("Login"),
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
                            .signInWithEmailAndPassword(
                                email: email, password: pwd);
                        print(userCredential);
                      } on FirebaseAuthException catch (e) {
                        //<nn>
                        // Handle authentication errors
                        //</nn>
                        print('AUTHENTICATION ERROR!!!');
                        if (e.code == 'user-not-found') {
                          print(
                              'User $email is not registered! (or it is deleted already)');
                        } else if (e.code == 'wrong-password') {
                          print('The password is not OK. Try again please!');
                        } else {
                          print('Unknown authorization error occured.');
                          print('E => [$e]');
                        }
                      } catch (e) {
                        //<nn>
                        // Handle any klind of error during login
                        //</nn>
                        print('We have an error now!!!');
                        print(e);
                      }
                    },
                    child: const Text('Login'),
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
