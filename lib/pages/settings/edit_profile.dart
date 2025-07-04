import 'package:TableReserver/components/custom_appbar.dart';
import 'package:TableReserver/components/modal_widgets.dart';
import 'package:TableReserver/models/edit_profile_model.dart';
import 'package:TableReserver/themes/theme.dart';
import 'package:TableReserver/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatelessWidget {
  final int userId;
  final Position? userLocation;

  const EditProfile({
    Key? key,
    required this.userId,
    this.userLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditProfileModel(
        context: context,
        userId: userId,
        userLocation: userLocation,
      )..init(),
      child: Consumer<EditProfileModel>(
        builder: (context, model, _) {
          if (model.currentUser == null) {
            return const CircularProgressIndicator();
          }
          return Scaffold(
            key: model.scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: CustomAppbar(
              title: 'Edit Profile',
              onBack: () => Navigator.of(context).pushNamed(
                Routes.account,
                arguments: {
                  'userId': model.userId,
                  'userLocation': userLocation,
                },
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 36),
                    _buildChangeDetailGroup(context, model),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChangeDetailGroup(BuildContext ctx, EditProfileModel model) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(ctx).colorScheme.background,
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              spreadRadius: 2,
              color: Theme.of(ctx).colorScheme.outline,
              offset: const Offset(0, 1),
            )
          ],
          borderRadius: BorderRadius.circular(8),
          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildChangeUsername(ctx, model),
              _buildDivider(ctx),
              _buildChangeEmail(ctx, model),
              _buildDivider(ctx),
              _buildChangePassword(ctx, model),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext ctx) {
    return Divider(
      color: Theme.of(ctx).colorScheme.onPrimary.withOpacity(.5),
      thickness: .5,
    );
  }

  Widget _buildChangeUsername(BuildContext ctx, EditProfileModel model) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(12),
      child: InkWell(
        onTap: () => _openChangeUsernameBottomSheet(ctx, model),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Change Username', style: Theme.of(ctx).textTheme.titleMedium),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: Text(
                    model.updatedUsername ?? model.currentUser!.username,
                    style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(ctx)
                              .colorScheme
                              .onPrimary
                              .withOpacity(.6),
                        ),
                  ),
                ),
                Icon(
                  CupertinoIcons.chevron_right,
                  color: Theme.of(ctx).colorScheme.onPrimary,
                  size: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangeEmail(BuildContext ctx, EditProfileModel model) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(12),
      child: InkWell(
        onTap: () => _openChangeEmailBottomSheet(ctx, model),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Change Email', style: Theme.of(ctx).textTheme.titleMedium),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: Text(
                    model.updatedEmail ?? model.currentUser!.email,
                    style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(ctx)
                              .colorScheme
                              .onPrimary
                              .withOpacity(.6),
                        ),
                  ),
                ),
                Icon(
                  CupertinoIcons.chevron_right,
                  color: Theme.of(ctx).colorScheme.onPrimary,
                  size: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangePassword(BuildContext ctx, EditProfileModel model) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(12),
      child: InkWell(
        onTap: () => _openChangePasswordBottomSheet(ctx, model),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Change Password', style: Theme.of(ctx).textTheme.titleMedium),
            Icon(
              CupertinoIcons.chevron_right,
              color: Theme.of(ctx).colorScheme.onPrimary,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  void _openChangeUsernameBottomSheet(
    BuildContext ctx,
    EditProfileModel model,
  ) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: modalPadding(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildModalTitle(context, 'Change Username'),
              const SizedBox(height: 16),
              _buildInputField(
                ctx,
                'New Username',
                'Enter a new username',
                model.newUsernameTextController,
                model.newUsernameFocusNode,
                TextInputType.text,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildModalButton('Cancel', model.cancel,
                      Theme.of(context).colorScheme.onPrimary),
                  buildModalButton(
                      'Save', model.changeUsername, AppThemes.successColor),
                ],
              ),
              const SizedBox(height: 36),
            ],
          ),
        );
      },
    );
  }

  void _openChangeEmailBottomSheet(
    BuildContext ctx,
    EditProfileModel model,
  ) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: modalPadding(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildModalTitle(context, 'Change Email'),
              const SizedBox(height: 16),
              _buildInputField(
                ctx,
                'New Email',
                'Enter your new email',
                model.newEmailTextController,
                model.newEmailFocusNode,
                TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildModalButton('Cancel', model.cancel,
                      Theme.of(context).colorScheme.onPrimary),
                  buildModalButton(
                      'Save', model.changeEmail, AppThemes.successColor),
                ],
              ),
              const SizedBox(height: 36),
            ],
          ),
        );
      },
    );
  }

  void _openChangePasswordBottomSheet(
    BuildContext ctx,
    EditProfileModel model,
  ) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: modalPadding(context),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildModalTitle(context, 'Change Password'),
                  const SizedBox(height: 16),
                  _buildPasswordInputField(
                      ctx,
                      'New Password',
                      'Enter a new password',
                      model.newPasswordTextController,
                      model.newPasswordFocusNode,
                      model.newPasswordVisibility, () {
                    setModalState(() => model.newPasswordVisibility =
                        !model.newPasswordVisibility);
                  }),
                  _buildPasswordInputField(
                      ctx,
                      'Confirm New Password',
                      'Confirm your password',
                      model.confirmNewPasswordTextController,
                      model.confirmNewPasswordFocusNode,
                      model.confirmNewPasswordVisibility, () {
                    setModalState(() => model.confirmNewPasswordVisibility =
                        !model.confirmNewPasswordVisibility);
                  }),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildModalButton('Cancel', model.cancel,
                          Theme.of(context).colorScheme.onPrimary),
                      buildModalButton(
                          'Save', model.changePassword, AppThemes.successColor),
                    ],
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInputField(
    BuildContext ctx,
    String labelText,
    String hint,
    TextEditingController controller,
    FocusNode focusNode,
    TextInputType keyboardType,
  ) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hint,
        ),
        style: Theme.of(ctx).textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildPasswordInputField(
    BuildContext ctx,
    String labelText,
    String hint,
    TextEditingController controller,
    FocusNode focusNode,
    bool isVisible,
    VoidCallback toggleVisibility,
  ) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: !isVisible,
        style: Theme.of(ctx).textTheme.bodyLarge,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hint,
          suffixIcon: IconButton(
            icon: Icon(isVisible
                ? CupertinoIcons.eye_solid
                : CupertinoIcons.eye_slash_fill),
            onPressed: toggleVisibility,
          ),
        ),
      ),
    );
  }
}
