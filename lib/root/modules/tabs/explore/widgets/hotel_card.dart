import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/core/data/models/hotel.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/widgets/favorite_button.dart';
import 'package:shimmer/shimmer.dart';

class HotelCard extends StatefulWidget {
  final Hotel hotel;
  final bool initialSaveValue;
  final String? heroTag;
  final Function(bool) onSaveTap;
  final void Function() onTap;

  const HotelCard({
    super.key,
    required this.hotel,
    this.initialSaveValue = false,
    this.heroTag,
    required this.onSaveTap,
    required this.onTap,
  });

  @override
  State<HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {
  // ── Control Panel ─────────────────────────────────────────────────────────
  static const double _aspectRatio = 3 / 4; // flip to 3 / 4 for a portrait card
  static const double _radius = 30;
  static const double _inset = 12; // margin + padding around overlays
  static const Duration _fadeDuration = Duration(milliseconds: 350);

  // Shimmer — shared by the image placeholder and the text details,
  // both of which stay "loading" until the hotel image resolves.
  static const Color _shimmerBase = Color.fromARGB(255, 212, 212, 212);
  static const Color _shimmerHighlight = Color.fromARGB(255, 243, 243, 243);
  static const Duration _shimmerPeriod = Duration(milliseconds: 1200);

  static const Color _detailBg = Color(0xB3000000); // translucent dark panel
  static const Color _placeholderBg =
      CustomColors.cardSubtleBg; // shown until/if image fails
  static const Color _starColor = CustomColors.luxuryGold;

  static const TextStyle _nameStyle = TextStyle(
    color: CustomColors.textLight,
    fontWeight: FontWeight.w700,
    fontSize: 15,
    fontFamily: 'Fustat',
  );
  static const TextStyle _metaStyle = TextStyle(
    color: Color(0xCCFFFFFF),
    fontSize: 12,
    fontFamily: 'Fustat',
  );
  static const TextStyle _rateStyle = TextStyle(
    color: CustomColors.textLight,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    fontFamily: 'Fustat',
  );
  static const TextStyle _unitStyle = TextStyle(
    color: Color(0xCCFFFFFF),
    fontSize: 11,
    fontFamily: 'Fustat',
  );

  // ── Image load tracking ───────────────────────────────────────────────────
  ImageStream? _imageStream;
  late final ImageStreamListener _imageStreamListener;
  bool _imageLoaded = false;

  @override
  void initState() {
    super.initState();
    _imageStreamListener = ImageStreamListener(
      (image, synchronousCall) => _onImageResolved(),
      onError: (error, stackTrace) => _onImageResolved(),
    );
    _listenForImage();
  }

  @override
  void didUpdateWidget(covariant HotelCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hotel.imageUrl != widget.hotel.imageUrl) {
      _imageLoaded = false;
      _listenForImage();
    }
  }

  @override
  void dispose() {
    _imageStream?.removeListener(_imageStreamListener);
    super.dispose();
  }

  // Resolves the current hotel image so we know when to stop shimmering.
  void _listenForImage() {
    _imageStream?.removeListener(_imageStreamListener);
    final provider = CachedNetworkImageProvider(widget.hotel.imageUrl);
    _imageStream = provider.resolve(const ImageConfiguration());
    _imageStream!.addListener(_imageStreamListener);
  }

  void _onImageResolved() {
    if (!mounted || _imageLoaded) return;
    setState(() => _imageLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _aspectRatio,
      child: AnimatedSwitcher(
        duration: _fadeDuration,
        // HERO IMAGE
        child: Hero(
          tag: widget.heroTag ?? widget.hotel.imageUrl,
          child: Material(
            type: MaterialType.transparency,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(_radius),
            child: ClipRRect(
              key: ValueKey(widget.hotel.imageUrl),
              borderRadius: BorderRadius.circular(_radius),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 1. IMAGE
                  CachedNetworkImage(
                    imageUrl: widget.hotel.imageUrl,
                    fit: BoxFit.cover,
                    fadeInDuration: _fadeDuration,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: _shimmerBase,
                      highlightColor: _shimmerHighlight,
                      period: _shimmerPeriod,
                      child: Container(color: _shimmerBase),
                    ),
                    errorWidget: (context, url, error) =>
                        Container(color: _placeholderBg),
                  ),

                  // 2. PROMOTION BADGE
                  if (widget.hotel.activePromotion != null && widget.hotel.activePromotion?.isActive == true)
                    Positioned(
                      top: _inset,
                      left: _inset,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.local_offer_rounded, size: 14, color: Color(0xFF10141B)),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.hotel.activePromotion!.discountPercent}% OFF',
                              style: const TextStyle(
                                color: Color(0xFF10141B),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // 3. DETAILS
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: 0.25,
                      child: Padding(
                        padding: const EdgeInsets.all(_inset),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: _detailBg,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              children: [
                                // NAME + ADDRESS + RATING · CITY
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // NAME
                                      AnimatedSwitcher(
                                        duration: _fadeDuration,
                                        child: _imageLoaded
                                            ? Text(
                                                widget.hotel.name,
                                                key: const ValueKey('name-loaded'),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: _nameStyle,
                                              )
                                            : Shimmer.fromColors(
                                                key: const ValueKey('name-shimmer'),
                                                baseColor: _shimmerBase,
                                                highlightColor: _shimmerHighlight,
                                                period: _shimmerPeriod,
                                                child: Text(
                                                  widget.hotel.name,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: _nameStyle,
                                                ),
                                              ),
                                      ),
                                      const SizedBox(height: 2),

                                      // ADDRESS
                                      AnimatedSwitcher(
                                        duration: _fadeDuration,
                                        child: _imageLoaded
                                            ? Text(
                                                widget.hotel.address ?? "A City on Planet Earth",
                                                key: const ValueKey('address-loaded'),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: _metaStyle,
                                              )
                                            : Shimmer.fromColors(
                                                key: const ValueKey('address-shimmer'),
                                                baseColor: _shimmerBase,
                                                highlightColor: _shimmerHighlight,
                                                period: _shimmerPeriod,
                                                child: Text(
                                                  widget.hotel.address ?? "A City on Planet Earth",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: _metaStyle,
                                                ),
                                              ),
                                      ),
                                      const SizedBox(height: 2),

                                      // STAR (static) + RATING · CITY (shimmers)
                                      Row(
                                        children: [
                                          const Icon(Icons.star_rounded, size: 13, color: _starColor),
                                          const SizedBox(width: 2),
                                          Expanded(
                                            child: AnimatedSwitcher(
                                              duration: _fadeDuration,
                                              child: _imageLoaded
                                                  ? Row(
                                                      key: const ValueKey('rating-loaded'),
                                                      children: [
                                                        Text(
                                                          widget.hotel.rating.toStringAsFixed(1),
                                                          style: _metaStyle,
                                                        ),
                                                        const Text('  ·  ', style: _metaStyle),
                                                        Flexible(
                                                          child: Text(
                                                            widget.hotel.city,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: _metaStyle,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Shimmer.fromColors(
                                                      key: const ValueKey('rating-shimmer'),
                                                      baseColor: _shimmerBase,
                                                      highlightColor: _shimmerHighlight,
                                                      period: _shimmerPeriod,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            widget.hotel.rating.toStringAsFixed(1),
                                                            style: _metaStyle,
                                                          ),
                                                          const Text('  ·  ', style: _metaStyle),
                                                          Flexible(
                                                            child: Text(
                                                              widget.hotel.city,
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: _metaStyle,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // RATE / NIGHT
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (widget.hotel.activePromotion != null && widget.hotel.activePromotion?.isActive == true && widget.hotel.activePromotion?.discountPercent != null)
                                      Text(
                                        '\$${widget.hotel.rates.first}',
                                        style: _unitStyle.copyWith(decoration: TextDecoration.lineThrough),
                                      ),
                                    Text(
                                      '\$${widget.hotel.activePromotion != null && widget.hotel.activePromotion?.isActive == true && widget.hotel.activePromotion?.discountPercent != null ? (widget.hotel.rates.first * (1 - widget.hotel.activePromotion!.discountPercent! / 100)).round() : widget.hotel.rates.first}',
                                      style: _rateStyle,
                                    ),
                                    const Text('/night', style: _unitStyle),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 4. RIPPLE OVERLAY
                  // Covers the image and the details so that the whole card is tappable.
                  // Placed before the FavoriteButton so that it doesn't swallow its taps.
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.onTap,
                        splashColor: Colors.black12,
                        highlightColor: Colors.black12,
                      ),
                    ),
                  ),

                  // 5. FAVORITE
                  Positioned(
                    top: _inset,
                    right: _inset,
                    child: FavoriteButton(
                      value: widget.initialSaveValue,
                      onChanged: widget.onSaveTap,
                    ),
                  ),
                ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
