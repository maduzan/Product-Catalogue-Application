import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../app/widgets/widgets.dart';
import '../../utils/utils.dart';
import '../controller/controller.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  final AuthService authService = GetIt.instance<AuthService>();

  /// Stream subscription for monitoring changes in the authentication state.
  late StreamSubscription<AuthState> _authStateSubscription;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _authStateSubscription =
        authService.onAuthStateChanges.listen(onAuthStateChanged);
    super.initState();
  }

  Future<void> onAuthStateChanged(AuthState state) async {
    if (state is AuthFailed && mounted) {
      await appAdaptiveDialog(
        context: context,
        title: 'Sign In Failed',
        content: state.message,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  void onPressedVerifyAccountButton() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      authService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: authService.onAuthStateChanges,
      builder: (context, snapshot) {
        return AbsorbPointer(
          absorbing: snapshot.data is AuthLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Sign In',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            body: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: ExtendedColumn(
                children: [
                  const FixedGap(mainAxisExtent: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    child: AppLogo(imageWidth: 200, imageHeight: 120),
                  ),
                  const Spacer(),
                  const Text('Enter Your Email'),
                  const FixedGap(mainAxisExtent: 4),
                  EmailTextFormField(
                    controller: _emailController,
                    autovalidateMode: _autovalidateMode,
                  ),
                  const FixedGap(mainAxisExtent: 24),
                  const Text('Enter Your Password'),
                  const FixedGap(mainAxisExtent: 4),
                  PasswordTextFormField(
                    controller: _passwordController,
                    autovalidateMode: _autovalidateMode,
                  ),
                  const FixedGap(mainAxisExtent: 16),
                  const Spacer(),
                  Center(
                    child: ElevatedButton(
                      onPressed: onPressedVerifyAccountButton,
                      child: Builder(
                        builder: (context) {
                          if (snapshot.data is AuthLoading) {
                            return SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context)
                                        .colorScheme
                                        .onPrimary
                                        .withValues(alpha: 0.6)),
                              ),
                            );
                          }
                          return const Text('Sign In');
                        },
                      ),
                    ),
                  ),
                  const RelativeGap(mainAxisExtent: 0.05),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
