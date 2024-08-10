import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../../components/appbar.dart';
import '../../components/custom_choice_chips.dart';
import '../../components/navbar.dart';
import '../../utils/routing_utils.dart';
import 'models/search_model.dart';

export 'models/search_model.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final int pageIndex = 1;
  late SearchModel _model;

  List<String> chipsOptions = [
    'Italian',
    'Asian',
    'Gluten Free',
    'Coffee',
    'Traditional',
    'Japanese',
    'Middle Eastern',
    'Barbecue',
    'Greek',
    'Cocktails',
    'Vegetarian',
    'Vegan',
    'Fine Dining',
    'Fast Food',
    'Seafood',
    'Mexican',
    'Indian',
    'Chinese',
    'Pizza',
  ];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: const CustomAppbar(title: ''),
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0, 24, 0, 36),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24, 36, 24, 0),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                              child: Align(
                                alignment:
                                    const AlignmentDirectional(-1, 0),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      12, 0, 0, 0),
                                  child: Text('Search',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: CustomChoiceChips(
                      options: chipsOptions,
                      initialValues: const [],
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0, 0, 0, 36),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildListTitle('Restaurant 1'),
                          _buildDivider(),
                          _buildListTitle('Coffee Shop 1'),
                          _buildDivider(),
                          _buildListTitle('Coffee Shop 2'),
                          _buildDivider(),
                          _buildListTitle('Restaurant 2'),
                          _buildDivider(),
                          _buildListTitle('Restaurant 3'),
                          _buildDivider(),
                          _buildListTitle('Coffee Shop 3')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: NavBar(
            currentIndex: pageIndex,
            context: context,
            onTap: (index, context) =>
                onNavbarItemTapped(pageIndex, index, context),
          )),
    );
  }

  Widget _buildListTitle(String title) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
      child: ListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 20,
        ),
        tileColor: Theme.of(context).colorScheme.surfaceVariant,
        dense: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
      child: Divider(
        indent: 36,
        endIndent: 36,
        thickness: .5,
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );
  }
}