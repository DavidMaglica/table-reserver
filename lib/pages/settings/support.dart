import 'package:TableReserver/components/action_button.dart';
import 'package:TableReserver/components/custom_appbar.dart';
import 'package:TableReserver/components/modal_widgets.dart';
import 'package:TableReserver/components/support_banner.dart';
import 'package:TableReserver/models/support_model.dart';
import 'package:TableReserver/themes/theme.dart';
import 'package:TableReserver/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';

class Support extends StatefulWidget {
  final int userId;
  final Position? userLocation;

  const Support({
    Key? key,
    required this.userId,
    this.userLocation,
  }) : super(key: key);

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  late final SupportModel model;

  @override
  void initState() {
    super.initState();
    model = SupportModel(
      context: context,
      userId: widget.userId,
      position: widget.userLocation,
    );
  }

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: model.scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: CustomAppbar(
          title: 'Support',
          onBack: () => Navigator.of(context).pushNamed(
            Routes.account,
            arguments: {
              'userId': widget.userId,
              'userLocation': widget.userLocation
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.symmetric(vertical: 24),
                    child: Text(
                      'Have you encountered an issue with the application? Search for answers in our FAQs or submit a ticket in the form below to contact us.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: model.openFAQs,
                          child: const SupportBanner(
                            title: 'Search FAQs',
                            icon: CupertinoIcons.search_circle_fill,
                          ),
                        ),
                      ),
                    ].divide(const SizedBox(width: 12)),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Theme.of(context).colorScheme.onPrimary,
                            thickness: 1,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'OR',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Theme.of(context).colorScheme.onPrimary,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(bottom: 12),
                          child: Text(
                            'Submit a Ticket',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        _buildInputField(
                          model.ticketTitleController,
                          model.ticketTitleFocusNode,
                          'Ticket title',
                          'Enter a title for your ticket.',
                          null,
                          null,
                        ),
                        _buildInputField(
                          model.ticketDescriptionController,
                          model.ticketDescriptionFocusNode,
                          'Short description',
                          'Short description of what is going on...',
                          16,
                          6,
                        ),
                      ].divide(const SizedBox(height: 12)),
                    ),
                  ),
                  ActionButton(
                    title: 'Submit Ticket',
                    onPressed: () => model.submitTicket(),
                    iconData: CupertinoIcons.paperplane_fill,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController? controller,
    FocusNode? focusNode,
    String labelText,
    String hintText,
    int? maxLines,
    int? minLines,
  ) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.bodyLarge,
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        enabledBorder:
            outlineInputBorder(Theme.of(context).colorScheme.onPrimary),
        focusedBorder: outlineInputBorder(AppThemes.infoColor),
        errorBorder: outlineInputBorder(Theme.of(context).colorScheme.error),
        focusedErrorBorder: outlineInputBorder(AppThemes.infoColor),
        contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
      ),
      style: Theme.of(context).textTheme.bodyLarge,
      maxLines: maxLines,
      minLines: minLines,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
    );
  }
}
