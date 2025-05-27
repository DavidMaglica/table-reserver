import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';

import '../api/data/venue.dart';
import '../api/venue_api.dart';
import '../themes/theme.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';

class VenueSuggestedCard extends StatefulWidget {
  final Venue venue;
  final String? userEmail;
  final Position? userLocation;

  const VenueSuggestedCard({
    Key? key,
    required this.venue,
    this.userEmail,
    this.userLocation,
  }) : super(key: key);

  @override
  State<VenueSuggestedCard> createState() => _VenueSuggestedCardState();
}

class _VenueSuggestedCardState extends State<VenueSuggestedCard> {
  List<String>? _venueImages;
  String _venueType = '';

  VenueApi venueApi = VenueApi();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    List<String> venueImages = venueApi.getVenueImages(widget.venue.name);
    setState(() => _venueImages = venueImages);
    venueApi.getVenueType(widget.venue.typeId).then((value) {
      if (value != null) {
        setState(() {
          _venueType = value;
        });
      }
    });
    super.initState();
  }

  void _openVenuePage() =>
      Navigator.pushNamed(context, Routes.venue, arguments: {
        'venueId': widget.venue.id,
        'userEmail': widget.userEmail,
        'userLocation': widget.userLocation,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248,
      height: 196,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
            blurRadius: 6,
          )
        ],
      ),
      child: Flex(
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  _openVenuePage();
                },
                child: Column(
                  children: [
                    _buildImage(),
                    _buildNameAndType(widget.venue.name, _venueType),
                    _buildLocationAndAvailability(
                      widget.venue.location,
                      widget.venue.maximumCapacity,
                      widget.venue.availableCapacity,
                    ),
                    _buildRatingBarAndWorkingHours(
                        widget.venue.rating, widget.venue.workingHours),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Hero(
        tag: 'locationCardImage${randomDouble(0, 100)}',
        transitionOnUserGestures: true,
        child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: Image.asset(
              _venueImages!.first,
              width: double.infinity,
              height: 110,
              fit: BoxFit.cover,
            )));
  }

  Widget _buildNameAndType(String name, String type) {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: AppThemes.accent1)),
            Text(type.isNotEmpty ? type.toTitleCase() : '',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                )),
          ],
        ));
  }

  Widget _buildLocationAndAvailability(
    String location,
    int maximumCapacity,
    int availableCapacity,
  ) {
    final ratio =
        maximumCapacity > 0 ? availableCapacity / maximumCapacity : 0.0;

    final Color availabilityColor = ratio >= 0.6
        ? AppThemes.successColor
        : ratio >= 0.3
            ? AppThemes.warningColor
            : Colors.red;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(location,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                fontWeight: FontWeight.w800,
                fontSize: 10,
              )),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.person_2_fill,
                color: availabilityColor,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                '$availableCapacity/$maximumCapacity',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: availabilityColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBarAndWorkingHours(double rating, String workingHours) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RatingBarIndicator(
                itemBuilder: (context, index) => Icon(
                  CupertinoIcons.star_fill,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
                direction: Axis.horizontal,
                rating: rating,
                unratedColor: const Color(0xFF57636C).withOpacity(0.5),
                itemCount: 5,
                itemSize: 14,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 2),
                child: Text(
                  ' ${rating.toStringAsFixed(1)}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 10, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          Text(
            workingHours,
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 9),
          ),
        ],
      ),
    );
  }
}
