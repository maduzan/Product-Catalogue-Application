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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: authService.onAuthStateChanges,
      builder: (context, snapshot) {
        return AbsorbPointer(
          absorbing: snapshot.data is AuthLoading,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Sign In',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            body: Form(
              key: _formKey,
              child: ExtendedColumn(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    child: AppLogo(imageWidth: 118, imageHeight: 120),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  FixedGap(mainAxisExtent: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const Spacer(),
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
