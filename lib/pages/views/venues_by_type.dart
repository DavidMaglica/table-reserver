import 'package:TableReserver/components/custom_appbar.dart';
import 'package:TableReserver/components/venue_card_by_type.dart';
import 'package:TableReserver/models/venue_by_type_model.dart';
import 'package:TableReserver/themes/theme.dart';
import 'package:TableReserver/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class VenuesByType extends StatelessWidget {
  final String type;
  final int? userId;
  final Position? userLocation;

  const VenuesByType({
    super.key,
    required this.type,
    this.userId,
    this.userLocation,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VenuesByTypeModel(
        context: context,
        userId: userId,
        type: type,
        userLocation: userLocation,
      )..init(),
      child: Consumer<VenuesByTypeModel>(builder: (context, model, _) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: model.scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: CustomAppbar(
              title: '${type.toTitleCase()} Venues',
              onBack: model.goBack,
            ),
            body: SafeArea(
              bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: _buildListView(context, model),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildListView(BuildContext context, VenuesByTypeModel model) {
    return ListView.builder(
      controller: model.scrollController,
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: model.venues.length,
      itemBuilder: (context, index) {
        if (index == model.venues.length && model.hasMorePages) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(
                color: AppThemes.successColor,
              ),
            ),
          );
        }

        final venue = model.venues[index];
        final venueType = model.venueTypeMap[venue.typeId] ?? '';

        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: InkWell(
            onTap: () {
              model.goToVenuePage(venue.id);
            },
            child: VenueCardByType(
              venue: venue,
              venueType: venueType,
            ),
          ),
        );
      },
    );
  }
}
