import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_taking_app/widgets/button.dart';
import 'package:note_taking_app/constants/colors.dart';
import 'package:note_taking_app/widgets/text_field.dart';
import 'package:note_taking_app/constants/extensions/email_validator.dart';
import 'package:note_taking_app/views/animations/google_animation_view.dart';
import 'package:note_taking_app/state/auth/provider/auth_state_provider.dart';
import 'package:note_taking_app/views/animations/facebook_animation_view.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  bool _registered = true;
  bool _emailError = false;
  bool _passwordError = false;
  bool _invisible = false;
  bool _confirmPasswordError = false;

  void _changeScreen() {
    setState(() {
      // sets it to the opposite of the current screen
      _registered = !_registered;
    });
  }

  void _passwordVisibility() {
    setState(() {
      _invisible = !_invisible;
    });
  }

  void _validateFieldsForSignup() {
    setState(() {
      _emailError =
          _email.text.isEmpty || !EmailValidator().isEmailValid(_email.text);
      _passwordError = _password.text.isEmpty;
      _confirmPasswordError = _confirmPassword.text.isEmpty ||
          _confirmPassword.text != _password.text;
    });
  }

  void _validateFieldsForLogin() {
    setState(() {
      _emailError =
          _email.text.isEmpty || !EmailValidator().isEmailValid(_email.text);
      _passwordError = _password.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _registered ? const Text('Login') : const Text('Sign up'),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.04,
            ),
            child: TextButton(
              onPressed: () {},
              child: const Icon(
                CupertinoIcons.question,
                color: Color(CustomColors.lightGray),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: accelerateEasing,
              switchOutCurve: decelerateEasing,
              child: Container(
                key: Key(_registered.toString()),
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.08,
                  right: MediaQuery.of(context).size.width * 0.08,
                ),
                child: Column(
                  children: [
                    TextFieldWidget(
                      error: _emailError,
                      errorText: 'Email is required',
                      hintText: 'Enter Your Email',
                      labelText: 'Email',
                      textEditingController: _email,
                      keyboardType: TextInputType.emailAddress,
                      invisible: false,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFieldWidget(
                      error: _passwordError,
                      errorText: 'Password is required',
                      hintText: 'Enter Your Password',
                      labelText: 'Password',
                      textEditingController: _password,
                      keyboardType: TextInputType.visiblePassword,
                      suffixIcon: _registered
                          ? _invisible
                              ? CupertinoIcons.eye_fill
                              : CupertinoIcons.eye_slash_fill
                          : null,
                      onIconTapped: () {
                        _passwordVisibility();
                      },
                      invisible: _invisible,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Consumer(
                      builder: (_, WidgetRef ref, __) {
                        return Visibility(
                          visible: _registered,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextButton(
                                onPressed: () {
                                  final email = _email.text;
                                  if (email.isNotEmpty) {
                                    ref
                                        .read(authStateProvider.notifier)
                                        .resetPassword(email: email);
                                  } else if (email.isEmpty) {
                                    setState(() {
                                      _emailError = true;
                                    });
                                  }
                                },
                                child: const Text('Forgot your password?'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Visibility(
                      visible: !_registered,
                      child: TextFieldWidget(
                        hintText: 'Confirm Your Password',
                        error: _confirmPasswordError,
                        errorText: 'Passwords do not match',
                        labelText: 'Password',
                        textEditingController: _confirmPassword,
                        keyboardType: TextInputType.visiblePassword,
                        invisible: false,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Consumer(
                      builder: (_, WidgetRef ref, __) {
                        return Button(
                          text: _registered ? 'Login' : 'Sign Up',
                          icon: CupertinoIcons.checkmark_circle,
                          radius: 24,
                          onPressed: () async {
                            if (_registered) {
                              _validateFieldsForLogin();
                              if (_emailError == false &&
                                  _passwordError == false) {
                                await ref
                                    .read(authStateProvider.notifier)
                                    .loginInWithEmail(
                                      email: _email.text,
                                      password: _password.text,
                                    );
                              } else {
                                print("not verified fields");
                              }
                            } else {
                              _validateFieldsForSignup(); // Validate fields before proceeding
                              if (_emailError == false &&
                                  _passwordError == false &&
                                  _confirmPasswordError == false) {
                                await ref
                                    .read(authStateProvider.notifier)
                                    .signUpWithEmailAndPassword(
                                      email: _email.text,
                                      password: _password.text,
                                    );
                              }
                            }
                            GoRouter.of(context).pushReplacement('/splash');
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.32,
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer(
                  builder: (_, WidgetRef ref, __) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () async {
                            await ref
                                .read(authStateProvider.notifier)
                                .loginWithGoogle();
                          },
                          child: const GoogleAnimationView(),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(22),
                          onTap: () async {
                            await ref
                                .read(authStateProvider.notifier)
                                .loginWithFacebook();
                          },
                          child: const FacebookAnimationView(),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_registered
                        ? 'Dont\'t have an account?'
                        : 'Already have an account?'),
                    Button(
                      onPressed: _changeScreen,
                      text: _registered ? 'Sign Up' : 'Login',
                      icon: Icons.login,
                      color: Colors.transparent,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox()
          ],
        ),
      ),
    );
  }
}
