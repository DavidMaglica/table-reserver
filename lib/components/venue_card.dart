import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';

import '../api/data/venue.dart';
import '../api/venue_api.dart';
import '../themes/theme.dart';
import '../utils/constants.dart';

class VenueCard extends StatefulWidget {
  final Venue venue;
  final String? userEmail;
  final Position? userLocation;

  const VenueCard({
    Key? key,
    required this.venue,
    this.userEmail,
    this.userLocation,
  }) : super(key: key);

  @override
  State<VenueCard> createState() => _VenueCardState();
}

class _VenueCardState extends State<VenueCard> {
  List<String>? _venueImages;

  VenueApi venueApi = VenueApi();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    List<String> venueImages = venueApi.getVenueImages(widget.venue.name);
    setState(() => _venueImages = venueImages);
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
      width: 148,
      height: 148,
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
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(4, 6, 4, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildName(widget.venue.name),
                        _buildLocationAndAvailability(widget.venue.location),
                        _buildRatingBar(widget.venue.rating),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
              height: 80,
              fit: BoxFit.cover,
            )));
  }

  Widget _buildName(String name) {
    return Text(
      name.toUpperCase(),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: Theme.of(context)
          .textTheme
          .titleSmall
          ?.copyWith(color: AppThemes.accent1, fontSize: 12),
    );
  }

  Widget _buildLocationAndAvailability(String location) {
    final ratio = widget.venue.maximumCapacity > 0
        ? widget.venue.availableCapacity / widget.venue.maximumCapacity
        : 0.0;

    final Color availabilityColor = ratio >= 0.6
        ? AppThemes.successColor
        : ratio >= 0.3
            ? AppThemes.warningColor
            : Colors.red;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            location,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
              fontWeight: FontWeight.w800,
              fontSize: 9,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.person_2_fill,
                color: availabilityColor,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                '${widget.venue.availableCapacity}/${widget.venue.maximumCapacity}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: availabilityColor,
                    ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRatingBar(double rating) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
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
            itemSize: 12,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 1),
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
    );
  }
}
