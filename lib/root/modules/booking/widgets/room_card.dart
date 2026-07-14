import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:majestic_rooms/core/theme/theme_context_extension.dart';
import 'package:majestic_rooms/core/data/models/hotel_room.dart';
import 'package:majestic_rooms/core/utils/currency_format.dart';
import 'package:majestic_rooms/root/modules/hotel/screens/image_viewer_screen.dart';
import 'package:majestic_rooms/root/modules/hotel/widgets/image_carousel.dart';
import 'package:get/get.dart';

class RoomCard extends StatelessWidget {
  final HotelRoom room;
  final String? hotelImageUrl;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const RoomCard({
    super.key,
    required this.room,
    this.hotelImageUrl,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = quantity > 0;
    return GestureDetector(
      onTap: quantity == 0 ? onIncrement : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: CustomColors.cardSubtleBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? context.primaryColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: context.primaryColor.withOpacity(0.15),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // IMAGE
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ImageCarousel(
                  images: (room.images != null && room.images!.isNotEmpty)
                      ? room.images!.map((e) => e.url).toList()
                      : [
                          hotelImageUrl ??
                              'https://images.unsplash.com/photo-1611892440504-42a792e24d32?q=80&w=600&auto=format&fit=crop',
                        ],
                  heroTagPrefix: 'room_${room.id ?? room.hashCode}',
                  onImageTap: (index) {
                    final urls =
                        (room.images != null && room.images!.isNotEmpty)
                        ? room.images!.map((e) => e.url).toList()
                        : [
                            hotelImageUrl ??
                                'https://images.unsplash.com/photo-1611892440504-42a792e24d32?q=80&w=600&auto=format&fit=crop',
                          ];
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return ImageViewerScreen(
                            imageUrls: urls,
                            initialIndex: index,
                            heroTagPrefix: 'room_${room.id ?? room.hashCode}',
                          );
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                      ),
                    );
                  },
                ),
              ),

              // DETAILS
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // INFO
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.name?.tr ??
                                room.category?.name.tr ??
                                "Standard Room".tr,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: context.textMainColor,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              if (room.beds != null) ...[
                                Icon(
                                  Icons.king_bed_outlined,
                                  size: 18,
                                  // color: context.textLightColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  room.beds == 1
                                      ? 'bed_count'.trParams({
                                          'count': room.beds.toString(),
                                        })
                                      : 'beds_count'.trParams({
                                          'count': room.beds.toString(),
                                        }),
                                  style: TextStyle(
                                    fontSize: 14,
                                    // color: context.textLightColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 16),
                              ],
                              if (room.roomNumber != null) ...[
                                Icon(
                                  Icons.tag_rounded,
                                  size: 16,
                                  // color: context.textLightColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  room.roomNumber!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    // color: context.textLightColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),

                          // CHIPS
                          if (room.category != null || room.cityView == true)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Wrap(
                                spacing: 6,
                                children: [
                                  if (room.category != null)
                                    Builder(
                                      builder: (context) {
                                        final bool isStandard =
                                            room.category?.isStandard ?? true;
                                        return Chip(
                                          label: Text(
                                            room.category!.name.tr,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: isStandard
                                                  ? CustomColors.primaryDark
                                                  : context.tertiaryColor,
                                            ),
                                          ),
                                          backgroundColor: isStandard
                                              ? context.borderColor.withOpacity(
                                                  0.85,
                                                )
                                              : context.tertiaryColor
                                                    .withOpacity(0.15),
                                          side: BorderSide(
                                            color: isStandard
                                                ? context.textMutedColor
                                                      .withOpacity(0.5)
                                                : context.tertiaryColor,
                                            width: 0.8,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                          visualDensity: VisualDensity.compact,
                                        );
                                      },
                                    ),
                                  if (room.cityView == true)
                                    Chip(
                                      label: Text(
                                        'City View'.tr,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: context.tertiaryColor,
                                        ),
                                      ),
                                      backgroundColor: context.tertiaryColor
                                          .withOpacity(0.15),
                                      side: BorderSide(
                                        color: context.tertiaryColor,
                                        width: 0.8,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                ],
                              ),
                            ),

                          // DESCRIPTION
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, right: 10),
                            child: Text(
                              room.description?.trim().isNotEmpty == true
                                  ? room.description!
                                  : 'No information given'.tr,
                              style: TextStyle(
                                fontSize: 13,
                                color: context.textMutedColor,
                                fontStyle:
                                    room.description?.trim().isNotEmpty == true
                                    ? FontStyle.normal
                                    : FontStyle.italic,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // PRICE
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                formatPrice(room.pricePerNight),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: context.primaryColor,
                                ),
                              ),
                              Text(
                                " / night".tr,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: context.textMutedColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          // BREAKFAST PRICE
                          if (room.pricePerNightWithBreakfast != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'with_breakfast'.trParams({
                                  'price': formatPrice(
                                    room.pricePerNightWithBreakfast!,
                                  ),
                                }),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.textMutedColor.withOpacity(
                                    0.8,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // SELECTION STEPPER
                    Container(
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected
                              ? context.primaryColor
                              : context.borderColor.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: onDecrement,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? context.primaryColor.withOpacity(0.1)
                                    : context.surfaceColor,
                              ),
                              child: Icon(
                                isSelected && quantity == 1
                                    ? Icons.delete_outline
                                    : Icons.remove,
                                size: 18,
                                color: isSelected
                                    ? context.primaryColor
                                    : context.hintColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 32,
                            child: Text(
                              quantity.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? context.textMainColor
                                    : context.hintColor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: onIncrement,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.primaryColor,
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
