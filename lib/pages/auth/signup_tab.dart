import 'package:TableReserver/api/account_api.dart';
import 'package:TableReserver/api/data/basic_response.dart';
import 'package:TableReserver/components/toaster.dart';
import 'package:TableReserver/models/authentication_model.dart';
import 'package:TableReserver/models/signup_tab_model.dart';
import 'package:TableReserver/themes/theme.dart';
import 'package:TableReserver/utils/constants.dart';
import 'package:TableReserver/utils/sign_up_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpTab extends StatefulWidget {
  final AuthenticationModel model;

  const SignUpTab({super.key, required this.model});

  @override
  State<SignUpTab> createState() => _SignUpTabState();
}

class _SignUpTabState extends State<SignUpTab> with TickerProviderStateMixin {
  late SignUpTabModel _model;
  late final AccountApi accountApi = AccountApi();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignUpTabModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _performSignUp(SignUpMethodEnum signUpMethod) async {
    BasicResponse<int> response = await _model.signUp(signUpMethod);
    if (response.success && response.data != null) {
      _goToHomepage(response.data!);
    } else {
      if (!mounted) return;
      Toaster.displayError(context, response.message);
    }
  }

  void _goToHomepage(int userId) {
    Navigator.pushNamed(context, Routes.homepage,
        arguments: {'userId': userId, 'userLocation': null});
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, -1),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (responsiveVisibility(
                context: context,
                phone: false,
                tablet: false,
              ))
                const SizedBox(width: 230, height: 16),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 24),
                child: Text('Create Account',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: _buildEmailField(),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: _buildUsernameField(),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: _buildPasswordField(),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: _buildRetypePasswordField(),
                ),
              ),
              _buildSignUpButton(),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Text(
                      'Or sign up with',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 0,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        direction: Axis.horizontal,
                        runAlignment: WrapAlignment.center,
                        verticalDirection: VerticalDirection.down,
                        clipBehavior: Clip.none,
                        children: [
                          _buildAppleSignUpButton(),
                          _buildGoogleSignUpButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() => TextFormField(
        controller: widget.model.emailAddressSignUpTextController,
        focusNode: widget.model.emailAddressSignUpFocusNode,
        autofocus: false,
        autofillHints: const [AutofillHints.email],
        obscureText: false,
        decoration: InputDecoration(
          isDense: false,
          labelText: 'Email',
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppThemes.infoColor,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.all(24),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        keyboardType: TextInputType.emailAddress,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
      );

  Widget _buildUsernameField() => TextFormField(
        controller: widget.model.usernameSignUpTextController,
        focusNode: widget.model.usernameSignUpFocusNode,
        autofocus: false,
        autofillHints: const [AutofillHints.name, AutofillHints.familyName],
        obscureText: false,
        decoration: InputDecoration(
          isDense: false,
          labelText: 'Username',
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppThemes.infoColor,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.all(24),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        keyboardType: TextInputType.name,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
      );

  Widget _buildPasswordField() => TextFormField(
        controller: widget.model.passwordSignUpTextController,
        focusNode: widget.model.passwordSignUpFocusNode,
        autofocus: false,
        autofillHints: const [AutofillHints.password],
        obscureText: !widget.model.passwordSignUpVisibility,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppThemes.infoColor,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsetsDirectional.fromSTEB(24, 24, 0, 24),
          suffixIcon: InkWell(
            onTap: () => setState(() => widget.model.passwordSignUpVisibility =
                !widget.model.passwordSignUpVisibility),
            focusNode: FocusNode(skipTraversal: true),
            child: Icon(
              (widget.model.passwordSignUpVisibility)
                  ? CupertinoIcons.eye_solid
                  : CupertinoIcons.eye_slash_fill,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 24,
            ),
          ),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
      );

  Widget _buildRetypePasswordField() => TextFormField(
        controller: widget.model.passwordConfirmTextController,
        focusNode: widget.model.passwordConfirmFocusNode,
        autofocus: false,
        autofillHints: const [AutofillHints.password],
        obscureText: !widget.model.passwordConfirmVisibility,
        decoration: InputDecoration(
          labelText: 'Retype password',
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppThemes.infoColor,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsetsDirectional.fromSTEB(24, 24, 0, 24),
          suffixIcon: InkWell(
            onTap: () => setState(
              () => widget.model.passwordConfirmVisibility =
                  !widget.model.passwordConfirmVisibility,
            ),
            focusNode: FocusNode(skipTraversal: true),
            child: Icon(
              widget.model.passwordConfirmVisibility
                  ? CupertinoIcons.eye_solid
                  : CupertinoIcons.eye_slash_fill,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 24,
            ),
          ),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
      );

  Widget _buildSignUpButton() => Align(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
          child: FFButtonWidget(
            onPressed: () => _performSignUp(SignUpMethodEnum.custom),
            text: 'Sign up',
            options: FFButtonOptions(
              width: 270,
              height: 50,
              color: AppThemes.successColor,
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              borderSide: BorderSide.none,
              elevation: 3,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );

  Widget _buildGoogleSignUpButton() => Align(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
          child: FFButtonWidget(
            onPressed: () => _performSignUp(SignUpMethodEnum.google),
            text: 'Continue with Google',
            icon: const Icon(
              FontAwesomeIcons.google,
              size: 16,
            ),
            options: FFButtonOptions(
              width: 270,
              height: 50,
              color: Theme.of(context).colorScheme.background,
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(.3),
                fontSize: 18,
              ),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onPrimary,
                width: 1,
              ),
              elevation: 0,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );

  Widget _buildAppleSignUpButton() => Align(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
          child: FFButtonWidget(
            onPressed: () => _performSignUp(SignUpMethodEnum.apple),
            text: 'Continue with Apple',
            icon: const Icon(
              Icons.apple,
              size: 24,
            ),
            options: FFButtonOptions(
              width: 270,
              height: 50,
              color: Theme.of(context).colorScheme.background,
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(.3),
                fontSize: 18,
              ),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onPrimary,
                width: 1,
              ),
              elevation: 0,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
}
