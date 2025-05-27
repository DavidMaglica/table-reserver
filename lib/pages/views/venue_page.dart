import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../components/custom_appbar.dart';
import '../../components/full_image_view.dart';
import '../../components/modal_widgets.dart';
import '../../components/toaster.dart';
import '../../models/venue_page_model.dart';
import '../../themes/theme.dart';
import '../../utils/extensions.dart';

class VenuePage extends StatelessWidget {
  final int venueId;
  final List<String>? imageLinks;
  final String? userEmail;
  final Position? userLocation;

  const VenuePage({
    Key? key,
    required this.venueId,
    this.imageLinks,
    this.userEmail,
    this.userLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => VenuePageModel(
            ctx: context,
            venueId: venueId,
            imageLinks: imageLinks,
            userEmail: userEmail,
            userLocation: userLocation)
          ..init(),
        child: Consumer<VenuePageModel>(
          builder: (context, model, _) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                key: model.scaffoldKey,
                backgroundColor: Theme.of(context).colorScheme.surface,
                appBar: CustomAppbar(
                  title: model.venue.name,
                  onBack: () => Navigator.of(context).pop({
                    'userEmail': userEmail,
                    'userLocation': userLocation,
                  }),
                ),
                body: FutureBuilder<List<String>>(
                  future: model.images,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CupertinoActivityIndicator(
                        radius: 24,
                        color: AppThemes.infoColor,
                      ));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No images available'));
                    }

                    return Stack(
                      alignment: const AlignmentDirectional(0, 1),
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildHeadingImage(
                                  context,
                                  model.imageLinks != null
                                      ? model.imageLinks![0]
                                      : model.venueImages![0]),
                              _buildObjectDetails(context, model),
                              const SizedBox(height: 8),
                              _buildDivider(context),
                              const SizedBox(height: 8),
                              _buildMakeReservation(context, model),
                              const SizedBox(height: 8),
                              _buildDivider(context),
                              _buildMasonryView(model.imageLinks != null
                                  ? model.imageLinks!.skip(1).toList()
                                  : model.venueImages!.skip(1).toList()),
                            ],
                          ),
                        ),
                        _buildReserveSpotButton(context, model),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ));
  }

  Widget _buildHeadingImage(BuildContext ctx, String image) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
          Navigator.of(ctx).push(
            MaterialPageRoute(
              builder: (context) => FullScreenImageView(
                imageUrl: image,
                heroTag: 'headerImageTag',
              ),
            ),
          );
        },
        child: Hero(
          tag: 'headerImageTag',
          child: Image.asset(
            image,
            width: double.infinity,
            height: 320,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }

  Future<dynamic>? _buildRatingModal(BuildContext ctx, VenuePageModel model) {
    double rating = 0;

    if (model.userEmail.isNullOrEmpty) {
      Toaster.displayError(ctx, 'Please log in to rate ${model.venue.name}');
      return null;
    }

    return showCupertinoModalPopup(
      context: ctx,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 248,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 96,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: RatingBar.builder(
                        onRatingUpdate: (newRating) {
                          setModalState(() {
                            rating = newRating;
                          });
                        },
                        itemBuilder: (context, index) => Icon(
                          CupertinoIcons.star_fill,
                          color: Theme.of(context).colorScheme.onTertiary,
                        ),
                        unratedColor: const Color(0xFF57636C).withOpacity(0.5),
                        direction: Axis.horizontal,
                        glow: false,
                        ignoreGestures: false,
                        initialRating: rating,
                        itemSize: 32,
                        allowHalfRating: true,
                      ),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: rating > 0
                        ? Text(
                            'Your rating: ${rating.toStringAsFixed(1)}',
                            key: ValueKey(rating),
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        : const SizedBox.shrink(),
                  ),
                  rating != 0
                      ? const SizedBox(height: 29)
                      : const SizedBox(height: 48),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildModalButton(
                        'Cancel',
                        () {
                          Navigator.of(context).pop();
                        },
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                      buildModalButton(
                        'Rate',
                        () {
                          if (rating > 0) model.rateVenue(rating);
                          Navigator.of(context).pop();
                        },
                        AppThemes.successColor,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildObjectDetails(BuildContext ctx, VenuePageModel model) {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.venue.name.toUpperCase(),
            style: Theme.of(ctx).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          _buildVenueType(ctx, model),
          const SizedBox(height: 8),
          _buildVenueLocation(ctx, model),
          const SizedBox(height: 8),
          _buildAvailability(ctx, model),
          const SizedBox(height: 8),
          _buildVenueHours(ctx, model),
          const SizedBox(height: 8),
          _buildVenueRating(ctx, model),
          const SizedBox(height: 8),
          _buildRatingButton(ctx, model),
          _buildVenueDescription(ctx, model),
        ],
      ),
    );
  }

  Widget _buildRatingButton(BuildContext ctx, VenuePageModel model) {
    return FFButtonWidget(
      onPressed: () => _buildRatingModal(ctx, model),
      text: 'Leave a rating',
      showLoadingIndicator: false,
      options: FFButtonOptions(
        width: 128,
        height: 30,
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        color: Theme.of(ctx).colorScheme.surface,
        textStyle: const TextStyle(
          color: AppThemes.accent1,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        borderSide: const BorderSide(
          color: AppThemes.accent1,
          width: 1,
        ),
        elevation: 3,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildVenueType(BuildContext ctx, VenuePageModel model) {
    return Text(
      model.venueType.toFormattedUpperCase(),
      style: Theme.of(ctx).textTheme.bodyMedium,
    );
  }

  Widget _buildVenueLocation(BuildContext ctx, VenuePageModel model) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          CupertinoIcons.location_solid,
          color: Theme.of(ctx).colorScheme.onPrimary,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          model.venue.location,
          style: Theme.of(ctx).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildAvailability(BuildContext ctx, VenuePageModel model) {
    final ratio = model.venue.maximumCapacity > 0
        ? model.venue.availableCapacity / model.venue.maximumCapacity
        : 0.0;

    final Color availabilityColor = ratio >= 0.6
        ? AppThemes.successColor
        : ratio >= 0.3
            ? AppThemes.warningColor
            : Colors.red;

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          CupertinoIcons.person_2,
          color: availabilityColor,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          '${model.venue.availableCapacity} / ${model.venue.maximumCapacity} available',
          style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                color: availabilityColor,
              ),
        ),
      ],
    );
  }

  Widget _buildVenueHours(BuildContext ctx, VenuePageModel model) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          CupertinoIcons.clock,
          color: Theme.of(ctx).colorScheme.onPrimary,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          'Working hours: ${model.venue.workingHours}',
          style: Theme.of(ctx).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildVenueRating(BuildContext ctx, VenuePageModel model) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RatingBar.builder(
          onRatingUpdate: (_) => {},
          itemBuilder: (context, index) => const Icon(
            CupertinoIcons.star_fill,
            color: AppThemes.accent1,
          ),
          unratedColor: const Color(0xFF57636C).withOpacity(0.5),
          direction: Axis.horizontal,
          glow: false,
          ignoreGestures: true,
          initialRating: model.venue.rating,
          itemCount: 1,
          itemSize: 18,
          allowHalfRating: true,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 4),
          child: Text(
            ' ${model.venue.rating.toStringAsFixed(1)}',
            style: Theme.of(ctx).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildVenueDescription(BuildContext ctx, VenuePageModel model) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            'About this venue',
            style: Theme.of(ctx)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            model.venue.description ?? 'No description available',
            style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildMakeReservation(BuildContext ctx, VenuePageModel model) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Make a reservation',
                style: Theme.of(ctx)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontFamily: 'Roboto'),
              ),
              const SizedBox(height: 16),
              _buildPeopleButton(ctx, model),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _buildDatePicker(ctx, model),
                  const SizedBox(width: 22),
                  _buildTimeButton(ctx, model),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildPeopleButton(BuildContext ctx, VenuePageModel model) {
    return OutlinedButton(
      onPressed: () {},
      style: _reservationButtonsStyle(ctx),
      child: SizedBox(
        height: 46,
        width: 350,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.person_2,
              color: Theme.of(ctx).colorScheme.onPrimary,
              size: 28,
            ),
            const SizedBox(width: 12),
            _buildPeopleDropdown(ctx, model)
          ],
        ),
      ),
    );
  }

  Widget _buildPeopleDropdown(BuildContext ctx, VenuePageModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: DropdownButton<int>(
        value: model.selectedNumberOfPeople,
        hint: Text(
          'Select no. of people attending',
          style: Theme.of(ctx).textTheme.bodyLarge,
        ),
        style: Theme.of(ctx).textTheme.bodyLarge,
        dropdownColor: Theme.of(ctx).colorScheme.background,
        underline: Container(),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        items: List.generate(12, (i) => i + 1)
            .map((value) => DropdownMenuItem(
                  value: value,
                  child: Text(value == 1 ? '$value person' : '$value people'),
                ))
            .toList(),
        onChanged: (value) {
          model.setPeople(value);
        },
        selectedItemBuilder: (context) => List.generate(12, (i) => i + 1)
            .map((value) => DropdownMenuItem(
                  value: value,
                  child: Text(value == 1 ? '$value person' : '$value people'),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext ctx, VenuePageModel model) {
    DateFormat dateFormat = DateFormat('MMMM d, yyyy');
    var displayDate = model.selectedDate != null
        ? dateFormat.format(model.selectedDate!)
        : 'Select date';
    return OutlinedButton(
      onPressed: () => model.selectDate(ctx),
      style: _reservationButtonsStyle(ctx),
      child: SizedBox(
        height: 46,
        width: 148,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.calendar,
              color: Theme.of(ctx).colorScheme.onPrimary,
            ),
            const SizedBox(width: 12),
            Text(displayDate, style: Theme.of(ctx).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeButton(BuildContext ctx, VenuePageModel model) {
    return OutlinedButton(
      onPressed: () {},
      style: _reservationButtonsStyle(ctx),
      child: SizedBox(
        height: 46,
        width: 148,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.clock,
              color: Theme.of(ctx).colorScheme.onPrimary,
            ),
            const SizedBox(width: 12),
            _buildTimeDropdown(ctx, model)
          ],
        ),
      ),
    );
  }

  DropdownButton<TimeOfDay> _buildTimeDropdown(
    BuildContext ctx,
    VenuePageModel model,
  ) {
    return DropdownButton<TimeOfDay>(
      value: model.selectedTime,
      hint: Text(
        'Select time',
        style: Theme.of(ctx).textTheme.bodyLarge,
      ),
      style: Theme.of(ctx).textTheme.bodyLarge,
      dropdownColor: Theme.of(ctx).colorScheme.background,
      underline: Container(),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      items: model.timeOptions.map((time) {
        final formatted = time.format(ctx);
        return DropdownMenuItem(
          value: time,
          child: Text(formatted),
        );
      }).toList(),
      onChanged: (value) {
        model.setTime(value);
      },
    );
  }

  Widget _buildReserveSpotButton(BuildContext ctx, VenuePageModel model) {
    bool isDisabled = model.venue.availableCapacity == 0;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(36, 0, 36, 48),
      child: FFButtonWidget(
        onPressed: () => isDisabled ? null : model.reserve(),
        text: 'Reserve your spot now',
        options: FFButtonOptions(
          width: double.infinity,
          height: 60,
          padding: const EdgeInsetsDirectional.all(0),
          color: isDisabled ? Colors.grey : AppThemes.infoColor,
          splashColor: isDisabled
              ? AppThemes.transparentColour
              : Theme.of(ctx).colorScheme.surfaceVariant,
          textStyle: TextStyle(
            color: isDisabled
                ? Theme.of(ctx).colorScheme.background.withOpacity(0.4)
                : Theme.of(ctx).colorScheme.background,
            fontSize: 16,
          ),
          elevation: 3,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildMasonryView(List<String> imageUrls) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 96),
      child: MasonryGridView.builder(
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        crossAxisSpacing: 24,
        mainAxisSpacing: 12,
        itemCount: imageUrls.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final imageUrl = imageUrls[index];
          return InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FullScreenImageView(
                    imageUrl: imageUrl,
                    heroTag: 'imageTag$index',
                  ),
                ),
              );
            },
            child: Hero(
              tag: 'imageTag$index',
              transitionOnUserGestures: true,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imageUrl,
                  width: 160,
                  height: 170,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDivider(BuildContext ctx) {
    return Divider(
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: Theme.of(ctx).colorScheme.onPrimary.withOpacity(0.4),
    );
  }

  ButtonStyle _reservationButtonsStyle(BuildContext ctx) {
    return OutlinedButton.styleFrom(
      side: BorderSide(
        color: Theme.of(ctx).colorScheme.onPrimary,
        width: 1,
      ),
      splashFactory: NoSplash.splashFactory,
      elevation: 3,
      backgroundColor: Theme.of(ctx).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
